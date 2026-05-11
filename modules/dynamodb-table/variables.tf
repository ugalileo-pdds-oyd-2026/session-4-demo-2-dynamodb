variable "table_name"  { type = string }
variable "environment" { type = string }
variable "billing_mode" {
  type    = string
  default = "PAY_PER_REQUEST"
}
variable "ttl_attribute" {
  type    = string
  default = "expires_at"
}
variable "tags" {
  type = map(string)
  default = {}
}
