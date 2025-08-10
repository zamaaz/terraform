variable "function_name" {
  description = "The name of the Lambda Function"
  type        = string
  default     = "lambda_function"
}

variable "api_name" {
  description = "The name of the Lambda API"
  type        = string
  default     = "lambda_api"
}

variable "api_path" {
  description = "The path of the Lambda API"
  type        = string
  default     = "hello"
}

variable "iam_role_name" {
  description = "The name of the role."
  type        = string
  default     = "lambda_role"
}
