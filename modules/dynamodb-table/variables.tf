variable "table_name" {
  type        = string
  description = "Name of the DynamoDB table"
}
variable "environment" {
  type        = string
  description = "Environment for the DynamoDB table (e.g., dev, staging, prod)"
}
variable "billing_mode" {
  type        = string
  default     = "PAY_PER_REQUEST"
  description = "Billing mode for the DynamoDB table (e.g., PROVISIONED, PAY_PER_REQUEST)"
}
variable "ttl_attribute" {
  type        = string
  default     = "expires_at"
  description = "Name of the attribute used for Time To Live (TTL) in the DynamoDB table"
}
variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to the DynamoDB table"
}
