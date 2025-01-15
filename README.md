## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 6.16.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_network.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) | resource |
| [google_compute_shared_vpc_host_project.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_shared_vpc_host_project) | resource |
| [google_compute_shared_vpc_service_project.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_shared_vpc_service_project) | resource |
| [google_compute_subnetwork.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |
| [google_compute_subnetwork_iam_binding.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork_iam_binding) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_create_subnetworks"></a> [auto\_create\_subnetworks](#input\_auto\_create\_subnetworks) | If subnetworks should be automatically created. | `bool` | `true` | no |
| <a name="input_delete_default_routes_on_create"></a> [delete\_default\_routes\_on\_create](#input\_delete\_default\_routes\_on\_create) | Whether to delete the default routes created by the VPC network. | `bool` | `false` | no |
| <a name="input_deletion_policy"></a> [deletion\_policy](#input\_deletion\_policy) | The deletion policy for the Shared VPC Service project attchement. | `string` | `"ABANDON"` | no |
| <a name="input_enable_vpc_host_project"></a> [enable\_vpc\_host\_project](#input\_enable\_vpc\_host\_project) | Whether to enable the VPC host project. | `bool` | `false` | no |
| <a name="input_iam_bindings"></a> [iam\_bindings](#input\_iam\_bindings) | IAM bindings | <pre>map(object({<br>    region  = string<br>    subnetwork = set(string)<br>    members = set(string)<br>  }))</pre> | `{}` | no |
| <a name="input_internal_ipv6_range"></a> [internal\_ipv6\_range](#input\_internal\_ipv6\_range) | The range of internal IPv6 addresses managed by the VPC. | `string` | `null` | no |
| <a name="input_mtu"></a> [mtu](#input\_mtu) | The network MTU. | `number` | `null` | no |
| <a name="input_network_firewall_policy_enforcement_order"></a> [network\_firewall\_policy\_enforcement\_order](#input\_network\_firewall\_policy\_enforcement\_order) | The network firewall policy enforcement order. | `string` | `null` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID. | `string` | n/a | yes |
| <a name="input_routing_mode"></a> [routing\_mode](#input\_routing\_mode) | The network routing mode (default 'GLOBAL'). | `string` | `"GLOBAL"` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Settings for the subnets | <pre>map(object({<br>    ip_cidr_range            = string<br>    description              = optional(string)<br>    purpose                  = optional(string)<br>    role                     = optional(string)<br>    private_ip_google_access = optional(bool)<br>    region                   = string<br>    stack_type               = optional(string)<br>    ipv6_access_type         = optional(string)<br>    external_ipv6_prefix     = optional(string)<br><br>    secondary_ip_ranges = optional(list(object({<br>      range_name    = string<br>      ip_cidr_range = string<br>    })))<br><br>    log_config = optional(object({ # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork#nested_log_config<br>      aggregation_interval = optional(string)<br>      flow_sampling        = optional(number)<br>      metadata             = optional(string)<br>      metadata_fields      = optional(set(string))<br>      filter_expr          = optional(string) # https://cloud.google.com/vpc/docs/flow-logs#filtering<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_vpc_description"></a> [vpc\_description](#input\_vpc\_description) | A description of the VPC. | `string` | `null` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | The name of the VPC. | `string` | n/a | yes |
| <a name="input_vpc_service_projects"></a> [vpc\_service\_projects](#input\_vpc\_service\_projects) | A list of service projects to attach the Shared VPC. | `set(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_bindings"></a> [iam\_bindings](#output\_iam\_bindings) | IAM bindings for the subnetworks |
| <a name="output_network_id"></a> [network\_id](#output\_network\_id) | The ID of the VPC |
| <a name="output_subnets_ips"></a> [subnets\_ips](#output\_subnets\_ips) | The IPs and CIDRs of the subnets |
| <a name="output_subnets_secondary_ranges"></a> [subnets\_secondary\_ranges](#output\_subnets\_secondary\_ranges) | The secondary ranges of each subnet |
| <a name="output_subnetwork_self_links"></a> [subnetwork\_self\_links](#output\_subnetwork\_self\_links) | The self links of all subnetworks. |
| <a name="output_vpc_name"></a> [vpc\_name](#output\_vpc\_name) | The name of the VPC. |
| <a name="output_vpc_self_link"></a> [vpc\_self\_link](#output\_vpc\_self\_link) | The VPC self link. |
