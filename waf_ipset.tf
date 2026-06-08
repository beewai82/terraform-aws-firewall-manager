resource "aws_wafv2_ip_set" "trusted_ips" {
  name               = "prod-security-group-trusted-ips"
  description        = "Security Group Account: Trusted IPs — bypass WAF inspection"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"

  addresses = ["10.0.0.0/8"]

  tags = merge(
    local.common_tags,
    {
      Name    = "prod-security-group-trusted-ips"
      Purpose = "Trusted IP allowlist"
    }
  )
}

resource "aws_wafv2_ip_set" "blocked_ips" {
  name               = "prod-security-group-blocked-ips"
  description        = "Security Group Account: Known bad IPs — always denied"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"

  addresses = []

  tags = merge(
    local.common_tags,
    {
      Name    = "prod-security-group-blocked-ips"
      Purpose = "Blocked IP blocklist"
    }
  )
}