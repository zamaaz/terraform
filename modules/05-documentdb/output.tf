output "docdb_cluster_endpoint" {
  description = "The connection endpoint for the DocumentDB cluster."
  value       = aws_docdb_cluster.docdb.endpoint
}

output "docdb_cluster_id" {
  description = "The ID of the DocumentDB cluster."
  value       = aws_docdb_cluster.docdb.id
}

output "docdb_cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the DocumentDB cluster."
  value       = aws_docdb_cluster.docdb.arn
}

output "docdb_security_group_id" {
  description = "The ID of the security group for the DocumentDB cluster."
  value       = aws_security_group.docdb_sg.id
}
