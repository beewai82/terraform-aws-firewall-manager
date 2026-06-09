# AWS Core Rule Set
resource "aws_wafv2_web_acl_rule" "crs" {
  name        = "AWSCoreRuleSet"
  priority    = 20
  web_acl_arn = aws_wafv2_web_acl.org_waf.arn

  override_action {
    none {} 
  }

  statement {
    managed_rule_group_statement {
      name        = "AWSManagedRulesCommonRuleSet"
      vendor_name = "AWS"
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "AWSCoreRuleSet"
    sampled_requests_enabled   = true
  }
}

# Known Bad Inputs (Log4j, SSRF, etc.)
resource "aws_wafv2_web_acl_rule" "known_bad_inputs" {
  name        = "KnownBadInputs"
  priority    = 21
  web_acl_arn = aws_wafv2_web_acl.org_waf.arn

  override_action {
    none {} 
  }

  statement {
    managed_rule_group_statement {
      name        = "AWSManagedRulesKnownBadInputsRuleSet"
      vendor_name = "AWS"
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "KnownBadInputs"
    sampled_requests_enabled   = true
  }
}

# SQL Injection
resource "aws_wafv2_web_acl_rule" "sqli" {
  name        = "SQLiRuleSet"
  priority    = 22
  web_acl_arn = aws_wafv2_web_acl.org_waf.arn

  override_action {
    none {} 
  }

  statement {
    managed_rule_group_statement {
      name        = "AWSManagedRulesSQLiRuleSet"
      vendor_name = "AWS"
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "SQLiRuleSet"
    sampled_requests_enabled   = true
  }
}

# IP Reputation List
resource "aws_wafv2_web_acl_rule" "ip_reputation" {
  name        = "IPReputation"
  priority    = 23
  web_acl_arn = aws_wafv2_web_acl.org_waf.arn

  override_action {
    none {} 
  }

  statement {
    managed_rule_group_statement {
      name        = "AWSManagedRulesAmazonIpReputationList"
      vendor_name = "AWS"
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "IPReputation"
    sampled_requests_enabled   = true
  }
}