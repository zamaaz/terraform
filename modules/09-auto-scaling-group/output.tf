output "autoscaling_group_name" {
  description = "The name of the Auto Scaling Group."
  value       = aws_autoscaling_group.default.name
}

output "autoscaling_group_arn" {
  description = "The ARN of the Auto Scaling Group."
  value       = aws_autoscaling_group.default.arn
}

output "launch_template_name" {
  description = "The name of the Launch Template."
  value       = aws_launch_template.default.name
}
