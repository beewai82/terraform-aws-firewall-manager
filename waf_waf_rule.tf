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

