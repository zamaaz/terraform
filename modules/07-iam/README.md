# Terraform AWS IAM Role for EC2

This Terraform project provisions an IAM Role that can be assumed by an EC2 instance. It includes a policy that grants read-only access to a specific S3 bucket and an instance profile to make the role available to EC2.

This is a foundational module for building secure applications where EC2 instances need to interact with other AWS services.

## Features & Resources Created

- **IAM Role (`aws_iam_role`)**: An IAM role with a trust policy that allows the EC2 service to assume it.
- **IAM Policy (`aws_iam_policy`)**: A policy granting `s3:ListBucket` and `s3:GetObject` permissions for a specific S3 bucket.
- **Policy Attachment (`aws_iam_role_policy_attachment`)**: Attaches the S3 read policy to the IAM role.
- **Instance Profile (`aws_iam_instance_profile`)**: A container for the IAM role that can be attached to an EC2 instance.

## Prerequisites

1.  **An Existing S3 Bucket**: You must have an S3 bucket for the IAM policy to grant permissions to. You can create one with the `03-s3-bucket` module.
2.  **Terraform and AWS CLI**: Configured and ready to use.
3.  **Backend Infrastructure**: The resources from the `00-backend` project must be created first.

---

## State Management

This project is configured to use a remote backend in AWS S3. Ensure the `backend.tf` file is present and configured correctly before initializing.

## How to Use

1.  **Update `variables.tf`**: Open the `variables.tf` file and change the default `s3_bucket_name` to the name of the bucket you want to grant access to.
2.  **Initialize Terraform**: `terraform init`
3.  **Apply the Configuration**: `terraform apply`

## How to Test This Module

To verify that the role is working correctly, you need to attach it to an EC2 instance and then try to access the S3 bucket from that instance.

1.  **Deploy Prerequisites**: Ensure you have successfully run `terraform apply` for both the `03-s3-bucket` module and this IAM module.
2.  **Get the Profile Name**: In this IAM module directory, run `terraform output` and copy the value of `iam_instance_profile_name`.
3.  **Configure the EC2 Module**:
    - Navigate to your `01-ec2-instance` module directory.
    - Create a `terraform.tfvars` file.
    - Add the following content, pasting the profile name you copied:
      ```hcl
      # terraform.tfvars for EC2 module
      iam_instance_profile_name = "access_role" // <-- Use your actual profile name here
      ```
4.  **Apply the EC2 Module**: Run `terraform apply` in the EC2 module directory. This will either create a new instance with the role attached or update your existing instance.
5.  **Verify from EC2**:
    - SSH into your EC2 instance.
    - Run the AWS CLI command to list the contents of your bucket:
      ```bash
      aws s3 ls s3://<your-bucket-name>
      ```
    - If the command succeeds, the IAM role is working perfectly!

## Outputs

- `iam_instance_profile_name`: The name of the instance profile, which you can use to attach this role to an EC2 instance.

## Cleaning Up

When you are finished with the instance, you can destroy all the resources created by this configuration to avoid incurring further charges.

Run the following command:

```bash
terraform destroy
```

Type `yes` and press Enter to confirm the destruction of the resources.
