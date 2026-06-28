module "simple" {
  source     = "../"
  project_id = "my-project-id"
  vpc_name   = "simple"

  subnets = {
    "subnet-1" = {
      ip_cidr_range = "10.0.0.0/24"
      region        = "us-central1"
    }
  }
}
