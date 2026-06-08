resource "aws_wafv2_ip_set" "trusted_ips" {
  name               = "${var.environment_name}-security-group-trusted-ips"
  description        = "Security Group Account: Trusted IPs — bypass WAF inspection"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"

  addresses = var.trusted_ip_list

  tags = merge(
    var.tags,
    {
      Name        = "${var.environment_name}-security-group-trusted-ips"
      Environment = var.environment_name
      Account     = local.account_id
      Region      = local.region
      ManagedBy   = "Terraform"
    }
  )
}

resource "aws_wafv2_ip_set" "blocked_ips" {
  name               = "${var.environment_name}-security-group-blocked-ips"
  description        = "Security Group Account: Known bad IPs — always denied"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"

  addresses = var.blocked_ip_list

  tags = merge(
    var.tags,
    {
      Name        = "${var.environment_name}-security-group-blocked-ips"
      Environment = var.environment_name
      Account     = local.account_id
      Region      = local.region
      ManagedBy   = "Terraform"
    }
  )
}