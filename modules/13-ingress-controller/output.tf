output "lb_controller_role_arn" {
  description = "The ARN of the IAM role for the AWS Load Balancer Controller."
  value       = aws_iam_role.lb_controller_role.arn
}
