variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "ap-south-1"
}

variable "cluster_identifier" {
  description = "A unique name of the cluster"
  type        = string
  default     = "my-docdb-cluster"
}

variable "instance_class" {
  description = "The size of the database instances"
  type        = string
  default     = "db.t3.medium"
}

variable "instance_count" {
  description = "The number of instances in th cluster"
  type        = number
  default     = 1
}

variable "master_username" {
  description = "The main admin username for the database"
  type        = string
  default     = "admin"
}

variable "master_password" {
  description = "The password for the admin user"
  type        = string
  default     = "mustbeeightchars" # <-- CHANGE THIS
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "List of Subnet IDs"
  type        = list(string)
}

variable "vpc_cidr_block" {
  description = "The CIDR block of the VPC."
  type        = string
  default     = "172.31.0.0/16" # <-- CHANGE THIS
}
