provider "aws" {
  region = "eu-central-1"
}

module "dynamodb" {
  source         = "./dynamodb"
  table_name     = "Table1"
  read_capacity  = "20"
  write_capacyty = "20"
  hash_key       = "1234"
  range_key      = "range"

}

output "Create_table" {
  value = module.dynamodb.table_name
}
