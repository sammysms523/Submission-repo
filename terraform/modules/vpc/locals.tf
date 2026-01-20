locals {
  default_inbound_acl_rules = [
    {
      rule_number = 101
      rule_action = "allow"
      from_port   = 0
      to_port     = 65534
      protocol    = "udp"
      cidr_block  = "0.0.0.0/0"
    },
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 65534
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
    },
    {
      rule_number = 99
      rule_action = "deny"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
    }

  ]

  public_inbound_acl_rules   = []
  private_inbound_acl_rules  = []
}