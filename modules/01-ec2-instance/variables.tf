variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "ap-south-1"
}

variable "ec2_ami" {
  description = "The AWS ami id"
  type        = string
  default     = "ami-0f5ee92e2d63afc18"
}

variable "instance_type" {
  description = "The EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key Pair"
  type        = string
}

variable "user_data" {
  description = "User data script to run on instance startup."
  type        = string
  default     = null
}

variable "iam_instance_profile_name" {
  description = "The IAM instance profile to attach to the EC2 instance."
  type        = string
}

variable "alb_security_group_id" {
  description = "The security group ID of the ALB to allow traffic from."
  type        = string
  default     = null
}