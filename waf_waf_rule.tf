# Rule 0: Allow trusted IPs
resource "aws_wafv2_web_acl_rule" "allow_trusted_ips" {
  name        = "prod-security-group-allow-trusted-ips"
  priority    = 0
  web_acl_arn = aws_wafv2_web_acl.security_group_waf.arn

  action {
    allow {}
  }

  statement {
    ip_set_reference_statement {
      arn = aws_wafv2_ip_set.trusted_ips.arn
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "ProdAllowTrustedIPs"
    sampled_requests_enabled   = true
  }

  tags = merge(
    local.common_tags,
    {
      Name    = "AllowTrustedIPs"
      Purpose = "Allow trusted IPs"
    }
  )
}


# Rule 1: Block bad IPs
resource "aws_wafv2_web_acl_rule" "block_bad_ips" {
  name        = "prod-security-group-block-bad-ips"
  priority    = 1
  web_acl_arn = aws_wafv2_web_acl.security_group_waf.arn

  action {
    block {}
  }

  statement {
    ip_set_reference_statement {
      arn = aws_wafv2_ip_set.blocked_ips.arn
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "ProdBlockBadIPs"
    sampled_requests_enabled   = true
  }

  tags = merge(
    local.common_tags,
    {
      Name    = "BlockBadIPs"
      Purpose = "Block bad IPs"
    }
  )
}

# Rule 2: Rate limiting
resource "aws_wafv2_web_acl_rule" "rate_limit" {
  name        = "prod-security-group-rate-limit"
  priority    = 10
  web_acl_arn = aws_wafv2_web_acl.security_group_waf.arn

  action {
    block {}
  }

  statement {
    rate_based_statement {
      limit              = 2000
      aggregate_key_type = "IP"
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "ProdRateLimit"
    sampled_requests_enabled   = true
  }

  tags = merge(
    local.common_tags,
    {
      Name    = "RateLimit"
      Purpose = "Rate limiting protection"
    }
  )
}

# AWS Core Rule Set
resource "aws_wafv2_web_acl_rule" "crs" {
  name        = "prod-security-group-aws-core-rule-set"
  priority    = 20
  web_acl_arn = aws_wafv2_web_acl.security_group_waf.arn

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
    metric_name                = "ProdAWSCoreRuleSet"
    sampled_requests_enabled   = true
  }

  tags = merge(
    local.common_tags,
    {
      Name    = "AWSCoreRuleSet"
      Purpose = "AWS Core Rule Set protection"
    }
  )
}

# Known Bad Inputs (Log4j, SSRF, etc.)
resource "aws_wafv2_web_acl_rule" "known_bad_inputs" {
  name        = "prod-security-group-known-bad-inputs"
  priority    = 21
  web_acl_arn = aws_wafv2_web_acl.security_group_waf.arn

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
    metric_name                = "ProdKnownBadInputs"
    sampled_requests_enabled   = true
  }

  tags = merge(
    local.common_tags,
    {
      Name    = "KnownBadInputs"
      Purpose = "Known bad inputs protection (Log4j, SSRF)"
    }
  )
}

# SQL Injection
resource "aws_wafv2_web_acl_rule" "sqli" {
  name        = "prod-security-group-sql-injection"
  priority    = 22
  web_acl_arn = aws_wafv2_web_acl.security_group_waf.arn

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
    metric_name                = "ProdSQLiRuleSet"
    sampled_requests_enabled   = true
  }

  tags = merge(
    local.common_tags,
    {
      Name    = "SQLiRuleSet"
      Purpose = "SQL Injection protection"
    }
  )
}

# IP Reputation List
resource "aws_wafv2_web_acl_rule" "ip_reputation" {
  name        = "prod-security-group-ip-reputation"
  priority    = 23
  web_acl_arn = aws_wafv2_web_acl.security_group_waf.arn

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
    metric_name                = "ProdIPReputation"
    sampled_requests_enabled   = true
  }

  tags = merge(
    local.common_tags,
    {
      Name    = "IPReputation"
      Purpose = "IP Reputation protection"
    }
  )
}
