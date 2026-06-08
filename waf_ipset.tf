resource "aws_wafv2_ip_set" "allowlist" {
  name               = "${var.environment}-security-group-allowlist"
  description        = "Security Group Account: Trusted IPs — bypass WAF inspection"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"

  addresses = var.allowlist_ips

  tags = {
    Name        = "${var.environment}-security-group-allowlist"
    Environment = var.environment
    Account     = local.account_id
    Region      = local.deployment_region
    ManagedBy   = "Terraform"
  }
}

resource "aws_wafv2_ip_set" "blocklist" {
  name               = "${var.environment}-security-group-blocklist"
  description        = "Security Group Account: Known bad IPs — always denied"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"

  addresses = var.blocklist_ips

  tags = {
    Name        = "${var.environment}-security-group-blocklist"
    Environment = var.environment
    Account     = local.account_id
    Region      = local.deployment_region
    ManagedBy   = "Terraform"
  }
}