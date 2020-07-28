resource "azurerm_route_table" "coreInfra" {
  for_each = { for name, v in var.vSubnetsSettings : name => v.Name if v.RequiredInernetAccess == true || v.RequiredNetworkAccess == true }

  name                          = "${var.ServiceId}-${var.EnvironmentInstanceId}-core-rt-${lower(each.value)}"
  resource_group_name           = "${var.ServiceId}-${var.EnvironmentInstanceId}-core-${var.InstanceId}"
  location                      = var.Region
  disable_bgp_route_propagation = true
  depends_on                    = [var.DependsOn]

  tags = {
    environment = "Production"
  }
}

resource "azurerm_route" "Route-RFC-01" {
  for_each = { for name, v in var.vSubnetsSettings : name => v.Name if v.RequiredNetworkAccess == true}

  name                = "Default-RFC-10-0-0-0-8"
  resource_group_name = "${var.ServiceId}-${var.EnvironmentInstanceId}-core-${var.InstanceId}"
  route_table_name    = "${var.ServiceId}-${var.EnvironmentInstanceId}-core-rt-${lower(each.value)}"
  address_prefix      = "10.0.0.0/8"
  next_hop_type       = "vnetlocal"
  depends_on          = [azurerm_route_table.coreInfra]
}

resource "azurerm_route" "Route-RFC-02" {
  for_each = { for name, v in var.vSubnetsSettings : name => v.Name if v.RequiredNetworkAccess == true}

  name                = "Default-RFC-172-16-0-0-12"
  resource_group_name = "${var.ServiceId}-${var.EnvironmentInstanceId}-core-${var.InstanceId}"
  route_table_name    = "${var.ServiceId}-${var.EnvironmentInstanceId}-core-rt-${lower(each.value)}"
  address_prefix      = "172.16.0.0/12"
  next_hop_type       = "vnetlocal"
  depends_on          = [azurerm_route_table.coreInfra]
}

resource "azurerm_route" "Route-RFC-03" {
  for_each = { for name, v in var.vSubnetsSettings : name => v.Name if v.RequiredNetworkAccess == true}

  name                = "Default-RFC-192-168-0-0-16"
  resource_group_name = "${var.ServiceId}-${var.EnvironmentInstanceId}-core-${var.InstanceId}"
  route_table_name    = "${var.ServiceId}-${var.EnvironmentInstanceId}-core-rt-${lower(each.value)}"
  address_prefix      = "192.168.0.0/16"
  next_hop_type       = "vnetlocal"
  depends_on          = [azurerm_route_table.coreInfra]
}

resource "azurerm_route" "Route-RFC-04" {
  for_each = { for name, v in var.vSubnetsSettings : name => v.Name if v.RequiredInernetAccess == true}

  name                = "Default-Internet"
  resource_group_name = "${var.ServiceId}-${var.EnvironmentInstanceId}-core-${var.InstanceId}"
  route_table_name    = "${var.ServiceId}-${var.EnvironmentInstanceId}-core-rt-${lower(each.value)}"
  address_prefix      = "0.0.0.0/0"
  next_hop_type       = "Internet"
  depends_on          = [azurerm_route_table.coreInfra]
}





