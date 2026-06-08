resource "aws_wafv2_ip_set" "allowlist" {
  name               = "org-allowlist"
  description        = "Trusted IPs — bypass WAF inspection"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"

  addresses = [
    "10.0.0.0/8",    # Replace with your trusted CIDRs
  ]

  tags = { ManagedBy = "Terraform" }
}

resource "aws_wafv2_ip_set" "blocklist" {
  name               = "org-blocklist"
  description        = "Known bad IPs — always denied"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"

  addresses = []   # Replace with your bad IPs/CIDRs

  tags = { ManagedBy = "Terraform" }
}