variable "iam_role_name" {
  description = "The name of the role."
  type        = string
  default     = "access_role"
}

variable "s3_bucket_name" {
  description = "the name of th S3 bucket."
  type        = string
  default     = "kuch-bhi-bucket-ka-naam"
}
