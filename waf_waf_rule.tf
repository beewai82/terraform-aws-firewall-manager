# Rule 0: Allow trusted IPs
resource "aws_wafv2_web_acl_rule" "allow_trusted_ips" {
  name        = "${var.environment}-AllowTrustedIPs"
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
    metric_name                = "${replace(var.environment, "-", "")}AllowTrustedIPs"
    sampled_requests_enabled   = true
  }

  tags = {
    Name        = "AllowTrustedIPs"
    Environment = var.environment
    Account     = local.account_id
    Region      = local.deployment_region
    ManagedBy   = "Terraform"
    Purpose     = "Allow whitelisted IPs"
    Scope       = "SecurityGroupAccount"
  }
}


# Rule 1: Block bad IPs
resource "aws_wafv2_web_acl_rule" "block_bad_ips" {
  name        = "${var.environment}-BlockBadIPs"
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
    metric_name                = "${replace(var.environment, "-", "")}BlockBadIPs"
    sampled_requests_enabled   = true
  }

  tags = {
    Name        = "BlockBadIPs"
    Environment = var.environment
    Account     = local.account_id
    Region      = local.deployment_region
    ManagedBy   = "Terraform"
    Purpose     = "Block blacklisted IPs"
    Scope       = "SecurityGroupAccount"
  }
}

# Rule 2: Rate limiting
resource "aws_wafv2_web_acl_rule" "rate_limit" {
  name        = "${var.environment}-RateLimit"
  priority    = 10
  web_acl_arn = aws_wafv2_web_acl.org_waf.arn

  action {
    block {}
  }

  statement {
    rate_based_statement {
      limit              = var.rate_limit_requests
      aggregate_key_type = "IP"
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${replace(var.environment, "-", "")}RateLimit"
    sampled_requests_enabled   = true
  }

  tags = {
    Name        = "RateLimit"
    Environment = var.environment
    Account     = local.account_id
    Region      = local.deployment_region
    ManagedBy   = "Terraform"
    Purpose     = "Rate limiting protection"
    Scope       = "SecurityGroupAccount"
  }
}

# AWS Core Rule Set
resource "aws_wafv2_web_acl_rule" "crs" {
  name        = "${var.environment}-AWSCoreRuleSet"
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
    metric_name                = "${replace(var.environment, "-", "")}AWSCoreRuleSet"
    sampled_requests_enabled   = true
  }

  tags = {
    Name        = "AWSCoreRuleSet"
    Environment = var.environment
    Account     = local.account_id
    Region      = local.deployment_region
    ManagedBy   = "Terraform"
    Purpose     = "AWS Core Rule Set protection"
    Scope       = "SecurityGroupAccount"
  }
}

# Known Bad Inputs (Log4j, SSRF, etc.)
resource "aws_wafv2_web_acl_rule" "known_bad_inputs" {
  name        = "${var.environment}-KnownBadInputs"
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
    metric_name                = "${replace(var.environment, "-", "")}KnownBadInputs"
    sampled_requests_enabled   = true
  }

  tags = {
    Name        = "KnownBadInputs"
    Environment = var.environment
    Account     = local.account_id
    Region      = local.deployment_region
    ManagedBy   = "Terraform"
    Purpose     = "Known bad inputs protection (Log4j, SSRF)"
    Scope       = "SecurityGroupAccount"
  }
}

# SQL Injection
resource "aws_wafv2_web_acl_rule" "sqli" {
  name        = "${var.environment}-SQLiRuleSet"
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
    metric_name                = "${replace(var.environment, "-", "")}SQLiRuleSet"
    sampled_requests_enabled   = true
  }

  tags = {
    Name        = "SQLiRuleSet"
    Environment = var.environment
    Account     = local.account_id
    Region      = local.deployment_region
    ManagedBy   = "Terraform"
    Purpose     = "SQL Injection protection"
    Scope       = "SecurityGroupAccount"
  }
}

# IP Reputation List
resource "aws_wafv2_web_acl_rule" "ip_reputation" {
  name        = "${var.environment}-IPReputation"
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
    metric_name                = "${replace(var.environment, "-", "")}IPReputation"
    sampled_requests_enabled   = true
  }

  tags = {
    Name        = "IPReputation"
    Environment = var.environment
    Account     = local.account_id
    Region      = local.deployment_region
    ManagedBy   = "Terraform"
    Purpose     = "IP Reputation protection"
    Scope       = "SecurityGroupAccount"
  }
}
