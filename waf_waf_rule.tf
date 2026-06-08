# Rule 0: Allow trusted IPs
resource "aws_wafv2_web_acl_rule" "allow_trusted_ips" {
  name        = "${local.name_prefix}-allow-trusted-ips"
  priority    = local.rule_priorities.allow_trusted_ips
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
    cloudwatch_metrics_enabled = local.enable_cloudwatch_metrics
    metric_name                = "${replace(local.environment, "-", "")}AllowTrustedIPs"
    sampled_requests_enabled   = local.enable_sampled_requests
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
  name        = "${local.name_prefix}-block-bad-ips"
  priority    = local.rule_priorities.block_bad_ips
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
    cloudwatch_metrics_enabled = local.enable_cloudwatch_metrics
    metric_name                = "${replace(local.environment, "-", "")}BlockBadIPs"
    sampled_requests_enabled   = local.enable_sampled_requests
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
  name        = "${local.name_prefix}-rate-limit"
  priority    = local.rule_priorities.rate_limit
  web_acl_arn = aws_wafv2_web_acl.security_group_waf.arn

  action {
    block {}
  }

  statement {
    rate_based_statement {
      limit              = local.rate_limit
      aggregate_key_type = "IP"
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = local.enable_cloudwatch_metrics
    metric_name                = "${replace(local.environment, "-", "")}RateLimit"
    sampled_requests_enabled   = local.enable_sampled_requests
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
  name        = "${local.name_prefix}-aws-core-rule-set"
  priority    = local.rule_priorities.crs
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
    cloudwatch_metrics_enabled = local.enable_cloudwatch_metrics
    metric_name                = "${replace(local.environment, "-", "")}AWSCoreRuleSet"
    sampled_requests_enabled   = local.enable_sampled_requests
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
  name        = "${local.name_prefix}-known-bad-inputs"
  priority    = local.rule_priorities.known_bad_inputs
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
    cloudwatch_metrics_enabled = local.enable_cloudwatch_metrics
    metric_name                = "${replace(local.environment, "-", "")}KnownBadInputs"
    sampled_requests_enabled   = local.enable_sampled_requests
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
  name        = "${local.name_prefix}-sql-injection"
  priority    = local.rule_priorities.sqli
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
    cloudwatch_metrics_enabled = local.enable_cloudwatch_metrics
    metric_name                = "${replace(local.environment, "-", "")}SQLiRuleSet"
    sampled_requests_enabled   = local.enable_sampled_requests
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
  name        = "${local.name_prefix}-ip-reputation"
  priority    = local.rule_priorities.ip_reputation
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
    cloudwatch_metrics_enabled = local.enable_cloudwatch_metrics
    metric_name                = "${replace(local.environment, "-", "")}IPReputation"
    sampled_requests_enabled   = local.enable_sampled_requests
  }

  tags = merge(
    local.common_tags,
    {
      Name    = "IPReputation"
      Purpose = "IP Reputation protection"
    }
  )
}
