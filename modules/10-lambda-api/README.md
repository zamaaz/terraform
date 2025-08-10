# Terraform AWS Lambda and API Gateway

This Terraform project provisions a complete, serverless "Hello World" API. It creates an AWS Lambda function with a simple Python script and exposes it to the public internet via an Amazon API Gateway HTTP API.

## Features & Resources Created

- **IAM Role & Policy**: A dedicated IAM role that allows the Lambda function to execute and write logs to Amazon CloudWatch.
- **Lambda Function (`aws_lambda_function`)**: Deploys a simple Python function packaged as a `.zip` file.
- **API Gateway (`aws_apigatewayv2_api`)**: A high-performance HTTP API that acts as the public front door for the function.
- **API Integration, Route, and Stage**: All the necessary components to connect the API to the Lambda function and make it publicly accessible.
- **Lambda Permission**: A resource-based policy that explicitly grants the API Gateway permission to invoke the Lambda function.

## File Structure

```
.
├── main.tf
├── variables.tf
├── output.tf
└── hello.py       # The Python source code for the function
```

## Prerequisites

> **Tip for Easier Setup:**
> To automate the installation and configuration of Terraform and the AWS CLI, you can use the `setup.sh` script from the `scripts/` directory.

1.  **Terraform and AWS CLI**: Configured and ready to use.
2.  **AWS Account**: An active AWS account.
3.  **Backend Infrastructure**: The resources from the `00-backend` project must be created first.

---

## State Management

This project is configured to use a remote backend in AWS S3. Ensure the `backend.tf` file is present and configured correctly before initializing.

---

## How to Use

1.  **Initialize Terraform**: Open your terminal in this directory and run:
    ```bash
    terraform init
    ```
2.  **Apply the Configuration**: Run the apply command to create the resources.
    ```bash
    terraform apply
    ```
    Terraform will show you a plan. Type `yes` and press Enter to confirm.

---

## How to Test

After the apply is complete, you can test your new API endpoint.

1.  **Get the URL**: Run the output command to get the public URL of your API.
    ```bash
    terraform output api_endpoint_url
    ```
2.  **Construct the Full Path**: Combine the output URL with the `api_path` variable (default is "hello"). The final URL will look something like this:
    `https://abcdef123.execute-api.ap-south-1.amazonaws.com/hello`
3.  **Test in Browser or with cURL**: Paste the full URL into your web browser or use a command-line tool like `curl`:
    ```bash
    curl https://abcdef123.execute-api.ap-south-1.amazonaws.com/hello
    ```
    The expected response is: `Hello from Lambda!`

## Outputs

- `api_endpoint_url`: The base URL for your new serverless API.

## Cleaning Up

When you are finished, you can destroy all the resources created by this module.

Run the following command in the same directory:

```bash
terraform destroy
```

Type `yes` and press Enter to confirm the deletion.
