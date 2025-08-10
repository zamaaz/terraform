# Terraform AWS ECS Fargate Service

This Terraform project provisions a complete, containerized application on AWS using ECS (Elastic Container Service) with the Fargate launch type. It is designed as an independent module that launches a specified container image, places it behind an Application Load Balancer, and runs it securely in private subnets.

## Features & Resources Created

- **ECR Repository (`aws_ecr_repository`)**: A private Docker container registry to store your application's images.
- **ECS Cluster (`aws_ecs_cluster`)**: A logical grouping for your containerized services.
- **IAM Role & Policy**: A dedicated IAM role that grants the ECS tasks permission to pull images from ECR and write logs.
- **ECS Task Definition (`aws_ecs_task_definition`)**: A blueprint (or "recipe") for your container, defining the image, CPU/memory, and port mappings.
- **Security Group**: A dedicated firewall for the ECS tasks, allowing traffic only from the Application Load Balancer.
- **ECS Service (`aws_ecs_service`)**: The "manager" that runs and maintains a desired number of your tasks, automatically registering them with the ALB's target group.

## File Structure

```
.
├── main.tf
├── variables.tf
└── output.tf
```

## Prerequisites

1.  **VPC with Private Subnets**: You must have a VPC with private subnets and a NAT Gateway for internet access. The `01-vpc` module creates this.
2.  **Application Load Balancer**: An ALB configured with a target group that has a `target_type` of `ip`. The `08-alb` module creates this.
3.  **Terraform and AWS CLI**: Configured and ready to use.
4.  **Backend Infrastructure**: The resources from the `00-backend` project must be created first.

---

## State Management

This project uses a remote backend in AWS S3. Ensure the `backend.tf` file is present and configured correctly before initializing.

---

## How to Use

1.  **Create `terraform.tfvars`**: This module connects your network and load balancer. Create a `terraform.tfvars` file in this directory with the outputs from your other modules:

    ```hcl
    # terraform.tfvars
    vpc_id                 = "vpc-xxxxxxxxxxxxxxxxx"
    subnet_ids             = ["subnet-xxxxxxxxxxxxxxxxx", "subnet-yyyyyyyyyyyyyyyyy"]
    alb_target_group_arn   = "arn:aws:elasticloadbalancing:region:xxxxxxxxxxxx:targetgroup/your-tg/xxxxxxxx"
    alb_security_group_id  = "sg-xxxxxxxxxxxxxxxxx"
    ```

    **Note: Use Private Subnet IDs here**

2.  **Initialize Terraform**: `terraform init`
3.  **Apply the Configuration**: `terraform apply`

---

## How to Test

After a successful apply:

1.  **Wait 2-3 minutes** for the ECS service to pull the container image and start the tasks.
2.  In the AWS Console, go to `EC2 > Target Groups`. The IP addresses of your tasks should appear in the "Targets" tab and be marked as **"healthy"**.
3.  Paste the `lb_dns_name` (from the `08-alb` module's output) into your web browser. You should see the "Welcome to nginx\!" page.

## Outputs

- `ecr_repository_url`: The URL of the ECR repository where you can push your custom images.
- `ecs_cluster_name`: The name of the ECS cluster.
- `ecs_service_name`: The name of the ECS service.

## Cleaning Up

When you are finished with the ALB, you can destroy all the resources created by this configuration to avoid incurring further charges.

Run the following command in the same directory:

```bash
terraform destroy
```

Type `yes` and press Enter to confirm the destruction of all the resources defined in the configuration.
