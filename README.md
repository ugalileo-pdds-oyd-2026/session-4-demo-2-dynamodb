# Session 4 — RDS Postgres Blog Database Module

Build a complete AWS RDS Postgres module with Terraform, wiring together a security group, subnet group, parameter group, and db instance in dependency order.

## What students learn

- How Terraform's dependency graph handles resource ordering automatically when you reference outputs between resources
- Why `sensitive = true` on a variable hides values from plan output — and why the credential still ends up in `terraform.tfstate`
- How to restrict database ingress to a private CIDR range (`10.0.0.0/8`) instead of the open internet
- Why an explicit `aws_db_subnet_group` is required so RDS knows which AZs it can use
- How `aws_db_parameter_group` lets you tune Postgres settings without SSH access to the instance
- Why `storage_encrypted = true` and `backup_retention_period` matter for production databases

## Project structure

```
.
├── start/               # starting skeleton — provider + empty module
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── modules/
│       └── rds/
│           ├── main.tf
│           ├── variables.tf
│           └── outputs.tf
└── envs/
    └── dev/
        └── dev.tfvars   # variable values for the dev environment
```

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) ≥ 1.0
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) configured with credentials
- A VPC ID and two private subnet IDs in your AWS account

## Demo workflow

### 1. Initialize Terraform

```bash
cd start
terraform init
```

### 2. Show the module structure

```bash
tree .
```

### 3. Write `variables.tf` — database credentials and sizing

Add the following variables to `modules/rds/variables.tf`:

- `db_name`, `db_username`, `db_password` (mark this one `sensitive = true`), `instance_class`, `allocated_storage`
- `vpc_id`, `subnet_ids`, `environment`

> `sensitive = true` on `db_password` prevents the value from appearing in plan output and logs. The credential is still stored in `terraform.tfstate` — which is why state encryption matters.

### 4. Write the security group resource

Add `aws_security_group` to `modules/rds/main.tf` with ingress locked to `10.0.0.0/8` on port 5432.

### 5. Write the subnet group and parameter group resources

Add `aws_db_subnet_group` and `aws_db_parameter_group` to `modules/rds/main.tf`.

> The subnet group tells RDS which AZs it can use. Always define it explicitly — without it, RDS falls back to the default VPC, which may not exist.

### 6. Write the `aws_db_instance` resource

Add the full `aws_db_instance` to `modules/rds/main.tf`, referencing the subnet group, parameter group, and security group created above. Include `storage_encrypted = true` and `backup_retention_period = 7`.

### 7. Write `outputs.tf`

Expose `endpoint`, `db_name`, and `arn` from `modules/rds/outputs.tf`.

### 8. Wire the root `main.tf`

Call `module "blog_db"` in the root `main.tf`, passing your VPC ID and subnet IDs.

### 9. Plan

Set your database password as an environment variable, then run the plan:

```bash
export TF_VAR_db_password=YourSecurePassword123
terraform plan -var-file=envs/dev/dev.tfvars
```

Expected output:

```
Plan: 4 to add, 0 to change, 0 to destroy.
```

### 10. Apply

```bash
terraform apply -var-file=envs/dev/dev.tfvars -auto-approve
```

> RDS provisioning takes 5–10 minutes. This is normal — wait for the apply to complete before verifying outputs.

### 11. Clean up

```bash
terraform destroy -var-file=envs/dev/dev.tfvars -auto-approve
```

## Expected outcomes

By the end of this demo, students should be able to:

1. Build a multi-resource Terraform module where resources depend on each other, and explain how Terraform resolves the order automatically
2. Mark a variable `sensitive` and explain both what it protects (plan output) and what it does not protect (state file)
3. Restrict RDS network access to a private CIDR range using a security group
4. Explain why an explicit subnet group and parameter group are required for production-grade RDS instances
5. Enable storage encryption and automated backups with two Terraform arguments
