Of course. Here is the content of the README file in Markdown format:

# Terraform AWS DocumentDB Cluster

This Terraform project provisions a secure Amazon DocumentDB cluster inside a given VPC. It is designed as an independent, reusable module that can be deployed into any existing network environment.

## Features & Resources Created

This configuration will create the **following** resources:

1.  **DocumentDB Cluster (`aws_docdb_cluster`)**: The main cluster resource, configured with a master username and password.
2.  **DocumentDB Instance(s) (`aws_docdb_cluster_instance`)**: The database server instances within the cluster. The number of instances is configurable.
3.  **DB Subnet Group (`aws_docdb_subnet_group`)**: Defines which subnets the cluster is allowed to operate in.
4.  **Security Group (`aws_security_group`)**: A dedicated firewall for the database, allowing connections on port `27017` only from within the specified VPC.

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

1.  **An Existing VPC**: You must have a VPC with at least two subnets in different Availability Zones.
2.  **Terraform**: [Download](https://learn.hashicorp.com/tutorials/terraform/install-cli) and install[ Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli).
3.  **AWS CLI**: [Install](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) and configure[ the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) with your credentials.
4.  **AWS Account**: An active AWS account.

## State Management

This project is configured to use a remote backend in AWS S3 for state management and DynamoDB for state locking. This ensures that the state is stored securely and prevents conflicts during team collaboration.

Before running `terraform init` for this project, you must ensure that the backend infrastructure from the `00-backend` project has been created.

## Configuration

### `variables.tf`

In this file, I have defined all the inputs you can use to customize the DocumentDB cluster. Some key variables are:

- **`vpc_id`**: (Required) The ID of the VPC to deploy the cluster into.
- **`subnet_ids`**: (Required) A list of at least two subnet IDs for the cluster.
- **`vpc_cidr_block`**: (Required) The CIDR block of the VPC for the security group rule.
- **`cluster_identifier`**: The name of the DocumentDB cluster.
- **`instance_class`**: The size of the database instances (defaults to `db.t3.medium` for Free Tier).
- **`instance_count`**: The number of database instances (defaults to `1` for Free Tier).
- **`master_username`** and **`master_password`**: Credentials for the database administrator.

### `main.tf`

This file contains the main logic that defines the `aws_docdb_cluster`, `aws_docdb_cluster_instance`, `aws_docdb_subnet_group`, and `aws_security_group` resources.

### `output.tf`

This file declares the important attributes of the cluster that will be displayed after creation, such as the connection endpoint and cluster ID.

## How to Use

1.  **Create `terraform.tfvars`**: This module requires you to provide network information. Create a file named `terraform.tfvars` in this directory with the following content, using your specific values:
    ```hcl
    # terraform.tfvars
    vpc_id         = "vpc-xxxxxxxxxxxxxxxxx"
    subnet_ids     = ["subnet-xxxxxxxxxxxxxxxxx", "subnet-yyyyyyyyyyyyyyyyy"]
    vpc_cidr_block = "10.0.0.0/16"
    ```
2.  **Initialize Terraform**: Open your terminal, navigate to the directory, and run:
    ```bash
    terraform init
    ```
    If you have a pre-existing local state file, Terraform will ask to migrate it to the remote backend. Type `yes`.
3.  **Apply the Configuration**: Run the apply command to create the cluster.
    ```bash
    terraform apply
    ```
    Terraform will automatically use the values from `terraform.tfvars` and show you an execution plan. Type `yes` to confirm.
4.  **Review** the **Output**: After the apply is complete, Terraform will display the connection endpoint and other details for your new cluster.

## Cleaning Up

When you are finished with the cluster, you can destroy the resource to avoid any potential future costs.

Run the following command in the same directory:

```bash
terraform destroy
```

Type `yes` and press Enter to confirm the deletion of the cluster.
