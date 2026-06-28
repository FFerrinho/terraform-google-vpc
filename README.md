# terraform-google-vpc

Terraform module that provisions a Google Cloud VPC and its core networking primitives:

- a VPC network (`vpc-<vpc_name>`) with configurable routing mode, MTU, and IPv6 settings;
- map-driven subnetworks (`subnet-<key>`) with optional secondary ranges and VPC flow-log config;
- per-subnet IAM bindings (authoritative `google_compute_subnetwork_iam_binding`);
- optional Shared VPC host-project enablement and service-project attachment.

It is a leaf module — it consumes no other modules and defines no backend; the calling
configuration owns state and supplies `project_id`.

Resource names default to `vpc-<vpc_name>` and `subnet-<key>`. Override `vpc_name_prefix` /
`subnet_name_prefix` to change them, or set either to `""` to drop the prefix entirely.

## Usage

### Minimal

```hcl
module "vpc" {
  source     = "github.com/FFerrinho/terraform-google-vpc?ref=v1.0.0"
  project_id = "my-project-id"
  vpc_name   = "simple"

  subnets = {
    "subnet-1" = {
      ip_cidr_range = "10.0.0.0/24"
      region        = "us-central1"
    }
  }
}
```

### Complete

```hcl
module "vpc" {
  source     = "github.com/FFerrinho/terraform-google-vpc?ref=v1.0.0"
  project_id = "my-project-id"
  vpc_name   = "complete"

  vpc_description = "Complete VPC example with all features"
  routing_mode    = "REGIONAL"
  mtu             = 1460

  subnets = {
    "app-subnet" = {
      ip_cidr_range            = "10.0.0.0/24"
      region                   = "us-central1"
      description              = "Application subnet"
      private_ip_google_access = true

      secondary_ip_ranges = [
        { range_name = "pods", ip_cidr_range = "172.16.0.0/20" },
        { range_name = "services", ip_cidr_range = "172.16.16.0/24" },
      ]

      log_config = {
        aggregation_interval = "INTERVAL_10_MIN"
        flow_sampling        = 0.5
        metadata             = "INCLUDE_ALL_METADATA"
      }
    }
  }

  # IAM bindings are keyed by subnet, then by role:
  #   map(subnet => map(role => { members, region }))
  iam_bindings = {
    "app-subnet" = {
      "roles/compute.networkUser" = {
        region  = "us-central1"
        members = ["serviceAccount:service-account@my-project-id.iam.gserviceaccount.com"]
      }
    }
  }

  # Shared VPC
  enable_vpc_host_project = true
  vpc_service_projects    = ["service-project-id"]
  deletion_policy         = "ABANDON"
}
```

## Examples

- [`example/simple.tf`](example/simple.tf) — minimal VPC with a single subnet.
- [`example/full.tf`](example/full.tf) — all features (subnets, secondary ranges, flow logs, IAM, Shared VPC).

## Documentation

The section below is generated with [terraform-docs](https://terraform-docs.io). After changing any
variable or output, regenerate it from the repo root:

```sh
terraform-docs .
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 6.0, < 8.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_google"></a> [google](#provider\_google) | 7.38.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [google_compute_network.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) | resource |
| [google_compute_shared_vpc_host_project.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_shared_vpc_host_project) | resource |
| [google_compute_shared_vpc_service_project.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_shared_vpc_service_project) | resource |
| [google_compute_subnetwork.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |
| [google_compute_subnetwork_iam_binding.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork_iam_binding) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_auto_create_subnetworks"></a> [auto\_create\_subnetworks](#input\_auto\_create\_subnetworks) | If subnetworks should be automatically created. | `bool` | `true` | no |
| <a name="input_delete_default_routes_on_create"></a> [delete\_default\_routes\_on\_create](#input\_delete\_default\_routes\_on\_create) | Whether to delete the default routes created by the VPC network. | `bool` | `false` | no |
| <a name="input_deletion_policy"></a> [deletion\_policy](#input\_deletion\_policy) | The deletion policy for the Shared VPC service project attachment. | `string` | `"ABANDON"` | no |
| <a name="input_enable_vpc_host_project"></a> [enable\_vpc\_host\_project](#input\_enable\_vpc\_host\_project) | Whether to enable the VPC host project. | `bool` | `false` | no |
| <a name="input_iam_bindings"></a> [iam\_bindings](#input\_iam\_bindings) | IAM bindings per subnet and role | <pre>map(map(object({<br/>    members = set(string)<br/>    region  = string<br/>  })))</pre> | `{}` | no |
| <a name="input_internal_ipv6_range"></a> [internal\_ipv6\_range](#input\_internal\_ipv6\_range) | The range of internal IPv6 addresses managed by the VPC. | `string` | `null` | no |
| <a name="input_mtu"></a> [mtu](#input\_mtu) | The network MTU. | `number` | `null` | no |
| <a name="input_network_firewall_policy_enforcement_order"></a> [network\_firewall\_policy\_enforcement\_order](#input\_network\_firewall\_policy\_enforcement\_order) | The network firewall policy enforcement order. | `string` | `null` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID. | `string` | n/a | yes |
| <a name="input_routing_mode"></a> [routing\_mode](#input\_routing\_mode) | The network routing mode (default 'GLOBAL'). | `string` | `"GLOBAL"` | no |
| <a name="input_subnet_name_prefix"></a> [subnet\_name\_prefix](#input\_subnet\_name\_prefix) | Prefix prepended to each subnet name, producing '<prefix>-<subnet key>'. Set to an empty string to use the subnet key as-is. | `string` | `"subnet"` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Settings for the subnets | <pre>map(object({<br/>    ip_cidr_range            = string<br/>    description              = optional(string)<br/>    purpose                  = optional(string)<br/>    role                     = optional(string)<br/>    private_ip_google_access = optional(bool)<br/>    region                   = string<br/>    stack_type               = optional(string)<br/>    ipv6_access_type         = optional(string)<br/>    external_ipv6_prefix     = optional(string)<br/><br/>    secondary_ip_ranges = optional(list(object({<br/>      range_name    = string<br/>      ip_cidr_range = string<br/>    })))<br/><br/>    log_config = optional(object({ # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork#nested_log_config<br/>      aggregation_interval = optional(string)<br/>      flow_sampling        = optional(number)<br/>      metadata             = optional(string)<br/>      metadata_fields      = optional(set(string))<br/>      filter_expr          = optional(string) # https://cloud.google.com/vpc/docs/flow-logs#filtering<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_vpc_description"></a> [vpc\_description](#input\_vpc\_description) | A description of the VPC. | `string` | `null` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | The name of the VPC. | `string` | n/a | yes |
| <a name="input_vpc_name_prefix"></a> [vpc\_name\_prefix](#input\_vpc\_name\_prefix) | Prefix prepended to the VPC name, producing '<prefix>-<vpc\_name>'. Set to an empty string to use vpc\_name as-is. | `string` | `"vpc"` | no |
| <a name="input_vpc_service_projects"></a> [vpc\_service\_projects](#input\_vpc\_service\_projects) | A set of service project IDs to attach to the Shared VPC host project. | `set(string)` | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_iam_bindings"></a> [iam\_bindings](#output\_iam\_bindings) | IAM bindings for the subnetworks |
| <a name="output_network_id"></a> [network\_id](#output\_network\_id) | The ID of the VPC |
| <a name="output_subnets_ips"></a> [subnets\_ips](#output\_subnets\_ips) | The IPs and CIDRs of the subnets |
| <a name="output_subnets_secondary_ranges"></a> [subnets\_secondary\_ranges](#output\_subnets\_secondary\_ranges) | The secondary ranges of each subnet |
| <a name="output_subnetwork_ids"></a> [subnetwork\_ids](#output\_subnetwork\_ids) | The IDs of all subnetworks. |
| <a name="output_subnetwork_self_links"></a> [subnetwork\_self\_links](#output\_subnetwork\_self\_links) | The self links of all subnetworks. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
| <a name="output_vpc_name"></a> [vpc\_name](#output\_vpc\_name) | The name of the VPC. |
| <a name="output_vpc_self_link"></a> [vpc\_self\_link](#output\_vpc\_self\_link) | The VPC self link. |
<!-- END_TF_DOCS -->
