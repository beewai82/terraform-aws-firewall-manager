locals {
  # Core deployment context - defaults only
  region       = "us-east-1"
  account_id   = data.aws_caller_identity.current.account_id
  environment  = "prod"

  # WAF configuration defaults
  enable_cloudwatch_metrics = true
  enable_sampled_requests   = true

  # IP lists - defaults
  trusted_ip_list = ["10.0.0.0/8"]
  blocked_ip_list = []
  rate_limit      = 2000

  # Naming conventions
  name_prefix = "${local.environment}-security-group"

  # Common tags aligned with parent organization standards
  common_tags = {
    "springeq:business-unit"         = "security"
    "springeq:business-owner"        = "technology"
    "springeq:application"           = "waf-security-tools"
    "springeq:environment"           = local.environment
    "springeq:shared-services:owner" = "security"
    "springeq:deployment-method"     = "terraform"
    "springeq:repo-source"           = "https://github.com/beewai82/terraform-aws-firewall-manager"
    "ManagedBy"                      = "Terraform"
    "Account"                        = local.account_id
    "Region"                         = local.region
  }

  # WAF rule priorities
  rule_priorities = {
    allow_trusted_ips  = 0
    block_bad_ips      = 1
    rate_limit         = 10
    crs                = 20
    known_bad_inputs   = 21
    sqli               = 22
    ip_reputation      = 23
  }
}
