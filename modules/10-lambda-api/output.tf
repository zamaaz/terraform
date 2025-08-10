output "api_endpoint_url" {
  description = "The endpoint of the Lambda API"
  value       = aws_apigatewayv2_api.lambda_api.api_endpoint
}
