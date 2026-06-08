output "waf_acl_arn" {
  description = "ARN of the security group account WAF ACL"
  value       = aws_wafv2_web_acl.org_waf.arn
}

output "waf_acl_id" {
  description = "ID of the security group account WAF ACL"
  value       = aws_wafv2_web_acl.org_waf.id
}

output "waf_acl_name" {
  description = "Name of the security group account WAF ACL"
  value       = aws_wafv2_web_acl.org_waf.name
}

output "allowlist_ip_set_arn" {
  description = "ARN of the allowlist IP set"
  value       = aws_wafv2_ip_set.allowlist.arn
}

output "blocklist_ip_set_arn" {
  description = "ARN of the blocklist IP set"
  value       = aws_wafv2_ip_set.blocklist.arn
}

output "account_id" {
  description = "AWS Account ID where WAF is deployed"
  value       = local.account_id
}

output "deployment_region" {
  description = "AWS region where WAF is deployed"
  value       = local.deployment_region
}

output "environment" {
  description = "Environment name"
  value       = var.environment
}

output "waf_rules" {
  description = "Summary of deployed WAF rules"
  value = {
    allow_trusted_ips = aws_wafv2_web_acl_rule.allow_trusted_ips.name
    block_bad_ips     = aws_wafv2_web_acl_rule.block_bad_ips.name
    rate_limit        = aws_wafv2_web_acl_rule.rate_limit.name
    crs               = aws_wafv2_web_acl_rule.crs.name
    known_bad_inputs  = aws_wafv2_web_acl_rule.known_bad_inputs.name
    sqli              = aws_wafv2_web_acl_rule.sqli.name
    ip_reputation     = aws_wafv2_web_acl_rule.ip_reputation.name
  }
}
