# Rule 0: Allow trusted IPs
resource "aws_wafv2_web_acl_rule" "allow_trusted_ips" {
  name        = "${var.environment_name}-allow-trusted-ips"
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
    cloudwatch_metrics_enabled = var.enable_cloudwatch_metrics
    metric_name                = "${replace(var.environment_name, "-", "")}AllowTrustedIPs"
    sampled_requests_enabled   = var.enable_sampled_requests
  }

  tags = merge(
    var.tags,
    {
      Name        = "AllowTrustedIPs"
      Environment = var.environment_name
      Account     = local.account_id
      Region      = local.region
      ManagedBy   = "Terraform"
      Purpose     = "Allow trusted IPs"
      Scope       = "SecurityGroupAccount"
    }
  )
}


# Rule 1: Block bad IPs
resource "aws_wafv2_web_acl_rule" "block_bad_ips" {
  name        = "${var.environment_name}-block-bad-ips"
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
    cloudwatch_metrics_enabled = var.enable_cloudwatch_metrics
    metric_name                = "${replace(var.environment_name, "-", "")}BlockBadIPs"
    sampled_requests_enabled   = var.enable_sampled_requests
  }

  tags = merge(
    var.tags,
    {
      Name        = "BlockBadIPs"
      Environment = var.environment_name
      Account     = local.account_id
      Region      = local.region
      ManagedBy   = "Terraform"
      Purpose     = "Block bad IPs"
      Scope       = "SecurityGroupAccount"
    }
  )
}

# Rule 2: Rate limiting
resource "aws_wafv2_web_acl_rule" "rate_limit" {
  name        = "${var.environment_name}-rate-limit"
  priority    = 10
  web_acl_arn = aws_wafv2_web_acl.security_group_waf.arn

  action {
    block {}
  }

  statement {
    rate_based_statement {
      limit              = var.rate_limit_threshold
      aggregate_key_type = "IP"
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = var.enable_cloudwatch_metrics
    metric_name                = "${replace(var.environment_name, "-", "")}RateLimit"
    sampled_requests_enabled   = var.enable_sampled_requests
  }

  tags = merge(
    var.tags,
    {
      Name        = "RateLimit"
      Environment = var.environment_name
      Account     = local.account_id
      Region      = local.region
      ManagedBy   = "Terraform"
      Purpose     = "Rate limiting protection"
      Scope       = "SecurityGroupAccount"
    }
  )
}

# AWS Core Rule Set
resource "aws_wafv2_web_acl_rule" "crs" {
  name        = "${var.environment_name}-aws-core-rule-set"
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
    cloudwatch_metrics_enabled = var.enable_cloudwatch_metrics
    metric_name                = "${replace(var.environment_name, "-", "")}AWSCoreRuleSet"
    sampled_requests_enabled   = var.enable_sampled_requests
  }

  tags = merge(
    var.tags,
    {
      Name        = "AWSCoreRuleSet"
      Environment = var.environment_name
      Account     = local.account_id
      Region      = local.region
      ManagedBy   = "Terraform"
      Purpose     = "AWS Core Rule Set protection"
      Scope       = "SecurityGroupAccount"
    }
  )
}

# Known Bad Inputs (Log4j, SSRF, etc.)
resource "aws_wafv2_web_acl_rule" "known_bad_inputs" {
  name        = "${var.environment_name}-known-bad-inputs"
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
    cloudwatch_metrics_enabled = var.enable_cloudwatch_metrics
    metric_name                = "${replace(var.environment_name, "-", "")}KnownBadInputs"
    sampled_requests_enabled   = var.enable_sampled_requests
  }

  tags = merge(
    var.tags,
    {
      Name        = "KnownBadInputs"
      Environment = var.environment_name
      Account     = local.account_id
      Region      = local.region
      ManagedBy   = "Terraform"
      Purpose     = "Known bad inputs protection (Log4j, SSRF)"
      Scope       = "SecurityGroupAccount"
    }
  )
}

# SQL Injection
resource "aws_wafv2_web_acl_rule" "sqli" {
  name        = "${var.environment_name}-sql-injection"
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
    cloudwatch_metrics_enabled = var.enable_cloudwatch_metrics
    metric_name                = "${replace(var.environment_name, "-", "")}SQLiRuleSet"
    sampled_requests_enabled   = var.enable_sampled_requests
  }

  tags = merge(
    var.tags,
    {
      Name        = "SQLiRuleSet"
      Environment = var.environment_name
      Account     = local.account_id
      Region      = local.region
      ManagedBy   = "Terraform"
      Purpose     = "SQL Injection protection"
      Scope       = "SecurityGroupAccount"
    }
  )
}

# IP Reputation List
resource "aws_wafv2_web_acl_rule" "ip_reputation" {
  name        = "${var.environment_name}-ip-reputation"
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
    cloudwatch_metrics_enabled = var.enable_cloudwatch_metrics
    metric_name                = "${replace(var.environment_name, "-", "")}IPReputation"
    sampled_requests_enabled   = var.enable_sampled_requests
  }

  tags = merge(
    var.tags,
    {
      Name        = "IPReputation"
      Environment = var.environment_name
      Account     = local.account_id
      Region      = local.region
      ManagedBy   = "Terraform"
      Purpose     = "IP Reputation protection"
      Scope       = "SecurityGroupAccount"
    }
  )
}
