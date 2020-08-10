locals {
  Rules = {
    Properties = ["name", "priority", "direction", "access", "protocol", "source_port_ranges", "destination_port_range", "source_address_prefix", "destination_address_prefix"]
    NSGIngress = [
      # {"Name", "Priority", "Direction", "Action", "Protocol", "source_port_range", "destination_port_range", "source_address_prefix", "destination_address_prefix" },
      ["AllowAzureLoadBalancerInBound", "4095", "Inbound", "Allow", "*", "*", "*", "AzureLoadBalancer", "*"],
      ["AllowVnetIBound", "4096", "Inbound", "Deny", "*", "*", "*", "*", "*"]
    ],
    NSGEgress = [
      ["DenyVnetOutBound", "4096", "Outbound", "Deny", "*", "*", "*", "*", "*"],
    ]
  }
  Merge = concat(local.Rules.NSGIngress, local.Rules.NSGEgress)
}

/*
resource "azurerm_network_security_group" "coreInfra" {

  for_each = { for name, v in var.vSubnetsSettings : name => v if lookup(v, "RequiredSecurityGroup", true) }

  name                = "${var.ServiceId}-${var.EnvironmentInstanceId}-core-nsg-${lower(each.value.Name)}"
  resource_group_name = "${var.ServiceId}-${var.EnvironmentInstanceId}-core-${var.InstanceId}"
  location            = var.Region
  depends_on          = [var.DependsOn]

  dynamic "security_rule" {
    for_each = concat(lookup(each.value, "NSGIngress", []), lookup(each.value, "NSGEgress", []), local.Merge)
      name                       = security_rule.value[0]
      priority                   = security_rule.value[1]
      direction                  = security_rule.value[2]
      access                     = security_rule.value[3]
      protocol                   = security_rule.value[4]
      source_port_ranges         = security_rule.value[5] 
      destination_port_ranges    = security_rule.value[6]
      source_address_prefix      = security_rule.value[7]
      destination_address_prefix = security_rule.value[8]

    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_ranges         = split(",", replace(security_rule.value.source_port_ranges, "*", "0-65535"))
      destination_port_ranges    = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}
*/


resource "azurerm_network_security_group" "coreInfra" {

  for_each = { for name, v in var.vSubnetsSettings : name => v if lookup(v, "RequiredSecurityGroup", true) }

  name                = "${var.ServiceId}-${var.EnvironmentInstanceId}-core-nsg-${lower(each.value.Name)}"
  resource_group_name = "${var.ServiceId}-${var.EnvironmentInstanceId}-core-${var.InstanceId}"
  location            = var.Region
  depends_on          = [var.DependsOn]

  dynamic "security_rule" {

    for_each = concat(lookup(each.value, "NSGIngress", []), lookup(each.value, "NSGEgress", []), local.Merge)
    content {
      name                           = security_rule.value[0]
      priority                       = security_rule.value[1]
      direction                      = security_rule.value[2]
      access                         = security_rule.value[3]
      protocol                       = security_rule.value[4]
      source_port_range              = length(try(security_rule.value[5][0.2], [""])) > length(try(tolist(security_rule.value[5]), [""])) == true ? null : security_rule.value[5]
      source_port_ranges             = length(try(security_rule.value[5][0.2], [])) > length(try(tolist(security_rule.value[5]), [])) == true ? tolist(security_rule.value[5]) : null
      destination_port_range         = security_rule.value[6]
      source_address_prefix          = security_rule.value[7] 
      destination_address_prefix     = security_rule.value[8]

    }
  }
}
