resource "aws_wafv2_web_acl" "org_waf" {
  name        = "org-waf-acl"
  description = "Org-wide WAF ACL managed by FMS — rules managed separately"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  # Required block even when rules are external — sets ACL-level metrics
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "OrgWAFAcl"
    sampled_requests_enabled   = true
  }

  tags = { ManagedBy = "Terraform" }
}