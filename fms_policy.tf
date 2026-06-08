resource "aws_fms_policy" "org_waf" {
  name                  = "org-waf-fms-policy"
  description           = "Pushes WAF ACL to all ALBs and API GW stages across the Org"
  remediation_enabled   = true
  exclude_resource_tags = false

  resource_type_list = [
    "AWS::ElasticLoadBalancingV2::LoadBalancer",
    "AWS::ApiGateway::Stage",
  ]

  # Empty include_map = apply to ALL accounts in the Organisation.
  # To target specific OUs: orgunit = ["ou-xxxx-yyyyyyy"]
  include_map {
    account = []
    orgunit = []
  }

  security_service_policy_data {
    type = "WAFV2"

    managed_service_data = jsonencode({
      type      = "WAFV2"
      webAclArn = aws_wafv2_web_acl.org_waf.arn

      preProcessRuleGroups  = []
      postProcessRuleGroups = []
      defaultAction         = { type = "ALLOW" }

      # false = respect any WAF ACL a member already set manually
      # true  = FMS always wins, overrides member-account associations
      overrideCustomerWebACLAssociation = false
    })
  }

  # Ensure all rules exist before FMS starts distributing the policy
  depends_on = [
    aws_wafv2_web_acl_rule.allow_trusted_ips,
    aws_wafv2_web_acl_rule.block_bad_ips,
    aws_wafv2_web_acl_rule.rate_limit,
    aws_wafv2_web_acl_rule.crs,
    aws_wafv2_web_acl_rule.known_bad_inputs,
    aws_wafv2_web_acl_rule.sqli,
    aws_wafv2_web_acl_rule.ip_reputation,
  ]

  tags = { ManagedBy = "Terraform" }
}