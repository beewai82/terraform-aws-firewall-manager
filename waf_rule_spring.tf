# Rule: Allow SpringEq Network or US traffic with approved headers
resource "aws_wafv2_web_acl_rule" "allow_springeq_network_or_us_with_headers" {
  name        = "prod-security-group-allow-springeq-or-us-headers"
  priority    = 16
  web_acl_arn = aws_wafv2_web_acl.security_group_waf.arn

  action {
    allow {}
  }

  statement {
    or_statement {
      statement {
        ip_set_reference_statement {
          arn = aws_wafv2_ip_set.springeq_allowed_ips.arn
        }
      }

      statement {
        and_statement {
          statement {
            geo_match_statement {
              country_codes = ["US"]
            }
          }

          statement {
            or_statement {
              statement {
                byte_match_statement {
                  search_string = "*.springeq.com"
                  field_to_match {
                    single_header {
                      name = "referer"
                    }
                  }
                  text_transformation {
                    priority = 0
                    type     = "LOWERCASE"
                  }
                  positional_constraint = "CONTAINS"
                }
              }

              statement {
                byte_match_statement {
                  search_string = "*.springeq.net"
                  field_to_match {
                    single_header {
                      name = "referer"
                    }
                  }
                  text_transformation {
                    priority = 0
                    type     = "LOWERCASE"
                  }
                  positional_constraint = "CONTAINS"
                }
              }
            }
          }
        }
      }
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "ProdAllowSpringEqNetworkOrUS"
    sampled_requests_enabled   = true
  }
}