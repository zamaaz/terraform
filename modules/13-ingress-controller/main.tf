provider "aws" {
  region = var.aws_region
}

resource "aws_iam_policy" "lb_controller_policy" {
  name        = "${var.cluster_name}-lb-controller-policy"
  description = "AWS LBC policy (upstream)"
  policy      = file("${path.module}/lbc_iam_policy.json")
}

resource "aws_iam_role" "lb_controller_role" {
  name = "${var.cluster_name}-lb-controller-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")}"
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "${replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")}:aud" = "sts.amazonaws.com",
          "${replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
        }
      }
    }]
  })
}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_caller_identity" "current" {}

resource "aws_iam_role_policy_attachment" "lb_controller_policy" {
  role       = aws_iam_role.lb_controller_role.name
  policy_arn = aws_iam_policy.lb_controller_policy.arn
}
