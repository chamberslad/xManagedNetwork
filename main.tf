terraform {
  required_version = ">= 0.12.0"
}

####> Provider for AzureRM <####
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version         = "~> 2.15.0"
  subscription_id = var.SubscriptionId
  client_id       = var.ClientId
  client_secret   = var.SecretKey
  tenant_id       = var.TenantId
  features {}
}

module "xNetwork" {
  source = "./modules/xNetwork"
  #version = "0.0.1"
  ServiceId             = var.ServiceId
  EnvironmentInstanceId = var.EnvironmentInstanceId
  InstanceId            = var.InstanceId

  Region           = var.Region
  vNetworkSettings = var.vNetworkSettings
  vSubnetsSettings = var.vSubnetsSettings
}

module "xRouteTable" {
  source = "./modules/xRouteTable"
  #version = "0.0.1"
  ServiceId             = var.ServiceId
  EnvironmentInstanceId = var.EnvironmentInstanceId
  InstanceId            = var.InstanceId

  Region           = var.Region
  vNetworkSettings = var.vNetworkSettings
  vSubnetsSettings = var.vSubnetsSettings

  DependsOn = module.xNetwork.Subnets
}

module "xSecurityGroup" {
  source = "./modules/xSecurityGroup"
  #version = "0.0.1"
  ServiceId             = var.ServiceId
  EnvironmentInstanceId = var.EnvironmentInstanceId
  InstanceId            = var.InstanceId

  Region           = var.Region
  vNetworkSettings = var.vNetworkSettings
  vSubnetsSettings = var.vSubnetsSettings

  DependsOn = module.xNetwork.Subnets
}

module "xBastion" {
  source = "./modules/xBastion"
  #version = "0.0.1"
  ServiceId             = var.ServiceId
  EnvironmentInstanceId = var.EnvironmentInstanceId
  InstanceId            = var.InstanceId

  Region           = var.Region
  vNetworkSettings = var.vNetworkSettings
  vSubnetsSettings = module.xNetwork.Subnets
}

module "xMonitoring" {
  source = "./modules/xMonitoring"
  #version = "0.0.1"
  ServiceId             = var.ServiceId
  EnvironmentInstanceId = var.EnvironmentInstanceId
  InstanceId            = var.InstanceId

  Region                = var.Region
  vNetworkSettings      = var.vNetworkSettings
  vSubnetsSettings      = module.xNetwork.Subnets
  NetworkSecurityGroups = module.xSecurityGroup.NSGs
  ManagedBastionHost    = module.xBastion.BastionHost
  MonitoringSettings    = var.MonitoringSettings
}

resource "azurerm_subnet_network_security_group_association" "NSG_Association" {
  for_each = toset([for k, v in var.vSubnetsSettings : k if lookup(v, "RequiredSecurityGroup", true)])

  subnet_id                 = module.xNetwork.Subnets[each.value].id
  network_security_group_id = module.xSecurityGroup.NSGs[each.value].id
}

resource "azurerm_subnet_route_table_association" "RouteTable_Association" {
  for_each = toset([for k, v in var.vSubnetsSettings : k if lookup(v, "RequiredInternetAccess", true) == true && lookup(v, "RequiredNetworkAccess", true) == true && (var.vNetworkSettings.vNetPeeringSettings.RequiredInternetAccess || var.vNetworkSettings.vNetPeeringSettings.RequiredNetworkAccess)])

  subnet_id      = module.xNetwork.Subnets[each.value].id
  route_table_id = module.xRouteTable.Tables[each.value].id
}
