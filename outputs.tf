output "security_group_waf_acl_arn" {
  description = "ARN of the security group account WAF ACL"
  value       = aws_wafv2_web_acl.security_group_waf.arn
}

output "security_group_waf_acl_id" {
  description = "ID of the security group account WAF ACL"
  value       = aws_wafv2_web_acl.security_group_waf.id
}

output "security_group_waf_acl_name" {
  description = "Name of the security group account WAF ACL"
  value       = aws_wafv2_web_acl.security_group_waf.name
}

output "trusted_ips_set_arn" {
  description = "ARN of the trusted IP set"
  value       = aws_wafv2_ip_set.trusted_ips.arn
}

output "blocked_ips_set_arn" {
  description = "ARN of the blocked IP set"
  value       = aws_wafv2_ip_set.blocked_ips.arn
}

output "account_id" {
  description = "AWS Account ID where WAF is deployed"
  value       = local.account_id
}

output "deployment_region" {
  description = "AWS region where WAF is deployed"
  value       = local.region
}

output "environment_name" {
  description = "Environment name"
  value       = var.environment_name
}

output "waf_rules_deployed" {
  description = "Summary of deployed WAF rules"
  value = {
    allow_trusted_ips  = aws_wafv2_web_acl_rule.allow_trusted_ips.name
    block_bad_ips      = aws_wafv2_web_acl_rule.block_bad_ips.name
    rate_limit         = aws_wafv2_web_acl_rule.rate_limit.name
    crs                = aws_wafv2_web_acl_rule.crs.name
    known_bad_inputs   = aws_wafv2_web_acl_rule.known_bad_inputs.name
    sqli               = aws_wafv2_web_acl_rule.sqli.name
    ip_reputation      = aws_wafv2_web_acl_rule.ip_reputation.name
  }
}
