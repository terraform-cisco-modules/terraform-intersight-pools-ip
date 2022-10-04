terraform {
  required_providers {
    intersight = {
      source  = "CiscoDevNet/intersight"
      version = ">=1.0.32"
    }
  }
}

# Setup provider, variables and outputs
provider "intersight" {
  apikey    = var.intersight_keyid
  secretkey = file(var.intersight_secretkeyfile)
  endpoint  = var.intersight_endpoint
}

variable "intersight_keyid" {}
variable "intersight_secretkeyfile" {}
variable "intersight_endpoint" {
  default = "intersight.com"
}
variable "name" {}

output "moid" {
  value = module.main.moid
}

# This is the module under test
module "main" {
  source = "../.."

  assignment_order = "sequential"
  description      = "${var.name} IP Pool."
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

  name         = var.name
  organization = "default"
}

