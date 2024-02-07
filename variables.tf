variable "vpc_name" {
  description = "The name of the VPC."
  type        = string
}

variable "vpc_description" {
  description = "A description of the VPC."
  type        = string
  default     = null
}

variable "auto_create_subnetworks" {
  description = "If subnetworks should be automatically created."
  type        = bool
  default     = true
}

variable "routing_mode" {
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network#routing_mode
  description = "The network routing mode (default 'GLOBAL')."
  type        = string
  default     = "GLOBAL"
}

variable "mtu" {
  description = "The network MTU."
  type        = number
  default     = null
}

variable "internal_ipv6_range" {
  description = "The range of internal IPv6 addresses managed by the VPC."
  type        = string
  default     = null
}

variable "network_firewall_policy_enforcement_order" {
  description = "The network firewall policy enforcement order."
  type        = string
  default     = null
}
variable "project_id" {
  description = "The project ID."
  type        = string
}

variable "delete_default_routes_on_create" {
  description = "Whether to delete the default routes created by the VPC network."
  type        = bool
  default     = false
}

variable "subnets" {
  description = "Settings for the subnets"
  type = map(object({
    ip_cidr_range            = string
    description              = optional(string)
    purpose                  = optional(string)
    role                     = optional(string)
    private_ip_google_access = optional(bool)
    region                   = string
    stack_type               = optional(string)
    ipv6_access_type         = optional(string)
    external_ipv6_prefix     = optional(string)

    secondary_ip_ranges = optional(list(object({
      range_name    = string
      ip_cidr_range = string
    })))

    log_config = optional(object({ # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork#nested_log_config
      aggregation_interval = optional(string)
      flow_sampling        = optional(number)
      metadata             = optional(string)
      metadata_fields      = optional(set(string))
      filter_expr          = optional(string) # https://cloud.google.com/vpc/docs/flow-logs#filtering
    }))
  }))
  default = {}
}

variable "iam_bindings" {
  description = "IAM bindings"
  type = map(object({
    region  = string
    subnetwork = set(string)
    members = set(string)
  }))
  default = {}
}
