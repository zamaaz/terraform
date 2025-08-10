# Terraform AWS Auto Scaling Group

This Terraform project provisions a complete Auto Scaling Group (ASG) for EC2 instances. It uses a Launch Template to define the instance configuration and is designed to launch instances into private subnets, attaching them to an Application Load Balancer (ALB) for a secure, scalable, and highly available setup.

## Features & Resources Created

- **Launch Template (`aws_launch_template`)**: A blueprint for the EC2 instances, defining the AMI, instance type, key pair, security group, IAM role, and a startup script.
- **Auto Scaling Group (`aws_autoscaling_group`)**: The manager that maintains a desired number of instances, launching new ones in the specified private subnets and registering them with the ALB's target group.
- **Security Group (`aws_security_group`)**: A dedicated firewall for the instances, allowing SSH from the internet and HTTP traffic only from the ALB.

## Prerequisites

1.  **VPC with Private Subnets**: You must have a VPC with private subnets and a NAT Gateway for internet access. The `01-vpc` module creates this.
2.  **Application Load Balancer**: An ALB to distribute traffic. The `08-alb` module creates this.
3.  **IAM Role**: An IAM instance profile for the EC2 instances to assume. The `07-iam-role` module creates this.
4.  **Terraform and AWS CLI**: Configured and ready to use.
5.  **Backend Infrastructure**: The resources from the `00-backend` project must be created first.

## State Management

This project uses a remote backend in AWS S3. Ensure the `backend.tf` file is present and configured correctly before initializing.

## How to Use

1.  **Create `terraform.tfvars`**: This module connects many other modules. Create a `terraform.tfvars` file in this directory with the outputs from your other modules:

    ```hcl
    # terraform.tfvars
    key_name                 = "your-key-name"
    iam_instance_profile_arn = "arn:aws:iam::xxxxxxxxxxxx:instance-profile/your-profile"
    vpc_id                   = "vpc-xxxxxxxxxxxxxxxxx"
    subnet_ids               = ["subnet-xxxxxxxxxxxxxxxxx", "subnet-yyyyyyyyyyyyyyyyy"]
    target_group_arns        = ["arn:aws:elasticloadbalancing:region:xxxxxxxxxxxx:targetgroup/your-tg/xxxxxxxx"]
    alb_security_group_id    = "sg-xxxxxxxxxxxxxxxxx"
    ```

    **Note: Use Private Subnet IDs here**

2.  **Initialize Terraform**: `terraform init`
3.  **Apply the Configuration**: `terraform apply`

## How to Test

After a successful apply:

1.  Wait 3-5 minutes for the instances to launch and the startup script to run.
2.  In the AWS Console, go to `EC2 > Target Groups`. The instances in your target group should be marked as **"healthy"**.
3.  Paste the `lb_dns_name` (from the `08-alb` module's output) into your web browser. You should see the "Hello from..." page.

## Outputs

- `autoscaling_group_name`: The name of the Auto Scaling Group.
- `autoscaling_group_arn`: The ARN of the Auto Scaling Group.
- `launch_template_name`: The name of the Launch Template.

## Cleaning Up

When you are finished with the Auto Scaling Group, you can destroy all the resources created by this configuration to avoid incurring further charges.

Run the following command in the same directory:

```bash
terraform destroy
```

Type `yes` and press Enter to confirm the destruction of all the resources defined in the configuration.
