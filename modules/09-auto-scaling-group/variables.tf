variable "name_prefix" {
  description = "A prefix to use for naming all resources."
  type        = string
  default     = "my-app"
}

variable "ami_id" {
  description = "The AMI ID for the instances."
  type        = string
  default     = "ami-0f5ee92e2d63afc18"
}

variable "instance_type" {
  description = "The instance type for the instances."
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "The key pair to associate with the instances for SSH access."
  type        = string
}

variable "iam_instance_profile_arn" {
  description = "The ARN of the IAM instance profile to attach to the instances."
  type        = string
}

variable "user_data" {
  description = "A script to run on instance startup. Will be base64 encoded."
  type        = string
  default     = <<-EOT
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y apache2
              sudo systemctl start apache2
              sudo systemctl enable apache2
              echo "<h1>Hello from $(hostname -f)</h1>" > /var/www/html/index.html
              EOT
}

variable "min_size" {
  description = "The minimum number of instances in the Auto Scaling Group."
  type        = number
  default     = 1
}

variable "max_size" {
  description = "The maximum number of instances in the Auto Scaling Group."
  type        = number
  default     = 3
}

variable "desired_capacity" {
  description = "The desired number of instances to start with."
  type        = number
  default     = 2
}

variable "vpc_id" {
  description = "The ID of the VPC to deploy the resources into."
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs for the Auto Scaling Group to launch instances in."
  type        = list(string)
}

variable "target_group_arns" {
  description = "A list of ALB Target Group ARNs to attach the instances to."
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "The ID of the security group for the ALB to allow traffic from."
  type        = string
}
