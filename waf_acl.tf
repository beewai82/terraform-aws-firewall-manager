resource "aws_wafv2_web_acl" "security_group_account_waf" {
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

  depends_on = [
    aws_wafv2_web_acl_rule.allow_trusted_ips,
    aws_wafv2_web_acl_rule.block_bad_ips,
    aws_wafv2_web_acl_rule.rate_limit,
    aws_wafv2_web_acl_rule.crs,
    aws_wafv2_web_acl_rule.known_bad_inputs,
    aws_wafv2_web_acl_rule.sqli,
    aws_wafv2_web_acl_rule.ip_reputation,
  ]
}