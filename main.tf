resource "google_compute_network" "main" {
  name                                      = join("-", ["vpc", var.vpc_name])
  description                               = var.vpc_description
  auto_create_subnetworks                   = var.auto_create_subnetworks
  routing_mode                              = var.routing_mode
  mtu                                       = var.mtu
  internal_ipv6_range                       = var.internal_ipv6_range
  network_firewall_policy_enforcement_order = var.network_firewall_policy_enforcement_order
  project                                   = var.project_id
  delete_default_routes_on_create           = var.delete_default_routes_on_create
}

resource "google_compute_subnetwork" "main" {
  for_each                 = var.subnets != null ? var.subnets : {}
  ip_cidr_range            = each.value["ip_cidr_range"]
  name                     = join("-", ["subnet", each.key])
  network                  = google_compute_network.main.self_link
  description              = each.value["description"]
  purpose                  = each.value["purpose"]
  role                     = each.value["role"]
  private_ip_google_access = each.value["private_ip_google_access"]
  region                   = each.value["region"]
  stack_type               = each.value["stack_type"]
  ipv6_access_type         = each.value["ipv6_access_type"]
  external_ipv6_prefix     = each.value["external_ipv6_prefix"]

  dynamic "secondary_ip_range" {
    for_each = each.value["secondary_ip_ranges"] != null ? each.value["secondary_ip_ranges"] : []
    content {
      range_name    = secondary_ip_range.value["range_name"]
      ip_cidr_range = secondary_ip_range.value["ip_cidr_range"]
    }
  }

  dynamic "log_config" {
    for_each = each.value["log_config"] != null ? [each.value["log_config"]] : []
    content {
      aggregation_interval = log_config.value["aggregation_interval"]
      flow_sampling        = log_config.value["flow_sampling"]
      metadata             = log_config.value["metadata"]
      metadata_fields      = log_config.value["metadata_fields"]
      filter_expr          = log_config.value["filter_expr"]
    }
  }
}

locals {
  flattened_iam_bindings = flatten([
    for role, binding in var.iam_bindings : [
      for subnet in binding.subnetwork : {
        role     = role
        region   = binding.region
        subnet   = subnet
        members  = binding.members
      }
    ]
  ])
}

resource "google_compute_subnetwork_iam_binding" "main" {
  for_each = { for b in local.flattened_iam_bindings : "${b.role}.${b.subnet}" => b }

  project    = var.project_id
  region     = each.value.region
  role       = each.value.role
  subnetwork = join("-", ["subnet", each.value.subnet])
  members = each.value.members

  depends_on = [ google_compute_subnetwork.main ]
}

resource "google_compute_shared_vpc_host_project" "main" {
  count = var.enable_vpc_host_project ? 1 : 0
  project = var.project_id
}

resource "google_compute_shared_vpc_service_project" "main" {
  for_each = var.vpc_service_projects != null ? var.vpc_service_projects : []
  host_project = google_compute_shared_vpc_host_project.main[0].project
  service_project = each.key
  deletion_policy = var.deletion_policy
}
