Of course. Here is the content from the README file in Markdown format:

# Terraform AWS DynamoDB Table

This Terraform project provisions a simple but functional Amazon DynamoDB table. I have configured it with a primary key and a flexible, pay-as-you-go billing model, making it perfect for development or new applications.

## Features & Resources Created

This configuration will create a single `aws_dynamodb_table` resource with the following features:

1.  **Custom Table Name**: You can easily set the name for the table.
2.  **Defined Primary Key**: I have set up a primary key (hash key) which you can name and define the data type for (String or Number).
3.  **On-Demand Billing**: The table is configured for `PAY_PER_REQUEST` billing by default. This is a cost-effective choice, as you only pay for the read and write operations you actually perform.
4.  **Tags**: The resource is tagged for easy identification and cost tracking.

## File Structure

The project is organized into three separate files for clarity:

```
.
├── main.tf
├── variables.tf
└── output.tf
```

## Prerequisites

Before you begin, you should ensure the following are installed and configured on your local machine.

> **Tip for Easier Setup:**
> To automate the installation and configuration of Terraform and the AWS CLI, you can use the `setup.sh` script I created. It handles the necessary steps for macOS, Linux, and Windows.

If you prefer to set up manually:

1.  **Terraform**: [Download](https://learn.hashicorp.com/tutorials/terraform/install-cli) and install[ Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli).
2.  **AWS CLI**: [Install](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) and configure[ the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) with your credentials.
3.  **AWS Account**: An active AWS account.

---

## State Management

This project is configured to use a remote backend in AWS S3 for state management and DynamoDB for state locking. This ensures that the state is stored securely and prevents conflicts during team collaboration.

Before running `terraform init` for this project, you must ensure that the backend infrastructure from the `00-backend` project has been created.

---

## Configuration

### `variables.tf`

In this file, I have defined all the inputs you can use to customize the DynamoDB table.

- **`aws_region`**: The AWS region where your table will be created.
- **`table_name`**: The unique name for the DynamoDB table.
- **`billing_mode`**: How you are charged. Defaults to `PAY_PER_REQUEST`.
- **`hash_key`**: The name of the primary key attribute (e.g., "UserId", "ProductId").
- **`hash_key_type`**: The data type for the primary key. Use `S` for String or `N` for Number.

<!-- end list -->

```terraform
# variables.tf

variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "ap-south-1"
}

variable "table_name" {
  description = "The name of the DynamoDB table."
  type        = string
  default     = "my-terraform-users-table"
}

variable "billing_mode" {
  description = "Controls how you are charged for read/write throughput (PROVISIONED or PAY_PER_REQUEST)."
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "hash_key" {
  description = "The name of the primary key attribute (e.g., UserId)."
  type        = string
  default     = "UserId"
}

variable "hash_key_type" {
  description = "The data type of the primary key (S for String, N for Number, B for Binary)."
  type        = string
  default     = "S"
}
```

### `main.tf`

This file contains the main logic that defines the `aws_dynamodb_table` resource, using the variables from `variables.tf`.

### `output.tf`

This file declares the `name` and `arn` of the table, which will be displayed after the infrastructure is successfully created.

## How to Use

1.  **Create the Files:** Save the code for `main.tf`, `variables.tf`, and `output.tf` into a new directory.
2.  **Initialize Terraform:** Open your terminal, navigate to the directory, and run:
    ```bash
    terraform init
    ```
    This command prepares the directory for Terraform commands.
3.  **Apply the Configuration:** Run the apply command to create the table.
    ```bash
    terraform apply
    ```
    Terraform will show you an execution plan. Type `yes` and press Enter to confirm.
4.  **Review the Output:** After the apply is complete, Terraform will display the name and ARN of the created DynamoDB table.
    ```
    # Example Output:
    # dynamodb_table_arn = "arn:aws:dynamodb:ap-south-1:123456789012:table/my-terraform-users-table"
    # dynamodb_table_name = "my-terraform-users-table"
    ```

## Cleaning Up

When you are finished with the table, you can destroy the resource to avoid any potential future costs.

Run the following command in the same directory:

```bash
terraform destroy
```

Type `yes` and press Enter to confirm the deletion of the table.
