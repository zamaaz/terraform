variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "ap-south-1"
}

variable "name_prefix" {
  description = "A prefix to use for naming all resources (ECR repo, service, task, etc.)."
  type        = string
  default     = "my-app"
}

variable "container_image" {
  description = "The URL of the Docker container image to run (e.g., from ECR)."
  type        = string
  default     = "public.ecr.aws/nginx/nginx:latest"
}

variable "container_port" {
  description = "The port the container listens on."
  type        = number
  default     = 80
}

variable "task_cpu" {
  description = "The number of CPU units to allocate to the task."
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "The amount of memory (in MiB) to allocate to the task."
  type        = number
  default     = 512
}

variable "desired_tasks_count" {
  description = "The desired number of tasks (containers) to keep running."
  type        = number
  default     = 2
}

variable "vpc_id" {
  description = "The ID of the VPC to deploy the service into."
  type        = string
}

variable "subnet_ids" {
  description = "A list of private subnet IDs to launch the tasks in."
  type        = list(string)
}

variable "alb_target_group_arn" {
  description = "The ARN of the ALB Target Group to attach the tasks to."
  type        = string
}

variable "alb_security_group_id" {
  description = "The ID of the security group for the ALB to allow traffic from."
  type        = string
}
