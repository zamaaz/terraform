# Terraform AWS Infrastructure

Welcome! This repository contains all the infrastructure-as-code for my projects, organized as a monorepo. It uses Terraform to provision and manage resources on AWS.

## Repository Structure

This repository is organized into several top-level directories:

-   `modules/`: Contains reusable, standalone Terraform modules that define a specific piece of infrastructure (e.g., a VPC, an EC2 instance). Each subdirectory is an independent Terraform project.
-   `scripts/`: Contains helper scripts for automating common tasks, such as local environment setup (`setup.sh`).
-   `environments/`: (Future) This directory will contain configurations that deploy the modules into specific environments like `staging` or `production`.

---

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

## Deploying a Module

To deploy any infrastructure module from the `modules/` directory (e.g., `01-vpc`):

1.  Navigate into the project directory (e.g., `cd modules/01-vpc`).
2.  Open the `backend.tf` file and ensure the `bucket` and `dynamodb_table` names match the resources you created in the `00-backend` step.
3.  Run `terraform init`. Terraform will connect to your remote backend.
4.  Run `terraform plan` to review the changes.
5.  Run `terraform apply` to deploy the resources.
