output "dynamodb_table_name" {
  description = "The name of the DynamoDB table."
  value       = aws_dynamodb_table.main.name
}

output "dynamodb_table_arn" {
  description = "The Amazon Resource Name (ARN) of the DynamoDB table."
  value       = aws_dynamodb_table.main.arn
}