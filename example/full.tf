module "complete" {
  source     = "../"
  project_id = "my-project-id"
  vpc_name   = "complete"

  vpc_description = "Complete VPC example with all features"
  routing_mode    = "REGIONAL"
  mtu             = 1460

  # Subnet configuration
  subnets = {
    "app-subnet" = {
      ip_cidr_range            = "10.0.0.0/24"
      region                   = "us-central1"
      description              = "Application subnet"
      private_ip_google_access = true

      secondary_ip_ranges = [
        {
          range_name    = "pods"
          ip_cidr_range = "172.16.0.0/20"
        },
        {
          range_name    = "services"
          ip_cidr_range = "172.16.16.0/24"
        }
      ]

      log_config = {
        aggregation_interval = "INTERVAL_10_MIN"
        flow_sampling        = 0.5
        metadata             = "INCLUDE_ALL_METADATA"
      }
    }
  }

  # IAM bindings: keyed by subnet, then by role -> { members, region }
  iam_bindings = {
    "app-subnet" = {
      "roles/compute.networkUser" = {
        region  = "us-central1"
        members = ["serviceAccount:service-account@my-project-id.iam.gserviceaccount.com"]
      }
    }
  }

  # Shared VPC configuration
  enable_vpc_host_project = true
  vpc_service_projects    = ["service-project-id"]
  deletion_policy         = "ABANDON"
}
