# Rule 0: Allow trusted IPs
resource "aws_wafv2_web_acl_rule" "allow_trusted_ips" {
  name        = "AllowTrustedIPs"
  priority    = 0
  web_acl_arn = aws_wafv2_web_acl.org_waf.arn

  action {
    allow {}
  }

  statement {
    ip_set_reference_statement {
      arn = aws_wafv2_ip_set.allowlist.arn
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "AllowTrustedIPs"
    sampled_requests_enabled   = true
  }
}


# Rule 1: Block bad IPs
resource "aws_wafv2_web_acl_rule" "block_bad_ips" {
  name        = "BlockBadIPs"
  priority    = 1
  web_acl_arn = aws_wafv2_web_acl.org_waf.arn

  action {
    block {}
  }

  statement {
    ip_set_reference_statement {
      arn = aws_wafv2_ip_set.blocklist.arn
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "BlockBadIPs"
    sampled_requests_enabled   = true
  }
}

# Rule 2: Rate limiting
resource "aws_wafv2_web_acl_rule" "rate_limit" {
  name        = "RateLimit"
  priority    = 10
  web_acl_arn = aws_wafv2_web_acl.org_waf.arn

  action {
    block {}
  }

  statement {
    rate_based_statement {
      limit              = 2000 # requests per 5-minute window per IP
      aggregate_key_type = "IP"
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "RateLimit"
    sampled_requests_enabled   = true
  }
}

# AWS Core Rule Set
resource "aws_wafv2_web_acl_rule" "crs" {
  name        = "AWSCoreRuleSet"
  priority    = 20
  web_acl_arn = aws_wafv2_web_acl.org_waf.arn

  override_action {
    count {} 
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
    count {} 
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
    count {}
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
    count {}
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
