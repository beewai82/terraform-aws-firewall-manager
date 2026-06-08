resource "aws_wafv2_web_acl" "security_group_account_waf" {
  name        = "${local.name_prefix}-waf"
  description = "Regional WAF ACL for Security Group Account"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = local.enable_cloudwatch_metrics
    metric_name                = "${replace(local.environment, "-", "")}SecurityGroupWAF"
    sampled_requests_enabled   = local.enable_sampled_requests
  }

  tags = merge(
    local.common_tags,
    {
      Name    = "${local.name_prefix}-waf"
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