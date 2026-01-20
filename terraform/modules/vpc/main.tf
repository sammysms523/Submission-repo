resource "aws_eip" "nat" {
  count = 2
}

module "vpc" {
  source  = "registry.terraform.io/terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs              = var.availability_zones
  private_subnets  = var.private_subnets
  public_subnets   = var.public_subnets

  map_public_ip_on_launch = false

  enable_nat_gateway   = true
  single_nat_gateway   = false
  enable_dns_hostnames = true

  manage_default_network_acl    = true
  manage_default_route_table    = false
  manage_default_security_group = false

  reuse_nat_ips       = true
  external_nat_ip_ids = aws_eip.nat.*.id


  enable_flow_log                          = false

  public_dedicated_network_acl   = true
  private_dedicated_network_acl  = true

  default_network_acl_ingress = [] # Prevent creation of default Ingress ACL rules
  public_inbound_acl_rules    = concat(local.default_inbound_acl_rules, local.public_inbound_acl_rules)
  private_inbound_acl_rules   = concat(local.default_inbound_acl_rules, local.private_inbound_acl_rules)

  public_subnet_tags = {
    Tier                                                   = "public"
    SubnetType                                             = "Public"
    "kubernetes.io/cluster/${var.kubernetes_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                               = 1
  }

  private_subnet_tags = {
    Tier                                                   = "private"
    SubnetType                                             = "Private"
    "kubernetes.io/cluster/${var.kubernetes_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"                      = 1
  }

  public_route_table_tags = {
    Tier = "public"
  }
}