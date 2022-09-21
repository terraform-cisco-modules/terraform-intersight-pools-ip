module "ip_pool" {
  source  = "scotttyso/pools-ip/intersight"
  version = ">= 1.0.1"

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
      primary_dns   = "208.67.200.200"
      secondary_dns = "208.67.220.220"
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
      primary_dns   = "2620:119:35::35"
      secondary_dns = "2620:119:53::53"
    }
  ]
  name         = "default"
  organization = "default"
}

