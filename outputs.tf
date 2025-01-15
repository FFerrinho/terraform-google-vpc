output "subnetwork_self_links" {
  description = "The self links of all subnetworks."
  value       = [for s in google_compute_subnetwork.main : s.self_link]
}

output "vpc_name" {
  description = "The name of the VPC."
  value = google_compute_network.main.name
}

output "vpc_self_link" {
  description = "The VPC self link."
  value = google_compute_network.main.self_link
}

output "iam_bindings" {
  description = "IAM bindings for the subnetworks"
  value = {
    for k, v in google_compute_subnetwork_iam_binding.main : basename(v.subnetwork) => {
      role = v.role
      members = join(", ", v.members)
    }...
  }
}

output "network_id" {
  description = "The ID of the VPC"
  value       = google_compute_network.main.id
}

output "subnets_secondary_ranges" {
  description = "The secondary ranges of each subnet"
  value = {
    for subnet_name, subnet in google_compute_subnetwork.main : subnet_name => subnet.secondary_ip_range
  }
}

output "subnets_ips" {
  description = "The IPs and CIDRs of the subnets"
  value = {
    for subnet_name, subnet in google_compute_subnetwork.main : subnet_name => {
      ip_cidr_range = subnet.ip_cidr_range
      gateway_address = subnet.gateway_address
      region = subnet.region
    }
  }
}
