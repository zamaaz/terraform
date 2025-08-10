# Terraform AWS Application Load Balancer (ALB)

This Terraform project provisions a public, internet-facing Application Load Balancer. It is designed as an independent module to distribute incoming web traffic across multiple EC2 instances, increasing the availability and scalability of your application.

## Features & Resources Created

- **Application Load Balancer (`aws_lb`)**: The core load balancer that receives traffic and has a public DNS name.
- **Target Group (`aws_lb_target_group`)**: A group to hold your EC2 instances. The ALB forwards traffic to the healthy instances in this group.
- **Listener (`aws_lb_listener`)**: A rule that listens for traffic on port 80 (HTTP) and forwards it to the target group.
- **Security Group (`aws_security_group`)**: A dedicated firewall for the ALB that allows inbound HTTP traffic from the internet.

## File Structure

The project is organized into three separate files for clarity:

.
├── main.tf
├── variables.tf
└── output.tf

## Prerequisites

1.  **An Existing VPC**: You must have a VPC with at least two public subnets in different Availability Zones.
2.  **EC2 Instances**: You need one or more EC2 instances running a web server (e.g., Apache, Nginx) to serve as targets for the ALB.
3.  **Terraform and AWS CLI**: Configured and ready to use.
4.  **Backend Infrastructure**: The resources from the `00-backend` project must be created first.

---

## State Management

This project uses a remote backend in AWS S3. Ensure the `backend.tf` file is present and configured correctly before initializing.

---

## How to Use

1.  **Create `terraform.tfvars`**: This module requires network and target information. Create a file named `terraform.tfvars` in this directory with the following content, using your specific values:

    ```hcl
    # terraform.tfvars
    vpc_id                  = "vpc-0756c840ac83eb6ae"
    subnet_ids              = ["subnet-xxxxxxxxxxxxxxxxx", "subnet-yyyyyyyyyyyyyyyy"]
    target_ec2_instance_ids = ["i-xxxxxxxxxxxxxxxxx"]
    ```

    You can get these values from the outputs of your VPC and EC2 modules.

    **Note: Use Public Subnet IDs here**

2.  **Initialize Terraform**: `terraform init`
3.  **Apply the Configuration**: `terraform apply`

## How to Test

A `504` or `502` error after deployment usually indicates a problem with the connection between the ALB and your EC2 instances.

1.  **Install a Web Server**: SSH into your EC2 instance(s) and ensure a web server is running on the port specified in `target_group_port` (default is 80). For Ubuntu, you can run `sudo apt-get update && sudo apt-get install apache2 -y`.
2.  **Configure EC2 Security Group**: The security group for your EC2 instances **must** allow inbound traffic from the ALB's security group. You will need to add a new `ingress` rule to your EC2 module's security group. See the updated EC2 `README.md` for an example.
3.  **Check Target Health**: In the AWS Console, go to `EC2 > Target Groups`. Select your target group and check the "Targets" tab to ensure your instances are marked as "healthy".
4.  **Access the ALB**: Paste the `lb_dns_name` from the Terraform output into your web browser. You should see your application's default page.

## Outputs

- `lb_dns_name`: The public DNS name of the Application Load Balancer.
- `lb_arn`: The ARN of the Application Load Balancer.
- `target_group_arn`: The ARN of the main target group.
- `lb_security_group_id`: The ID of the security group associated with the Load Balancer.

## Cleaning Up

When you are finished with the ALB, you can destroy all the resources created by this configuration to avoid incurring further charges.

Run the following command in the same directory:

```bash
terraform destroy
```

Type `yes` and press Enter to confirm the destruction of all the resources defined in the configuration.
