# Terraform AWS Infrastructure Monorepo

Welcome\! This repository contains a complete, production-grade infrastructure-as-code setup for deploying a scalable, containerized web application on AWS. It is organized as a monorepo, cleanly separating application code from infrastructure modules, and includes a comprehensive CI/CD pipeline for automated deployments and a suite of automated infrastructure tests.

## Repository Structure

This repository is organized into several top-level directories:

  * `.github/workflows/`: Contains the main GitHub Actions workflow that automates the entire CI/CD process.
  * `app/`: Contains the source code for the Python Flask web application, including its `Dockerfile`.
  * `modules/`: Contains reusable, standalone Terraform modules that define specific pieces of infrastructure.
  * `scripts/`: Contains helper scripts for automating common tasks, such as local environment setup.
  * `test/`: Contains automated infrastructure tests written in Go using the Terratest framework.

-----

## The Workflow: From Code to Cloud

This repository is designed around a Git-driven workflow. There are two primary scenarios for the CI/CD pipeline:

### 1\. Application Change Workflow (CI)

This is triggered when you push a change to any file inside the `app/` directory.

1.  **Build & Push:** A GitHub Actions job automatically builds your Python app into a Docker container image.
2.  **Store in ECR:** The new image is pushed to your private Amazon ECR repository with a unique tag (the Git commit SHA).
3.  **Deploy to ECS:** The workflow then triggers the Terraform `plan` and `apply` jobs for the ECS module, passing in the new container image URL. ECS performs a rolling update, replacing the old containers with the new ones with zero downtime.

### 2\. Infrastructure Change Workflow (CD)

This is triggered when you push a change to any file inside a `modules/` subdirectory.

1.  **Detect Change:** The GitHub Actions workflow intelligently detects which module's folder you changed.
2.  **Plan:** It runs `terraform plan` only for the specific module that was modified.
3.  **Manual Approval:** For any change to the `main` branch, the workflow will pause and wait for a manual approval in the GitHub "Environments" tab before applying.
4.  **Apply:** Once approved, it runs `terraform apply` to deploy the infrastructure change.

-----

## Getting Started: First-Time Setup

The infrastructure modules use a remote S3 backend for Terraform state management. To set up your environment for the first time, you **must** create the backend resources before deploying any other module.

1.  **Set up your local environment**: If you haven't already, run the `setup.sh` script to install Terraform and the AWS CLI.
    ```bash
    cd scripts
    ./setup.sh
    ```
2.  **Create the backend infrastructure**:
    -   Navigate to the `modules/00-backend` directory.
    -   Open `variables.tf` and change `s3_bucket_name` to a globally unique name.
    -   Run `terraform init`.
    -   Run `terraform apply`.

Once this is complete, the S3 bucket and DynamoDB table are ready. You can now proceed to deploy any of the other modules.

-----

## CICD: Initial Manual Setup

The CI/CD pipeline is designed to manage *changes* to an existing environment. Therefore, you must perform a one-time manual setup to create the initial infrastructure.

**Deploy the modules in this exact order:**

1.  **`00-backend`**: Creates the S3 bucket and DynamoDB table for Terraform's remote state.
2.  **`01-vpc`**: Creates the network foundation with public and private subnets.
3.  **`07-iam-role`**: Creates the IAM role for the EC2 instances.
4.  **`08-alb`**: Creates the Application Load Balancer in the public subnets.
5.  **`11-ecs`**: Deploys the ECS service into the private subnets. For the initial deployment, it will use the default public Nginx image.

After this initial setup, you should never need to run `terraform apply` from your local machine again. All subsequent changes will be handled by the CI/CD pipeline.

-----

## Automated Infrastructure Testing

The `test/` directory contains automated tests written in Go using Terratest. These tests deploy real infrastructure, verify its functionality, and automatically destroy it.

### How to Run the Tests

1.  **Navigate to the `test` directory**: `cd test`
2.  **First-Time Setup**: Run `go mod init terratest && go mod tidy` to download dependencies.
3.  **Run All Tests**:
    ```bash
    go test -v -timeout 30m
    ```

See the `test/README.md` for more details on running specific tests.

-----

## Adding a New Module

To add a new infrastructure module (e.g., `12-new-service`):

1.  Create the new directory inside `modules/`.
2.  Add your `.tf` files and a `backend.tf` file.
3.  Open the main `.github/workflows/terraform-ci.yml` file.
4.  Add a new entry for your module to the `matrix` in both the `plan-module` and `apply-module` jobs. The workflow will automatically handle the rest.

-----

## Manually deploying a Module

To manually deploy any infrastructure module from the `modules/` directory (e.g., `02-vpc`):

1.  Navigate into the project directory (e.g., `cd modules/02-vpc`).
2.  Open the `backend.tf` file and ensure the `bucket` and `dynamodb_table` names match the resources you created in the `00-backend` step.
3.  Run `terraform init`. Terraform will connect to your remote backend.
4.  Run `terraform plan` to review the changes.
5.  Run `terraform apply` to deploy the resources.