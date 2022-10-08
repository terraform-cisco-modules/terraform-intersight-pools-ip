<!-- BEGIN_TF_DOCS -->
# IP Pool Example

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
  secretkey = fileexists(var.secretkeyfile) ? file(var.secretkeyfile) : var.secretkey
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
  default     = ""
  description = "Intersight Secret Key Content."
  sensitive   = true
  type        = string
}

variable "secretkeyfile" {
  default     = "blah.txt"
  description = "Intersight Secret Key File Location."
  sensitive   = true
  type        = string
}
```

## Environment Variables

### Terraform Cloud/Enterprise - Workspace Variables
- Add variable apikey with the value of [your-api-key]
- Add variable secretkey with the value of [your-secret-file-content]

### Linux and Windows
```bash
export TF_VAR_apikey="<your-api-key>"
export TF_VAR_secretkeyfile="<secret-key-file-location>"
```

To run this example you need to execute:

```bash
terraform init
terraform plan -out="main.plan"
terraform apply "main.plan"
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.
<!-- END_TF_DOCS -->