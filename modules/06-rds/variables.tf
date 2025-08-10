variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "ap-south-1"
}

variable "engine" {
  description = "The database engine to use."
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "The engine version to use."
  type        = string
  default     = "8.0"
}

variable "instance_class" {
  description = "The instance type of the RDS instance."
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "The allocated storage in gibibytes."
  type        = number
  default     = 20
}

variable "db_name" {
  description = "The name of the database to create when the DB instance is created."
  type        = string
  default     = "mydb"
}

variable "username" {
  description = "Username for the master DB user."
  type        = string
  default     = "admin"
}

variable "password" {
  description = "Password for the master DB user."
  type        = string
  default     = "mustbeeightchars"
  sensitive   = true
}

variable "subnet_ids" {
  description = "A list of at least two subnet IDs for the DB subnet group."
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = ""
}

variable "vpc_cidr_block" {
  description = "The CIDR block of the VPC."
  type        = string
  default     = ""
}

variable "security_group" {
  description = "The EC2 security group ID"
  type        = list(string)
  default     = []
}
