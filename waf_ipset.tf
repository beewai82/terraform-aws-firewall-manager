resource "aws_wafv2_ip_set" "trusted_ips" {
  name               = "${local.name_prefix}-trusted-ips"
  description        = "Security Group Account: Trusted IPs — bypass WAF inspection"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"

  addresses = local.trusted_ip_list

  tags = merge(
    local.common_tags,
    {
      Name    = "${local.name_prefix}-trusted-ips"
      Purpose = "Trusted IP allowlist"
    }
  )
}

resource "aws_wafv2_ip_set" "blocked_ips" {
  name               = "${local.name_prefix}-blocked-ips"
  description        = "Security Group Account: Known bad IPs — always denied"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"

  addresses = local.blocked_ip_list

  tags = merge(
    local.common_tags,
    {
      Name    = "${local.name_prefix}-blocked-ips"
      Purpose = "Blocked IP blocklist"
    }
  )
}