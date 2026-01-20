# creating iam role for github_workflow_role
data "aws_iam_policy_document" "assume_pipeline_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github_actions.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:sammysms523/Submission-repo:*"]
    }
  }
}

data "aws_iam_policy_document" "gh_workflow_policy_document" {

  statement {
    sid     = "EKS"
    effect  = "Allow"
    actions = ["eks:*"]
    resources = ["*"]
  }

  statement {
    sid    = "EC2Networking"
    effect = "Allow"

    actions = [
      "ec2:CreateVpc",
      "ec2:DeleteVpc",
      "ec2:DescribeVpcs",
      "ec2:ModifyVpcAttribute",

      "ec2:CreateSubnet",
      "ec2:DeleteSubnet",
      "ec2:DescribeSubnets",

      "ec2:CreateInternetGateway",
      "ec2:AttachInternetGateway",
      "ec2:DetachInternetGateway",
      "ec2:DeleteInternetGateway",

      "ec2:CreateRouteTable",
      "ec2:DeleteRouteTable",
      "ec2:AssociateRouteTable",
      "ec2:DisassociateRouteTable",
      "ec2:CreateRoute",

      "ec2:CreateNatGateway",
      "ec2:DeleteNatGateway",

      "ec2:AllocateAddress",
      "ec2:ReleaseAddress",

      "ec2:CreateSecurityGroup",
      "ec2:DeleteSecurityGroup",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:AuthorizeSecurityGroupEgress",

      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeRouteTables",
      "ec2:DescribeInternetGateways",
      "ec2:DescribeNatGateways"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "IAMForEKS"
    effect = "Allow"

    actions = [
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:GetRole",
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",
      "iam:PassRole"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "ELBAndASG"
    effect = "Allow"

    actions = [
      "elasticloadbalancing:*",
      "autoscaling:*"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role" "this" {
  name               = "github_workflow_role"
  assume_role_policy = data.aws_iam_policy_document.assume_pipeline_role.json
}

resource "aws_iam_policy" "gh_iam_policy" {
  name        = "gh-workflow-policy"
  description = "Github workflow policy"
  policy      = data.aws_iam_policy_document.gh_workflow_policy_document.json
}

resource "aws_iam_role_policy_attachment" "attach_gh_iam_policy" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.gh_iam_policy.arn
}