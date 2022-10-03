<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/terraform-cisco-modules/terraform-intersight-pools-ip/actions/workflows/terratest.yml/badge.svg)](https://github.com/terraform-cisco-modules/terraform-intersight-pools-ip/actions/workflows/terratest.yml)
# Terraform Intersight Pools - IP

Manages Intersight IP Pools

Location in GUI:
`Pools` » `Create Pool` » `IP`

A comprehensive example using this module is available here:
GitHub: [*Easy IMM - Comprehensive Example*](https://github.com/terraform-cisco-modules/easy-imm-comprehensive-example)

## Example

### main.tf
```hcl
module "ip_pool" {
  source  = "terraform-cisco-modules/pools-ip/intersight"
  version = ">= 1.0.2"

  assignment_order = "sequential"
  description      = "default IP Pool"
  ipv4_blocks = [
    {
      from = "198.18.0.10"
      size = 240
    }
  ]
  ipv4_config = [
    {
      gateway       = "198.18.0.1"
      netmask       = "255.255.255.0"
      primary_dns   = "208.67.220.220"
      secondary_dns = "208.67.222.222"
    }
  ]
  ipv6_blocks = [
    {
      from = "2001:db8::10"
      size = 1000
    }
  ]
  ipv6_config = [
    {
      gateway       = "2001:db8::1"
      prefix        = 64
      primary_dns   = "2620:119:53::53"
      secondary_dns = "2620:119:35::35"
    }
  ]
  name         = "default"
  organization = "default"
}

```

### provider.tf
```hcl
terraform {
  required_providers {
    intersight = {
      source  = "CiscoDevNet/intersight"
      version = ">=1.0.32"
    }
  }
  required_version = ">=1.3.0"
}

provider "intersight" {
  apikey    = var.apikey
  endpoint  = var.endpoint
  secretkey = var.secretkey
}
```

### variables.tf
```hcl
variable "apikey" {
  description = "Intersight API Key."
  sensitive   = true
  type        = string
}

variable "endpoint" {
  default     = "https://intersight.com"
  description = "Intersight URL."
  type        = string
}

variable "secretkey" {
  description = "Intersight Secret Key."
  sensitive   = true
  type        = string
}
```

## Environment Variables

### Terraform Cloud/Enterprise - Workspace Variables
- Add variable apikey with value of [your-api-key]
- Add variable secretkey with value of [your-secret-file-content]

### Linux
```bash
export TF_VAR_apikey="<your-api-key>"
export TF_VAR_secretkey=`cat <secret-key-file-location>`
```

### Windows
```bash
$env:TF_VAR_apikey="<your-api-key>"
$env:TF_VAR_secretkey="<secret-key-file-location>"
```


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3.0 |
| <a name="requirement_intersight"></a> [intersight](#requirement\_intersight) | >=1.0.32 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_intersight"></a> [intersight](#provider\_intersight) | 1.0.32 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apikey"></a> [apikey](#input\_apikey) | Intersight API Key. | `string` | n/a | yes |
| <a name="input_endpoint"></a> [endpoint](#input\_endpoint) | Intersight URL. | `string` | `"https://intersight.com"` | no |
| <a name="input_secretkey"></a> [secretkey](#input\_secretkey) | Intersight Secret Key. | `string` | n/a | yes |
| <a name="input_assignment_order"></a> [assignment\_order](#input\_assignment\_order) | Assignment order decides the order in which the next identifier is allocated.<br>  * sequential - Identifiers are assigned in a sequential order.<br>  * default - Assignment order is decided by the system. | `string` | `"default"` | no |
| <a name="input_description"></a> [description](#input\_description) | Description for the IP Pool. | `string` | `""` | no |
| <a name="input_ipv4_blocks"></a> [ipv4\_blocks](#input\_ipv4\_blocks) | List of IPv4 Address Parameters to Assign to the IP Pool.<br>  * from - Starting IPv4 Address.  Example "198.18.0.10".<br>  * size - Size of the IPv4 Address Pool.  Example "240".<br>  * to - Ending IPv4 Address.  Example "198.18.0.250"<br>  * IMPORTANT NOTE: You can only Specify `size` or `to` on initial creation.  This is a limitation of the API. | <pre>list(object(<br>    {<br>      from = string<br>      size = optional(number, null)<br>      to   = optional(string, null)<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_ipv4_config"></a> [ipv4\_config](#input\_ipv4\_config) | List of IPv4 Addresses to Assign to the IP Pool.<br>  * gateway - Gateway of the Subnet.  Example "198.18.0.1".<br>  * netmask - Netmask of the Subnet in X.X.X.X format.  Example "255.255.255.0".<br>  * primary\_dns = Primary DNS Server to Assign to the Pool.  Example "208.67.220.220".<br>  * secondary\_dns = Secondary DNS Server to Assign to the Pool.  Example "208.67.222.222". | <pre>list(object(<br>    {<br>      gateway       = string<br>      netmask       = string<br>      primary_dns   = optional(string, "208.67.220.220")<br>      secondary_dns = optional(string, "")<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_ipv6_blocks"></a> [ipv6\_blocks](#input\_ipv6\_blocks) | List of IPv6 Addresses to Assign to the IP Pool.<br>  * from - Starting IPv6 Address.  Example "2001:db8::10".<br>  * size - Size of the IPv6 Address Pool.  Example "1000".<br>  * to - Ending IPv6 Address.  Example "2001:db8::3f2".<br>  * IMPORTANT NOTE: You can only Specify `size` or `to` on initial creation.  This is a limitation of the API. | <pre>list(object(<br>    {<br>      from = string<br>      size = optional(number, null)<br>      to   = optional(string, null)<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_ipv6_config"></a> [ipv6\_config](#input\_ipv6\_config) | List of IPv6 Configuration Parameters to Assign to the IP Pool.<br>  * gateway - Gateway of the Subnet.  Example "2001:db8::1".<br>  * prefix - Prefix of the Subnet in Integer format.  Example "64".<br>  * primary\_dns = Primary DNS Server to Assign to the Pool.  Example "2620:119:35::35".<br>  * secondary\_dns = Secondary DNS Server to Assign to the Pool.  Example "2620:119:53::53". | <pre>list(object(<br>    {<br>      gateway       = string<br>      prefix        = number<br>      primary_dns   = optional(string, "2620:119:53::53")<br>      secondary_dns = optional(string, "::")<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for the IP Pool. | `string` | `"default"` | no |
| <a name="input_organization"></a> [organization](#input\_organization) | Intersight Organization Name to Apply Policy to.  https://intersight.com/an/settings/organizations/. | `string` | `"default"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of Tag Attributes to Assign to the Policy. | `list(map(string))` | `[]` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_moid"></a> [moid](#output\_moid) | IP Pool Managed Object ID (moid). |
## Resources

| Name | Type |
|------|------|
| [intersight_ippool_pool.ip](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/ippool_pool) | resource |
| [intersight_organization_organization.org_moid](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/organization_organization) | data source |
<!-- END_TF_DOCS -->