provider "aws" {
  region = var.aws_region
}

resource "aws_dynamodb_table" "main" {
  name = var.table_name
  billing_mode = var.billing_mode
  hash_key = var.hash_key
  
  attribute {
    name = var.hash_key
    type = var.hash_key_type
  }

  tags = {
    Name        = "My-DynamoDB-Table"
    Environment = "Dev"
    ManagedBy   = "Terraform"
  }
}