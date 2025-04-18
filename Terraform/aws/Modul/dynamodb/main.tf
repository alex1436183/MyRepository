resource "aws_dynamodb_table" "dynamodb" {
  name           = var.table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacyty
  hash_key       = var.hash_key
  range_key      = var.range_key


  attribute {
    name = var.hash_key
    type = "S"
  }

  attribute {
    name = var.range_key
    type = "S"
  }
}


