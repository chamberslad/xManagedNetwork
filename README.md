<p align="center">
    <img alt="MsHowto" src="https://www.c-sharpcorner.com/UploadFile/BlogImages/07222020005203AM/tf-azure.JPG" width="250" />
  </a>
</p>
<h1 align="center">
  Managed Virtual Network Module of Common Platform Services within Terraform ⛵
</h1>

<h3 align="center">
  ⚛️ 📄 🚀
</h3>
<h3 align="center">
  This document will be covering combination of using Managed Network resources like RouteTable(s), NSG(s), Peering(s), Flow(s), Monitorings within the Terrraform
</h3>

- [What’s In This Document 🔰](#whats-in-this-document-)
- [Inputs of Managed Network](#inputs-of-managed-network)
- [Parameters of Managed Network](#parameters-of-managed-network)
  - [ServiceId](#serviceid)
  - [EnvironmentInstanceId](#environmentinstanceid)
  - [InstanceId](#instanceid)
  - [Region](#region)
  - [Tags](#tags)
  - [vNetworkSettings](#vnetworksettings)
  - [vSubnetsSettings](#vsubnetssettings)
 
## What’s In This Document 🔰
This document is intended  to explain custom Terraform Module for using Managed Network purpose. It will deploy fully configured and ready to use compliance virtual network for any purpose of using it. 

You can create a virtual network with this module. Also you can manage these resources;

☑️  Ability to control and managing DNS Settings on the Virtual Network <br>
☑️  Ability to control and managing creating Subnet(s) on the Virtual Network <br>
☑️ Ability to control creating NSG(s) per subnet-level on the Virtual Network <br>
☑️ Ability to control creating Routes in UDR(s) for aligning Transit Network Service and Internet Access Service <br>
☑️  Ability to control and configuring DDoS protection attachment on the Virtual Network <br>
☑️  Ability to control and configuring Network Flow Log(s) and Traffic Analytics on the Network Resources <br>
🚩  Ability to control and configuring Diagnostics Logging Profile for Managed Network Resources to Storage Account <br>
🚩  Ability to control and configuring Diagnostics Logging Profile for Managed Network Resources to Event Hub <br>
🚩  Ability to control and configuring Diagnostics Logging Profile for Managed Network Resources to Log Analytics <br>

Reference the module to a specific version (recommended):
```hcl

module "xManagedNetwork" {
  source = "github.com/hasangural/xManagedNetwork"
  #version = "0.0.1"
  SubscriptionId       = var.SubscriptionId
  TenantId             = var.TenantId
  ClientId             = var.ClientId
  SecretKey            = var.SecretKey

  ServiceId             = var.ServiceId
  EnvironmentInstanceId = var.EnvironmentInstanceId
  InstanceId            = var.InstanceId

  Region               = var.Region
  vNetworkSettings     = var.vNetworkSettings
  vSubnetsSettings     = var.vSubnetsSettings
  MonitoringSettings   = var.MonitoringSettings
}
```

## Inputs of Managed Network 

| Name                  | Type   | Default | Description                                                                                        |
| --------------------- | ------ | ------- | -------------------------------------------------------------------------------------------------- |
| ServiceId             | string | None    | (Required) This parameters is referred to as the resource prefix and describes service names.      |
| EnvironmentInstanceId | string | None    | (Required) This parameters is referred to as the environment Id which includes Env and InstanceId. |
| InstanceId            | string | None    | (Optional) This parameters is referred to as the ResourceInstanceId.                               |
| Region                | string | None    | (Required) This parameters is referred to Resource Location.                                       |
| Tags                  | object | None    | (Required) This parameters is referred to Resource Tags.                                           |
| vNetworkSettings      | object | None    | (Required) This parameters is referred to properties of Virtual Network.                           |
| vSubnetSettings       | object | None    | (Required) This parameters is referred to properties of Subnet(s) on the Virtual Network.          |
| MonitoringSettings    | object | None    | (Required) This parameters is referred to properties of Monitoring Configuration.                  |

|        |                                                                                            |
| ------ | ------------------------------------------------------------------------------------------ |
| `NOTE` | You can follow your own entire range of `IP Addresses`. All of this completely an example. | # managed-network |


## Parameters of Managed Network 

### ServiceId
This parameters is referred to as the resource prefix and describes service names.

```hcl
variable "ServiceId" {
 description = "This parameters is referred to as the resource prefix and describes service names."
}
```

Example

```hcl
ServiceId = "xs101"
```
### EnvironmentInstanceId
(Optional) This parameters is referred to as the ResourceInstanceId.   

```hcl
variable "ServiceId" {
 description = "(Optional) This parameters is referred to as the ResourceInstanceId."
}
```

Example

```hcl
InstanceId = "01"
```
### InstanceId
This parameters is referred to as the environment Id which includes Env and InstanceId.

```hcl
variable "ServiceId" {
 description = "This parameters is referred to as the environment Id which includes Env and InstanceId."
}
```

Example

```hcl
EnvironmentInstanceId = "d01"
```
### Region
(Required) This parameters is referred to Resource Tags.

```hcl
variable "ServiceId" {
 description = "(Required) This parameters is referred to Resource Tags.."
}
```

Example

```hcl
Region = "West Europe"
```
### Tags
(Required) This parameters is referred to Resource Location.

```hcl
variable "ServiceId" {
 description = "(Required) This parameters is referred to Resource Location."
}
```

Example

```hcl
Tags = {
  account      = "x101"
  team_project = "TBC"
}
```
### vNetworkSettings
(Required) This parameters is referred to properties of Virtual Network. 

```hcl
variable "vNetworkSettings" {
 description = "(Required) This parameters is referred to properties of Virtual Network."
}
```

Example

```hcl
vNetworkSettings = {
  vNetRange = ["10.10.20.0/24"] #[You can add multiple Ranges##]#
  vDNSSettings = {
    RequiredDNS = false
    vDNSServers = ["10.0.0.20", "10.10.20.30"] #[You can add multiple DNS Server for your requirments or you might disable it]#
  }
  vNetPeeringSettings = {
    RequiredInternetAccess = false
    RequiredNetworkAccess  = false
  }
  RequiredBastionHost = true
}
```

### vSubnetsSettings
(Required) This parameters is referred to properties of Virtual Network. 

```hcl
variable "vNetworkSettings" {
 description = "(Required) This parameters is referred to properties of Virtual Network."
}
```

Example

```hcl

vSubnetsSettings = {
  "Subnet01" = {
    Name                              = "BackendSubnet01"
    Range                             = "10.10.20.0/28"
    RequiredInernetAccess             = true
    RequiredNetworkAccess             = true
    RequiredSecurityGroup             = true
    ServiceEndpoints                  = [] #[You can add multiple Service Endpoints for spesific Subnets "Microsoft.EventHub"]#
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
      ["DNS", "102", "Inbound", "Allow", "TCP", "53", "53", "*", "192.168.0.0/24"],
      ["DNS", "102", "Inbound", "Allow", "TCP", "53", "53", "*", "192.168.1.21/32"],
    ]
    NSGEgress = [
      # {"Name", "Priority", "Direction", "Action", "Protocol", "source_port_range(s)", "destination_port_range(s)", "source_address_prefix(s)", "destination_address_prefix(s)" },
      # ["AllowAzureLoadBalancerInBound", "4095", "OutBound", "Allow", "*", "*", "*", "AzureLoadBalancer", "*"]
    ]
  },
  "Subnet02" = {
    Name                  = "AppSubnet01"
    Range                 = "10.10.20.16/28"
    RequiredInernetAccess = true
    RequiredNetworkAccess = true
    RequiredSecurityGroup = true
  },
  "Subnet03" = {
    Name                  = "AppSubnet03"
    Range                 = "10.10.20.32/28"
    RequiredInernetAccess = true
    RequiredNetworkAccess = true
    RequiredSecurityGroup = true
  }
}

```