module "vpc" {
  source     = "path/to/module"
  project_id = "my-project-id"
  vpc_name   = "simple-vpc"

  subnets = {
    "subnet-1" = {
      ip_cidr_range = "10.0.0.0/24"
      region        = "us-central1"
    }
  }
}
