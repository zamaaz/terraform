# Terraform AWS VPC and Public Subnet

This Terraform project creates a foundational network infrastructure in AWS. It provisions a new Virtual Private Cloud (VPC) along with all the necessary components to support a public-facing subnet.

This setup is the first step for building isolated and secure cloud environments.

## Resources Created

This configuration will create the following resources:

1.  **VPC (`aws_vpc`)**: A logically isolated virtual network in the AWS cloud.
2.  **Public Subnet (`aws_subnet`)**: A subnet within the VPC where resources like EC2 instances can be launched with direct access to the internet.
3.  **Internet Gateway (`aws_internet_gateway`)**: Allows communication between the VPC and the internet.
4.  **Route Table (`aws_route_table`)**: Defines rules to direct network traffic. A route is created to send all outbound traffic (`0.0.0.0/0`) to the Internet Gateway.
5.  **Route Table Association**: Links the public subnet to the route table, enabling the routing rules for any resources within that subnet.

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

This file allows you to customize the deployment without changing the main resource code. You can change the default values here or provide your own when running Terraform.

- **`aws_region`**: The AWS region where your VPC will be created.
- **`vpc_cidr_block`**: The overall IP address range for the VPC.
- **`public_subnet_cidr_block`**: The IP address range for the public subnet. This must be a sub-range of the VPC's CIDR block.

<!-- end list -->

```terraform
# variables.tf

variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_block" {
  description = "The CIDR block for the public subnet."
  type        = string
  default     = "10.0.1.0/24"
}
```

### `main.tf`

This file contains the main logic that defines all the AWS resources listed above. It uses the variables from `variables.tf` to configure the resources.

### `output.tf`

This file declares the important IDs that will be displayed after your infrastructure is successfully created. This is useful for referencing these resources in other Terraform projects or for manual verification.

---

## How to Use

1.  **Create the Files:** Save the provided code into the three files (`main.tf`, `variables.tf`, `output.tf`) in a new directory.
2.  **Initialize Terraform:** Open your terminal, navigate to the directory where you saved the files, and run:
    ```bash
    terraform init
    ```
    This command initializes the working directory and downloads the necessary AWS provider plugin.
3.  **Apply the Configuration:** Run the apply command to create the resources.
    ```bash
    terraform apply
    ```
    Terraform will show you an execution plan of the resources to be created. Type `yes` and press Enter to confirm.
4.  **Review the Output:** After the apply is complete, Terraform will display the IDs of the created resources as defined in `output.tf`.
    ```
    # Example Output:
    # internet_gateway_id = "igw-0123456789abcdef0"
    # public_subnet_id = "subnet-0123456789abcdef0"
    # vpc_id = "vpc-0123456789abcdef0"
    ```

## Cleaning Up

When you are finished with the VPC, you can destroy all the resources created by this configuration to avoid incurring further charges.

Run the following command in the same directory:

```bash
terraform destroy
```

Type `yes` and press Enter to confirm the destruction of all the resources defined in the configuration.
