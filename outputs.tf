output "subnetwork_self_links" {
  description = "The self links of all subnetworks"
  value       = [for s in google_compute_subnetwork.main : s.self_link]
}
