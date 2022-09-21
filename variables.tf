terraform {
  experiments = [module_variable_optional_attrs]
}

#____________________________________________________________
#
# IP Pool Variables Section.
#____________________________________________________________

variable "assignment_order" {
  default     = "default"
  description = <<-EOT
  Assignment order decides the order in which the next identifier is allocated.
    * sequential - Identifiers are assigned in a sequential order.
    * default - Assignment order is decided by the system.
  EOT
  type        = string
}

variable "description" {
  default     = ""
  description = "Description for the IP Pool."
  type        = string
}

variable "ipv4_blocks" {
  default     = []
  description = <<-EOT
  List of IPv4 Address Parameters to Assign to the IP Pool.
    * from - Starting IPv4 Address.  Example "198.18.0.10".
    * size - Size of the IPv4 Address Pool.  Example "240".
    * to - Ending IPv4 Address.  Example "198.18.0.250"
    * IMPORTANT NOTE: You can only Specify `size` or `to` on initial creation.  This is a limitation of the API.
  EOT
  type = list(object(
    {
      from = string
      size = optional(number)
      to   = optional(string)
    }
  ))
}

variable "ipv4_config" {
  default     = []
  description = <<-EOT
  List of IPv4 Addresses to Assign to the IP Pool.
    * gateway - Gateway of the Subnet.  Example "198.18.0.1".
    * netmask - Netmask of the Subnet in X.X.X.X format.  Example "255.255.255.0".
    * primary_dns = Primary DNS Server to Assign to the Pool.  Example "208.67.220.220".
    * secondary_dns = Secondary DNS Server to Assign to the Pool.  Example "208.67.222.222".
  EOT
  type = list(object(
    {
      gateway       = string
      netmask       = string
      primary_dns   = optional(string)
      secondary_dns = optional(string)
    }
  ))
}

variable "ipv6_blocks" {
  default     = []
  description = <<-EOT
  List of IPv6 Addresses to Assign to the IP Pool.
    * from - Starting IPv6 Address.  Example "2001:db8::10".
    * size - Size of the IPv6 Address Pool.  Example "1000".
    * to - Ending IPv6 Address.  Example "2001:db8::3f2".
    * IMPORTANT NOTE: You can only Specify `size` or `to` on initial creation.  This is a limitation of the API.
  EOT
  type = list(object(
    {
      from = string
      size = optional(number)
      to   = optional(string)
    }
  ))
}

variable "ipv6_config" {
  default     = []
  description = <<-EOT
  List of IPv6 Configuration Parameters to Assign to the IP Pool.
    * gateway - Gateway of the Subnet.  Example "2001:db8::1".
    * prefix - Prefix of the Subnet in Integer format.  Example "64".
    * primary_dns = Primary DNS Server to Assign to the Pool.  Example "2620:119:35::35".
    * secondary_dns = Secondary DNS Server to Assign to the Pool.  Example "2620:119:53::53".
  EOT
  type = list(object(
    {
      gateway       = string
      prefix        = number
      primary_dns   = optional(string)
      secondary_dns = optional(string)
    }
  ))
}

variable "name" {
  default     = "default"
  description = "Name for the IP Pool."
  type        = string
}

variable "organization" {
  default     = "default"
  description = "Intersight Organization Name to Apply Policy to.  https://intersight.com/an/settings/organizations/."
  type        = string
}

variable "tags" {
  default     = []
  description = "List of Tag Attributes to Assign to the Policy."
  type        = list(map(string))
}
