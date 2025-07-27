output "vpc_id" {
  description = "The ID of the created VPC."
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "The ID of the created public subnet."
  value       = aws_subnet.public.id
}

output "internet_gateway_id" {
  description = "The ID of the created Internet Gateway."
  value       = aws_internet_gateway.gw.id
}
