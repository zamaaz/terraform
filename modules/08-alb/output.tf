output "lb_dns_name" {
  description = "The public DNS name of the Application Load Balancer."
  value       = aws_lb.default.dns_name
}

output "lb_arn" {
  description = "The ARN of the Application Load Balancer."
  value       = aws_lb.default.arn
}

output "target_group_arn" {
  description = "The ARN of the main target group."
  value       = aws_lb_target_group.default.arn
}

output "lb_security_group_id" {
  description = "The ID of the security group associated with the Load Balancer."
  value       = aws_security_group.alb_sg.id
}
