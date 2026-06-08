resource "aws_wafv2_web_acl" "security_group_waf" {
  name        = "prod-security-group-waf"
  description = "Regional WAF ACL for Security Group Account"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "ProdSecurityGroupWAF"
    sampled_requests_enabled   = true
  }

  tags = merge(
    local.common_tags,
    {
      Name    = "prod-security-group-waf"
      Purpose = "Security Group Account WAF Protection"
    }
  )
}