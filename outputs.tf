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
