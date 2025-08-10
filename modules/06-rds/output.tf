output "db_instance_endpoint" {
  description = "The connection endpoint for the RDS instance (address:port)."
  value       = aws_db_instance.default.endpoint
}

output "db_instance_name" {
  description = "The identifier of the RDS instance."
  value       = aws_db_instance.default.identifier
}

output "db_instance_username" {
  description = "The master username for the database."
  value       = aws_db_instance.default.username
}

output "db_instance_arn" {
  description = "The ARN of the RDS instance."
  value       = aws_db_instance.default.arn
}

output "db_security_group_id" {
  description = "The ID of the security group associated with the RDS instance."
  value       = aws_security_group.db_sg.id
}
