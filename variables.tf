variable "region" {
  type    = string
  default = "us-west-2"
}
variable "environment" {
  type        = string
  description = "Environment for the DynamoDB table (e.g., dev, staging, prod)"
}
