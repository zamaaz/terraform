variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "ap-south-1"
}

variable "table_name" {
  description = "The name of the DynamoDB table."
  type        = string
  default     = "users-table"
}

variable "hash_key" {
  description = "The name of the primary key attribute."
  type        = string
  default     = "UserId"
}

variable "billing_mode" {
  description = "Controls how you are charged for read/write throughput."
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "hash_key_type" {
  description = "The data type of the primary key (S for String, N for Number)."
  type        = string
  default     = "S"
}