output "ecr_repository_url" {
  description = "The URL of the ECR repository."
  value       = aws_ecr_repository.default.repository_url
}

output "ecs_cluster_name" {
  description = "The name of the ECS cluster."
  value       = aws_ecs_cluster.default.name
}

output "ecs_service_name" {
  description = "The name of the ECS service."
  value       = aws_ecs_service.default.name
}
