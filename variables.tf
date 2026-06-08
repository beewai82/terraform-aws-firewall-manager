variable "region" {
  description = "AWS region for WAF deployment"
  type        = string
  default     = "us-east-1"
}

variable "environment_name" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "prod"
}

variable "trusted_ip_list" {
  description = "List of trusted IPs to allow through WAF"
  type        = list(string)
  default     = ["10.0.0.0/8"]
}

variable "blocked_ip_list" {
  description = "List of known malicious IPs to block"
  type        = list(string)
  default     = []
}

variable "rate_limit_threshold" {
  description = "Rate limit threshold: requests per 5-minute window per IP"
  type        = number
  default     = 2000
}

variable "enable_cloudwatch_metrics" {
  description = "Enable CloudWatch metrics for WAF rules"
  type        = bool
  default     = true
}

variable "enable_sampled_requests" {
  description = "Enable sampled requests logging"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Common tags to apply to all resources (reference from parent config)"
  type        = map(string)
  default = {
    Project     = "SecurityTools"
    ManagedBy   = "Terraform"
    CostCenter  = "Security"
    Owner       = "SecurityTeam"
  }
}

variable "waf_rules_enabled" {
  description = "Map of WAF rules to enable/disable"
  type = map(bool)
  default = {
    allow_trusted_ips  = true
    block_bad_ips      = true
    rate_limit         = true
    crs                = true
    known_bad_inputs   = true
    sqli               = true
    ip_reputation      = true
  }
}
