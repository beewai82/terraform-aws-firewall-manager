resource "aws_wafv2_web_acl" "org_waf" {
  name        = "${var.environment}-security-group-waf-acl"
  description = "Regional WAF ACL for Security Group Account"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  # Required block even when rules are external — sets ACL-level metrics
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.environment}-SecurityGroupWAF"
    sampled_requests_enabled   = true
  }

  tags = {
    Name        = "${var.environment}-security-group-waf"
    Environment = var.environment
    Account     = local.account_id
    Region      = local.deployment_region
    ManagedBy   = "Terraform"
    Purpose     = "Security Group Account WAF Protection"
  }
}