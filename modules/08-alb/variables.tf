variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "ap-south-1"
}

variable "lb_name" {
  description = "The name for the Application Load Balancer."
  type        = string
  default     = "my-app-lb"
}

variable "internal" {
  description = "Set to true for an internal load balancer, false for public."
  type        = bool
  default     = false
}

variable "target_group_port" {
  description = "The port on which the targets (e.g., EC2 instances) listen."
  type        = number
  default     = 80
}

variable "health_check_path" {
  description = "The destination for the health check requests."
  type        = string
  default     = "/"
}

variable "subnet_ids" {
  description = "A list of at least two subnet IDs for the DB subnet group."
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "target_ec2_instance_ids" {
  description = "A list of EC2 instance IDs to attach to the target group."
  type        = list(string)
}
