terraform {
  backend "s3" {
    bucket         = "project-backend-ka-naam"
    key            = "iam/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "users-table"
  }
}
