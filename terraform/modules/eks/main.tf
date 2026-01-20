data "aws_caller_identity" "current" {}
module "eks" {
  source  = "registry.terraform.io/terraform-aws-modules/eks/aws"
  version = "20.37.1"

  cluster_name                    = var.name
  cluster_version                 = var.eks_version
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  # IPV6
  cluster_ip_family          = var.eks_ipv6_enabled ? "ipv6" : "ipv4"
  create_cni_ipv6_iam_policy = var.eks_ipv6_enabled

  cluster_enabled_log_types            = ["api", "audit", "authenticator", "controllerManager", "scheduler"]


  enable_irsa = true
  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy             = {}
    vpc-cni                = {
      before_compute = true
    }
  }

  create_iam_role      = true
  iam_role_arn         = "${var.name}-iamRoleName"
  iam_role_description = "${var.name}-iamRoleDescription"

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  create_cluster_security_group = false
  create_node_security_group    = false

eks_managed_node_groups = {
    example = {
      instance_types = ["t3.micro"]

      min_size     = 1
      max_size     = 1
      desired_size = 1
    }
  }

  authentication_mode = "API"

  access_entries = merge({
    gh_runner_user = {
      kubernetes_groups = []
      principal_arn     = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/github_workflow_role"
      username          = "gh-runner-user"

      policy_associations = {
        single = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }
  )
}