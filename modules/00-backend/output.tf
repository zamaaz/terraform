output "bucket_name" {
  description = "The name of the S3 bucket created for Terraform state."
  value       = aws_s3_bucket.terraform_state.id
}

output "table_name" {
  description = "The name of the DynamoDB table for state locking."
  value       = aws_dynamodb_table.terraform_state_lock.name
}