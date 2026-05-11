# TODO: implement in this order during the demo:
#   1. aws_dynamodb_table with hash_key=event_id, range_key=created_at
#   2. attributes: event_id (S), created_at (S), user_id (S)
#   3. global_secondary_index on user_id + created_at (projection_type=ALL)
#   4. ttl block (attribute_name = var.ttl_attribute)
#   5. server_side_encryption block (enabled = true)
