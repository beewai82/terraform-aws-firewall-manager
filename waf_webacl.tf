resource "aws_wafv2_web_acl" "security_group_waf" {
  name        = "${var.environment_name}-security-group-waf"
  description = "Regional WAF ACL for Security Group Account"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  # Required block even when rules are external — sets ACL-level metrics
  visibility_config {
    cloudwatch_metrics_enabled = var.enable_cloudwatch_metrics
    metric_name                = "${replace(var.environment_name, "-", "")}SecurityGroupWAF"
    sampled_requests_enabled   = var.enable_sampled_requests
  }

  tags = merge(
    var.tags,
    {
      Name        = "${var.environment_name}-security-group-waf"
      Environment = var.environment_name
      Account     = local.account_id
      Region      = local.region
      ManagedBy   = "Terraform"
      Purpose     = "Security Group Account WAF Protection"
    }
  )
}