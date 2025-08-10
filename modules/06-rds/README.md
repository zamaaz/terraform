# Terraform AWS RDS Instance

This Terraform project provisions a secure Amazon RDS database instance inside a given VPC. It is designed as an independent, reusable module that can be deployed into any existing network environment.

## Features & Resources Created

This configuration will create the following resources:

1.  **RDS DB Instance (`aws_db_instance`)**: The main database server, configured with an engine, instance size, and credentials.
2.  **DB Subnet Group (`aws_db_subnet_group`)**: Defines which subnets the RDS instance is allowed to operate in for high availability.
3.  **Security Group (`aws_security_group`)**: A dedicated firewall for the database, allowing connections on the appropriate database port (e.g., 3306 for MySQL) only from within the specified VPC.

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

1.  **An Existing VPC**: You must have a VPC with at least two subnets in different Availability Zones.
2.  **An EC2 Instance for Testing**: To connect to and test this private database, you need an EC2 instance running inside the same VPC. If you don't have one, you can deploy one using the `01-ec2-instance` module in this repository first.
3.  **Terraform and AWS CLI**: Configured and ready to use. You can use the `setup.sh` script from the `scripts/` directory for this.
4.  **Backend Infrastructure**: The resources from the `00-backend` project must be created first.

## State Management

This project is configured to use a remote backend in AWS S3 for state management and DynamoDB for state locking. Before running `terraform init`, ensure the `backend.tf` file is present and configured correctly.

## How to Use

1.  **Create `terraform.tfvars`**: Create the variables file as described above with your specific VPC and subnet information.
2.  **Initialize Terraform**: Open your terminal in this directory and run:
    ```bash
    terraform init
    ```
3.  **Apply the Configuration**:
    ```bash
    terraform apply
    ```
    Terraform will automatically use the values from `terraform.tfvars` and show you an execution plan. Type `yes` to confirm.
4.  **Review the Output**: After the apply is complete, Terraform will display the connection endpoint and other details for your new RDS instance.

## Testing the Connection

1.  SSH into your EC2 instance that is running in the same VPC.
2.  Install a database client (e.g., `sudo apt-get install mysql-client -y`).
3.  Use the `db_instance_endpoint` from the Terraform output to connect:
    ```bash
    mysql -h <your-db-endpoint> -P 3306 -u <your-username> -p
    ```
4.  Enter your password when prompted. A successful connection confirms your RDS instance is working correctly.

## Outputs

After a successful apply, the following outputs will be displayed:

- `db_instance_endpoint`: The connection string for your database.
- `db_instance_identifier`: The unique identifier of the instance.
- `db_instance_username`: The master username for the database.
- `db_instance_arn`: The Amazon Resource Name of the instance.
- `db_security_group_id`: The ID of the created security group.

## Cleaning Up

When you are finished with the instance, you can destroy the resource to avoid any potential future costs.

Run the following command in the same directory:

```bash
terraform destroy
```

Type `yes` and press Enter to confirm the deletion of the instance.
