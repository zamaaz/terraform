# Terraform AWS S3 Bucket

This Terraform project provisions a private Amazon S3 bucket with best-practice configurations applied. It is designed to be a secure, versioned storage location suitable for a wide range of applications.

## Features & Resources Created

This configuration will create the following resources:

1.  **S3 Bucket (`aws_s3_bucket`)**: The core storage bucket. Its name is configurable and must be globally unique.
2.  **Bucket Versioning (`aws_s3_bucket_versioning`)**: Enables versioning on the bucket to protect against accidental data deletion or overwrites by keeping a history of all object versions.
3.  **Public Access Block (`aws_s3_bucket_public_access_block`)**: A crucial security feature that is applied to the bucket to ensure it remains private and is not accidentally exposed to the public internet.

## File Structure

The project is organized into three separate files for clarity and maintainability:

```
.
├── main.tf
├── variables.tf
└── output.tf
```

## Prerequisites

Before you begin, ensure you have the following installed and configured.

> **Tip for Easier Setup:**
> To automate the installation and configuration of Terraform and the AWS CLI, you can use the `setup.sh` script I created. It handles the necessary steps for macOS, Linux, and Windows.

If you prefer to set up manually:

1.  **Terraform**: [Download and install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli).
2.  **AWS CLI**: [Install and configure the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) with your credentials.
3.  **AWS Account**: An active AWS account.

---

## State Management

This project is configured to use a remote backend in AWS S3 for state management and DynamoDB for state locking. This ensures that the state is stored securely and prevents conflicts during team collaboration.

Before running `terraform init` for this project, you must ensure that the backend infrastructure from the `00-backend` project has been created.

---

## Configuration

### `variables.tf`

This file allows you to customize the deployment. You **must** change the `bucket_name` to a unique value.

- **`bucket_name`**: **(Required)** The name for your S3 bucket. S3 bucket names must be globally unique across all AWS accounts. You must change the default value.
- **`aws_region`**: The AWS region where your bucket will be created.

<!-- end list -->

```terraform
# variables.tf

variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "ap-south-1"
}

variable "bucket_name" {
  description = "The name of the S3 bucket. Must be globally unique."
  type        = string
  # IMPORTANT: Change this to a unique name!
  default     = "kuch-bhi-bucket-ka-naam"
}
```

### `main.tf`

This file contains the main logic that defines the S3 bucket and its related configurations like versioning and public access blocks.

### `output.tf`

This file declares the important attributes of the bucket that will be displayed after it is successfully created.

## How to Use

1.  **Create the Files:** Save the provided code into the three files (`main.tf`, `variables.tf`, `output.tf`) in a new directory.
2.  **Update Bucket Name:** Open `variables.tf` and change the default value of the `bucket_name` variable to a unique name.
3.  **Initialize Terraform:** Open your terminal, navigate to the directory where you saved the files, and run:
    ```bash
    terraform init
    ```
    This command initializes the working directory and downloads the necessary AWS provider plugin.
4.  **Apply the Configuration:** Run the apply command to create the resources.
    ```bash
    terraform apply
    ```
    Terraform will show you an execution plan. Type `yes` and press Enter to confirm.
5.  **Review the Output:** After the apply is complete, Terraform will display the name and domain of the created S3 bucket.
    ```
    # Example Output:
    # s3_bucket_domain_name = "your-unique-bucket-name.s3.amazonaws.com"
    # s3_bucket_id = "your-unique-bucket-name"
    ```

## Cleaning Up

When you are finished, you can destroy all the resources created by this configuration. **Note:** This will delete the S3 bucket. By default, Terraform cannot delete a bucket that contains objects. You must empty the bucket first.

Run the following command in the same directory:

```bash
terraform destroy
```

Type `yes` and press Enter to confirm the destruction of the resources.
