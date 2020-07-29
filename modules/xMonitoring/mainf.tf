locals {
  account_replication_type = "LRS"
}

####> Creating Storage Account for extracting logs for Managed Network Resource <####

resource "azurerm_storage_account" "diag_storage" {
  count                     = var.MonitoringSettings.DiagnosticSettings.StorageAccountLog ? 1 : 0
  name                      = "${lower(replace("${var.ServiceId}-${var.EnvironmentInstanceId}-core-vn", "-", ""))}diagstor"
  resource_group_name       = "${var.ServiceId}-${var.EnvironmentInstanceId}-core-${var.InstanceId}"
  location                  = var.Region
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = local.account_replication_type
  enable_https_traffic_only = true

  network_rules {
    default_action = "Deny"
    # This is used for diagnostics only
    bypass = [
      # TODO: Instead of AzureServices use Service Endpoints
      #       https://docs.microsoft.com/en-us/azure/network-watcher/frequently-asked-questions#nsg-flow-logs
      "AzureServices",
      "Logging",
      "Metrics"
    ]
  }

  tags = var.Tags

  depends_on = [var.vSubnetsSettings]

}

####> Enabling Storage Account Threat Protection for Managed Network Resource <####

resource "azurerm_advanced_threat_protection" "diag_storage" {
  count              = var.MonitoringSettings.DiagnosticSettings.StorageAccountLog ? 1 : 0
  target_resource_id = azurerm_storage_account.diag_storage[0].id
  enabled            = true
}

####> Enabling NSG Logs for Managed Network Resource <####

resource "azurerm_monitor_diagnostic_setting" "nsg_logs" {
  for_each = var.MonitoringSettings.DiagnosticSettings.StorageAccountLog == true || var.MonitoringSettings.DiagnosticSettings.LogAnalyticsSpace == true ? var.NetworkSecurityGroups : {}

  name               = each.value.name
  target_resource_id = each.value.id
  #eventhub_name                  = lookup(var.diagnostics_map, "eh_name", null)
  #eventhub_authorization_rule_id = lookup(var.diagnostics_map, "eh_id", null) != null ? "${var.diagnostics_map.eh_id}/authorizationrules/RootManageSharedAccessKey" : null
  #log_analytics_workspace_id     = "12321321" if var.MonitoringSettings.DiagnosticSettings.StorageAccountLog == true ? "123131312" : null
  storage_account_id = var.MonitoringSettings.DiagnosticSettings.StorageAccountLog ? azurerm_storage_account.diag_storage[0].id : null
  log {

    category = "NetworkSecurityGroupRuleCounter"
    retention_policy {
      days    = 90
      enabled = true

    }
  }
  log {

    category = "NetworkSecurityGroupEvent"
    retention_policy {
      days    = 90
      enabled = true

    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "bastion_logs" {
  count = var.MonitoringSettings.DiagnosticSettings.StorageAccountLog && var.vNetworkSettings.RequiredBastionHost ? 1 : 0

  name               = "${var.ServiceId}-${var.EnvironmentInstanceId}-mgmt-bst-${var.InstanceId}"
  target_resource_id = var.ManagedBastionHost[0].id
  storage_account_id = azurerm_storage_account.diag_storage[0].id
  #log_analytics_workspace_id = var.diagnostics_workspace_resource_id

  log {
    category = "BastionAuditLogs"
    enabled  = true

    retention_policy {
      days    = 90
      enabled = true

    }
  }
}

# BUG: Resource is not destroyed
resource "azurerm_network_watcher_flow_log" "nsg_logs" {
  for_each = var.MonitoringSettings.DiagnosticSettings.StorageAccountLog == true || var.MonitoringSettings.DiagnosticSettings.LogAnalyticsSpace == true ? var.NetworkSecurityGroups : {}

  network_watcher_name = "NetworkWatcher_westeurope"
  resource_group_name  = "NetworkWatcherRG"

  network_security_group_id = each.value.id
  storage_account_id        = var.MonitoringSettings.DiagnosticSettings.StorageAccountLog ? azurerm_storage_account.diag_storage[0].id : null
  enabled                   = true
  version                   = 2

  retention_policy {
    enabled = true
    days    = var.MonitoringSettings.NetworkFlowSettings.Period
  }

  #
  #traffic_analytics {
  #  enabled                    = true
  #  workspace_id               = var.diagnostics_workspace_workspace_id
  #  workspace_region           = var.workspace_location
  #  workspace_resource_id      = var.diagnostics_workspace_resource_id
  #}

}

