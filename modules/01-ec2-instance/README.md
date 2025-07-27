# Terraform AWS EC2 Instance with SSH Access

This Terraform project provisions a simple Amazon EC2 instance on AWS using a modular file structure. It creates a new security group to allow SSH access and uses variables for easy configuration.

This setup is ideal for quickly launching a development or test server in a reusable and organized way.

## File Structure

Your project directory should look like this:

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

The configuration is split into three files for better organization.

### 1\. `variables.tf`

This file defines all the input variables for your infrastructure. You should review and change the default values here, especially the `key_name`.

- **`key_name`**: **(Required)** Change the default value `"secret"` to the exact name of your key pair in the AWS console.
- **`aws_region`**: The AWS region to deploy to.
- **`ec2_ami`**: The Amazon Machine Image ID to use. The default is for Ubuntu 22.04 in `ap-south-1`.
- **`instance_type`**: The size of the EC2 instance.

<!-- end list -->

```terraform
# variables.tf

variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "ap-south-1"
}

variable "ec2_ami" {
  description = "The AWS ami id"
  type        = string
  default     = "ami-0f5ee92e2d63afc18"
}

variable "instance_type" {
  description = "The EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key Pair"
  type        = string
  default     = "secret" # <-- CHANGE THIS
}
```

### 2\. `main.tf`

This is the core file that defines the resources to be created, including the EC2 instance and the security group. It uses the variables defined in `variables.tf`.

**Security Note:** The `aws_security_group` resource allows SSH traffic from anywhere (`0.0.0.0/0`). For enhanced security, it is recommended to restrict the `cidr_blocks` to your own IP address.

### 3\. `output.tf`

This file declares the values that will be displayed after your infrastructure is successfully created, such as the instance's public IP address.

---

## How to Use

1.  **Create the Files:** Save the provided code into the three files (`main.tf`, `variables.tf`, `output.tf`) in a new directory.

2.  **Initialize Terraform:** Open your terminal, navigate to the directory, and run:

    ```bash
    terraform init
    ```

    This command downloads the necessary AWS provider plugin.

3.  **Apply the Configuration:** Run the apply command to create the resources.

    ```bash
    terraform apply
    ```

    Terraform will show you a plan of the resources to be created. Type `yes` and press Enter to confirm.

4.  **Connect to the Instance:** After the apply is complete, Terraform will display the public IP of the instance.

    ```
    # Example Output:
    # instance_public_ip = "13.233.100.50"
    ```

    Use this IP address to connect via SSH. The default AMI is an Ubuntu image, so the username is `ubuntu`.

    Construct your SSH command like this:

    ```bash
    ssh -i /path/to/your/private-key.pem ubuntu@<INSTANCE_PUBLIC_IP>
    ```

    Replace `/path/to/your/private-key.pem` with the actual path to your private key file and `<INSTANCE_PUBLIC_IP>` with the IP from the Terraform output.

## Cleaning Up

When you are finished with the instance, you can destroy all the resources created by this configuration to avoid incurring further charges.

Run the following command:

```bash
terraform destroy
```

Type `yes` and press Enter to confirm the destruction of the resources.
