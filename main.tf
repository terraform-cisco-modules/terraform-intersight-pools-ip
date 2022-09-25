#____________________________________________________________
#
# Intersight Organization Data Source
# GUI Location: Settings > Settings > Organizations > {Name}
#____________________________________________________________

data "intersight_organization_organization" "org_moid" {
  for_each = {
    for v in [var.organization] : v => v if length(
      regexall("[[:xdigit:]]{24}", var.organization)
    ) == 0
  }
  name = each.value
}

#____________________________________________________________
#
# Intersight IP Pool Resource
# GUI Location: Pools > Create Pool
#____________________________________________________________

resource "intersight_ippool_pool" "ip" {
  assignment_order = var.assignment_order
  description      = var.description != "" ? var.description : "${var.name} IP Pool."
  name             = var.name
  dynamic "ip_v4_blocks" {
    for_each = { for v in var.ipv4_blocks : v.from => v }
    content {
      from = ip_v4_blocks.value.from
      size = ip_v4_blocks.value.size
      to   = ip_v4_blocks.value.to
    }
  }
  dynamic "ip_v4_config" {
    for_each = var.ipv4_config
    content {
      gateway       = ip_v4_config.value.gateway
      netmask       = ip_v4_config.value.netmask
      primary_dns   = ip_v4_config.value.primary_dns
      secondary_dns = ip_v4_config.value.secondary_dns
    }
  }
  dynamic "ip_v6_blocks" {
    for_each = { for v in var.ipv6_blocks : v.from => v }
    content {
      from = ip_v6_blocks.value.from
      size = ip_v6_blocks.value.size
      to   = ip_v6_blocks.value.to
    }
  }
  dynamic "ip_v6_config" {
    for_each = var.ipv6_config
    content {
      gateway       = ip_v6_config.value.gateway
      prefix        = ip_v6_config.value.prefix
      primary_dns   = ip_v6_config.value.primary_dns
      secondary_dns = ip_v6_config.value.secondary_dns
    }
  }
  organization {
    moid = length(
      regexall("[[:xdigit:]]{24}", var.organization)
      ) > 0 ? var.organization : data.intersight_organization_organization.org_moid[
      var.organization].results[0
    ].moid
    object_type = "organization.Organization"
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
