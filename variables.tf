variable "SubscriptionId" {
  description = "Please Provide your subscriptionId"
  default     = "a25a223b-bbbd-4fbd-bb75-4fda84986cd5"
}
variable "TenantId" {
  description = "Please Provide your tenantId"
  default     = "2596de33-c183-49cc-966f-069cfce79321"
}
variable "ClientId" {
  description = "Please Provide your clientId"
  default     = "d03e4b85-3d4e-4d20-a286-5d2dc9313749"
}
variable "SecretKey" {
  description = "Please Provide your secretKey"
  default     = "rAyF6KD_~_ur5KU8.K_o6G8qHr_q-kmk3v"
}
variable "ServiceId" {
  description = "This parameters is referred to as the resource prefix and describes service names. Example: Platform(P) - Business(B)"
  default     = "lp101"
}
variable "EnvironmentInstanceId" {
  description = "This parameters is referred to as the resource prefix and describes service names. Example: Platform(P) - Business(B)This parameters is referred to as the resource EnvironmentInstanceId which includes Env and InstanceId. Example: p01, t01"
  default     = "d01"
}
variable "InstanceId" {
  description = "This parameters is referred to as the resource prefix and describes service names. Example: Platform(P) - Business(B)This parameters is referred to as the resource EnvironmentInstanceId which includes Env and InstanceId. Example: p01, t01"
  default     = "01"
}
variable "Region" {
  description = "This parameters is referred to Resource Location"
  default     = "WestEurope"
}
variable "Tags" {
  description = "This parameters is referred to Resource Location"
  default = {
    "Environment" = "dev"
    "CostCenter " = "12838201"
  }
}
variable "vNetworkSettings" {
  default = {
    vNetRange = ["10.10.20.0/24"] #[You can add multiple Ranges##]#
    vDNSSettings = {
      RequiredDNS = false
      vDNSServers = ["10.0.0.20", "10.10.20.30"] #[You can add multiple DNS Server for your requirments or you might disable it]#
    }
    vNetPeeringSettings = {
      RequiredInternetAccess = true
      RequiredNetworkAccess  = false
    }
    RequiredBastionHost = false
  }
}
variable "vSubnetsSettings" {
  default = {
    "Subnet01" = {
      Name                              = "BackendSubnet01"
      Range                             = "10.10.20.0/28"
      ServiceEndpoints                  = ["All"] #[You can add multiple Service Endpoints for spesific Subnets "Microsoft.EventHub"]#
      EnforcePrivateLinkEdpointPolicies = false
      EnforcePrivateLinkServicePolicies = false
      Delegation = {
        Name = "AccessDelegation01"
        ServiceDelegation = {
          Name    = "Microsoft.ContainerInstance/containerGroups"
          Actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
        }
      }
      NSGIngress = [
        # {"Name", "Priority", "Direction", "Action", "Protocol", "source_port_range(s)", "destination_port_range(s)", "source_address_prefix(s)", "destination_address_prefix(s)" },
        ["DNS", "102", "Inbound", "Allow", "TCP", "53", "53", "*", "*"],
      ]
      NSGEgress = [
        # {"Name", "Priority", "Direction", "Action", "Protocol", "source_port_range(s)", "destination_port_range(s)", "source_address_prefix(s)", "destination_address_prefix(s)" },
        # ["AllowAzureLoadBalancerInBound", "4095", "OutBound", "Allow", "*", "*", "*", "AzureLoadBalancer", "*"]
      ]
    },
    "Subnet02" = {
      Name  = "AppSubnet01"
      Range = "10.10.20.16/28"
      #RequiredInternetAccess = false
      #RequiredNetworkAccess  = false
      #RequiredSecurityGroup  = false
    },
    "Subnet03" = {
      Name  = "AppSubnet03"
      Range = "10.10.20.32/28"
    }
  }
}
variable "MonitoringSettings" {
  default = {
    DiagnosticSettings = {
      StorageAccountLog = true
      LogAnalyticsSpace = false
    }
    NetworkFlowSettings = {
      Retention = true
      Period    = 14
    }
    TrafficAnalyticsSettings = {
      Enabled = true
    }
  }
}
