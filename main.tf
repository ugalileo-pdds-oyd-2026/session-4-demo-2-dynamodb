module "event_log" {
  source = "./modules/dynamodb-table"

  table_name    = "event-log-${var.environment}"
  environment   = var.environment
  billing_mode  = "PAY_PER_REQUEST"
  ttl_attribute = "expires_at"

  tags = {
    Service = "event-collector"
  }
}
