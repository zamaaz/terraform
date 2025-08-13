variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "ap-south-1"
}

variable "cluster_name" {
  description = "A unique name for the EKS cluster."
  type        = string
  default     = "my-eks-cluster"
}
