resource "aws_wafv2_ip_set" "springeq_allowed_ips" {
  name               = "prod-security-group-springeq-allowed-ips"
  description        = "SpringEq approved IP addresses"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"

  addresses = [
    "166.151.187.252/32",
    "135.119.129.215/32",
    "35.170.207.125/32",
    "63.127.202.242/32",
    "69.135.98.14/32",
    "34.233.164.41/32",
    "44.198.70.108/32",
    "65.1.42.158/32",
    "98.101.45.174/32",
    "208.114.206.110/32",
    "136.41.192.89/32",
    "166.151.210.112/32",
    "4.242.232.121/32",
    "18.204.26.204/32",
    "4.242.232.147/32",
    "45.29.132.65/32",
    "172.167.4.198/32",
    "98.115.201.19/32",
    "50.174.147.178/32",
    "50.174.105.90/32",
    "45.27.148.113/32",
    "172.210.215.120/32",
    "4.247.134.55/32",
    "191.235.236.3/32",
    "68.110.168.179/32",
    "24.136.101.170/32",
    "104.209.188.60/32",
  ]

  tags = merge(
    local.common_tags,
    {
      Name    = "prod-security-group-springeq-allowed-ips"
      Purpose = "SpringEq approved IP addresses"
    }
  )
}

locals {
  common_tags = {
    Environment = "prod"
    Project     = "FirewallManager"
  }
}