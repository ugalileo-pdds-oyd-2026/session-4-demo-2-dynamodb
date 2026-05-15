resource "aws_dynamodb_table" "this" {
  name         = var.table_name
  billing_mode = var.billing_mode
  hash_key     = "event_id"
  range_key    = "created_at"

  attribute {
    name = "event_id"
    type = "S"
  }
  attribute {
    name = "created_at"
    type = "S"
  }
  attribute {
    name = "user_id"
    type = "S"
  }

  global_secondary_index {
    name            = "UserIdCreatedAtIndex"
    projection_type = "ALL"
    hash_key        = "user_id"
    range_key       = "created_at"
  }

  ttl {
    attribute_name = var.ttl_attribute
    enabled        = true
  }

  server_side_encryption {
    enabled = true
  }

  tags = merge(var.tags, { Environment = var.environment })
}
