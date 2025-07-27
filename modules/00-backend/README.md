# Terraform Remote State Infrastructure

This project is the foundational layer for all other Terraform projects in this repository. Its sole purpose is to provision the necessary AWS resources for secure and collaborative remote state management.

## Resources Created

1.  **S3 Bucket (`aws_s3_bucket`)**: A private, versioned, and encrypted S3 bucket to store the `terraform.tfstate` files for all other projects.
2.  **DynamoDB Table (`aws_dynamodb_table`)**: A DynamoDB table used for state locking to prevent multiple users from running `terraform apply` at the same time and corrupting the state.

## How to Use

This project should be the **first thing you run** when setting up this environment.

1.  Navigate to this `00-backend` directory.
2.  (Optional) Update the `s3_bucket_name` in `variables.tf` to a unique name.
3.  Run `terraform init`.
4.  Run `terraform apply`.

Once these resources are created, you can proceed to the other projects (e.g., `01-vpc`, `02-ec2`).

---

## How to Destroy This Infrastructure

This project includes a `prevent_destroy` lifecycle rule and does not automatically empty the bucket before deletion. If you need to destroy these resources, you must follow these steps:

> **Warning:** Destroying these resources will delete the S3 bucket containing **all Terraform state files** for all other projects. This action is irreversible and will orphan your existing infrastructure, making it very difficult to manage with Terraform. Proceed with extreme caution.

1.  **Edit `main.tf`**: Open the `main.tf` file in this directory.
2.  **Modify the S3 Bucket Resource**:
    * Comment out the `lifecycle` block.
    * Add the `force_destroy = true` argument.
    The resource should look like this:
    ```terraform
    resource "aws_s3_bucket" "terraform_state" {
      bucket = var.s3_bucket_name

      # lifecycle {
      #   prevent_destroy = true
      # }

      force_destroy = true
      
      # ... rest of the resource
    }
    ```
3.  **Apply the changes**: Run `terraform apply` to update the bucket settings.
4.  **Destroy**: Now, run `terraform destroy`. This will succeed because Terraform is now allowed to empty the bucket before deleting it.
