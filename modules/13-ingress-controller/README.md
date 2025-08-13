# Terraform AWS Load Balancer Controller for EKS

This Terraform project provisions the necessary IAM permissions required to run the AWS Load Balancer Controller on an EKS cluster. The controller itself is then installed using its official Helm chart.

This module is an essential add-on for any EKS cluster, as it enables you to manage Application Load Balancers (ALBs) declaratively using Kubernetes `Ingress` objects.

## Features & Resources Created

- **IAM Policy (`aws_iam_policy`)**: A comprehensive policy containing all the permissions the controller needs to manage ALBs, Target Groups, and related networking resources.
- **IAM Role (`aws_iam_role`)**: A dedicated IAM role that the controller's Kubernetes Service Account can assume. It uses the EKS OIDC provider for secure, keyless authentication.

## Prerequisites

1.  **An Existing EKS Cluster**: You must have a functional EKS cluster with an OIDC provider enabled. The `12-eks` module creates this.
2.  **Terraform and AWS CLI**: Configured and ready to use.
3.  **kubectl**: The Kubernetes command-line tool must be installed and configured to connect to your cluster.
4.  **Helm**: The Helm package manager for Kubernetes must be installed.
5.  **Backend Infrastructure**: The resources from the `00-backend` project must be created first.

---

## State Management

This project uses a remote backend in AWS S3. Ensure the `backend.tf` file is present and configured correctly before initializing.

---

## How to Use: A Two-Phase Process

Installing the controller is a two-phase process: first, you create the permissions with Terraform, then you install the application with Helm.

### Phase 1: Provision IAM Resources with Terraform

1.  **Create `terraform.tfvars`**: In this module's directory, create a `terraform.tfvars` file and provide the name of your EKS cluster:
    ```hcl
    # terraform.tfvars
    cluster_name = "my-eks-cluster"
    ```
2.  **Initialize and Apply**:
    ```bash
    terraform init
    terraform apply
    ```
3.  **Get the Role ARN**: After the apply is complete, get the ARN of the IAM role you just created. You will need this for the next phase.
    ```bash
    terraform output lb_controller_role_arn
    ```

### Phase 2: Install the Controller with Helm

Now, install the controller application into your cluster, telling it to use the IAM role you just created.

1.  **Add the Helm Repo**:
    ```bash
    helm repo add eks https://aws.github.io/eks-charts
    ```
2.  **Install the Chart**: Run the following command, pasting the IAM role ARN you copied.
    ```bash
    helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
      -n kube-system \
      --set clusterName=<your-cluster-name> \
      --set serviceAccount.create=true \
      --set serviceAccount.name=aws-load-balancer-controller \
      --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"="<PASTE_THE_IAM_ROLE_ARN_HERE>"
    ```

---

## How to Test

To verify the controller is working, you can deploy a sample application and expose it with an `Ingress` object.

1.  **Deploy a Sample App**: Apply a simple web server deployment and service to your cluster.
    ```bash
    kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/examples/2048/2048_full.yaml
    ```
2.  **Deploy an Ingress**: Apply an `Ingress` manifest that tells the controller to create an ALB for your sample app.
    ```bash
    kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/examples/2048/2048_ingress.yaml
    ```
3.  **Get the URL**: After 3-5 minutes, get the public DNS name of the new ALB by running:
    ```bash
    kubectl get ingress/2048-ingress
    ```
    Paste the address into your browser to see the "2048" game.

## Outputs

- `lb_controller_role_arn`: The ARN of the IAM role created for the controller.

## Cleaning Up

1.  **Delete Kubernetes Resources**: `kubectl delete -f <your-ingress-and-app-files>`
2.  **Uninstall Helm Chart**: `helm uninstall aws-load-balancer-controller -n kube-system`
3.  **Destroy IAM Resources**: Run `terraform destroy` in this module's directory.
