# Automated Infrastructure Testing

This directory contains automated tests for the Terraform modules in this repository. The purpose of these tests is to verify that the infrastructure deploys correctly and functions as expected, catching potential errors before they reach production.

The tests are written in the **Go** programming language using the **Terratest** framework.

## What is Terratest?

Terratest is an open-source Go library that provides tools for writing automated tests for your infrastructure code. A typical test will:

1.  **Deploy**: Run `terraform init` and `terraform apply` to create real infrastructure in an AWS account.
2.  **Verify**: Run a series of checks against the live resources. This can include checking Terraform outputs, making HTTP requests to public endpoints, or querying the AWS API.
3.  **Destroy**: Automatically run `terraform destroy` at the end of the test to clean up all resources, ensuring you don't leave anything running.

## Prerequisites

Before you can run these tests, you must have the following installed and configured on your local machine:

1.  **Go**: [Download and install the Go programming language](https://go.dev/dl/) (version 1.18 or newer).
2.  **Terraform**: The Terraform CLI must be installed and available in your system's PATH.
3.  **AWS Credentials**: Your AWS CLI must be configured with credentials that have permission to create and destroy the resources defined in the modules.

## How to Run the Tests

Follow these steps from within this `test` directory.

### 1\. First-Time Setup

You only need to do this once. This command will initialize the Go module and download the necessary testing libraries (Terratest, testify).

```
go mod init terratest
go mod tidy
```

### 2\. Run All Tests

To execute all test files (`*_test.go`) in this directory, run the following command.

**Warning**: This will create and destroy real, billable resources in your AWS account. The process can take a significant amount of time (20-30 minutes or more).

```
go test -v -timeout 30m
```

- `-v`: Enables verbose logging, so you can see the Terraform output in real-time.
- `-timeout 30m`: Sets a 30-minute timeout for the entire test suite. This is important as creating resources like VPCs and databases can be slow.

### 3\. Run a Specific Test

To run a single test (e.g., only the VPC test), you can use the `-run` flag with the name of the test function.

```
go test -v -timeout 30m -run TestVpc
```

## Test Files

- `vpc_test.go`: A simple test that deploys the VPC module and asserts that the `vpc_id` output is not empty.
- `ec2_test.go`: A more advanced test that deploys the EC2 module with a `user_data` script to run a web server, then makes an HTTP request to the instance's public IP to verify it returns "Hello, World\!".
