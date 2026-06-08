# AWS Security Group Account WAF Module

Regional WAF (Web Application Firewall) deployment targeting a specific security group account. Replaces organization-wide AWS Firewall Manager policy with account-scoped protection.

## Overview

This Terraform module creates and manages AWS WAFv2 web ACLs with:
- IP allowlist/blocklist support
- Rate limiting
- AWS managed rule groups (Core Rules, Known Bad Inputs, SQL Injection, IP Reputation)
- CloudWatch metrics and logging
- Automatic account and region detection

## Integration as Subtree

This module is integrated into `springeq-inf/tooling-infra` as a subtree:

```bash
git subtree add --prefix security-tools/aws-firewall-manager \
  https://github.com/beewai82/terraform-aws-firewall-manager.git aws_fms_waf
```

### Updating from upstream

```bash
git subtree pull --prefix security-tools/aws-firewall-manager \
  https://github.com/beewai82/terraform-aws-firewall-manager.git aws_fms_waf
```

## Usage

### 1. Copy and customize variables

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` to set:
- AWS region
- Environment name
- Allowlist/blocklist IPs
- Rate limiting thresholds

### 2. Initialize and apply

```bash
terraform init
terraform plan
terraform apply
```

## Variables (with defaults)

| Variable | Default | Description |
|----------|---------|-------------|
| `aws_region` | `us-east-1` | AWS region for WAF deployment |
| `environment` | `prod` | Environment name (dev, staging, prod) |
| `allowlist_ips` | `["10.0.0.0/8"]` | Trusted IPs to bypass WAF |
| `blocklist_ips` | `[]` | Known malicious IPs to deny |
| `rate_limit_requests` | `2000` | Rate limit threshold per 5 minutes |
| `enable_cloudwatch_metrics` | `true` | Enable CloudWatch metrics |
| `enable_sampled_requests` | `true` | Enable sampled requests logging |
| `common_tags` | See variables.tf | Tags applied to all resources |
| `waf_rules_enabled` | All enabled | Enable/disable individual rules |

## Outputs

- `waf_acl_arn` - ARN of the WAF ACL
- `waf_acl_id` - ID of the WAF ACL
- `allowlist_ip_set_arn` - ARN of allowlist IP set
- `blocklist_ip_set_arn` - ARN of blocklist IP set
- `account_id` - Deployed account ID
- `deployment_region` - Deployed region
- `waf_rules` - Summary of deployed rules

## WAF Rules

1. **Allow Trusted IPs** - Whitelist known good traffic
2. **Block Bad IPs** - Blacklist known malicious traffic
3. **Rate Limiting** - Protect against DDoS attacks
4. **AWS Core Rule Set** - OWASP Top 10 protections
5. **Known Bad Inputs** - Log4j, SSRF, and known exploits
6. **SQL Injection** - SQL injection attack prevention
7. **IP Reputation** - Block IPs from AWS IP Reputation List

## Architecture

### Removed
- ❌ AWS Firewall Manager organization-wide policy
- ❌ Organization unit (OU) targeting

### Added
- ✅ Account-specific WAF ACL
- ✅ Regional deployment
- ✅ Configurable IP lists and thresholds
- ✅ Environment-aware naming
- ✅ Automatic account detection

## Scope

**This WAF ACL targets:**
- Regional resources (ALBs, API Gateway stages, CloudFront - see limitations)
- Single AWS account only
- Specified region

**Does NOT support:**
- CloudFront distributions (CloudFront WAF must be in us-east-1)
- Multiple accounts (use multiple deployments)
- Organization-wide policies (use AWS Firewall Manager instead)

## Tags

All resources include tags:
- `Name` - Resource identifier
- `Environment` - Environment (dev/staging/prod)
- `Account` - AWS Account ID
- `Region` - AWS Region
- `ManagedBy` - "Terraform"
- `Purpose` - Rule/resource purpose
- `Scope` - "SecurityGroupAccount"

## Prerequisites

- Terraform 1.10+
- AWS CLI v2 configured with appropriate credentials
- S3 bucket for state backend
- IAM permissions for WAF, IP sets, and web ACLs

## State Management

Terraform state is stored in S3:
- Bucket: `my-terraform-state-bucket`
- Key: `waf-regional/terraform.tfstate`
- Region: `us-east-1`

Update the S3 backend configuration in `terraform.tf` as needed.

## Contributing

1. Create a feature branch
2. Make changes to the module
3. Test with `terraform plan`
4. Push to `aws_fms_waf` branch
5. Create PR for review

## References

- [AWS WAFv2 Documentation](https://docs.aws.amazon.com/waf/latest/developerguide/)
- [Terraform AWS Provider - WAFv2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl)
