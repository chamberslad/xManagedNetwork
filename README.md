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
- [Inputs of Managed Virtual Network](#inputs-of-managed-virtual-network)
- [Parameters of Managed Virtual Network](#parameters-of-managed-virtual-network)
  - [ServiceId](#serviceid)
  - [EnvironmentInstanceId](#environmentinstanceid)
 
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
  source = "github.com/hasangural/managed-network"
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

## Inputs of Managed Virtual Network 

| Name                  | Type   | Default | Description                                                                                        |
| --------------------- | ------ | ------- | -------------------------------------------------------------------------------------------------- |
| ServiceId             | string | None    | (Required) This parameters is referred to as the resource prefix and describes service names.      |
| EnvironmentInstanceId | string | None    | (Required) This parameters is referred to as the environment Id which includes Env and InstanceId. |
| InstanceId            | string | None    | (Optional) This parameters is referred to as the ResourceInstanceId.                               |
| Region                | string | None    | (Required) This parameters is referred to Resource Location.                                       |
| Tags                  | object | None    | (Required) This parameters is referred to Resource Tags.                                           |
| vNetworkSettings      | object | None    | (Required) This parameters is referred to properties of Virtual Network.                           |
| vNetworkSettings      | object | None    | (Required) This parameters is referred to properties of Subnet(s) on the Virtual Network.          |
| MonitoringSettings    | object | None    | (Required) This parameters is referred to properties of Monitoring Configuration.                  |

|        |                                                                                            |
| ------ | ------------------------------------------------------------------------------------------ |
| `NOTE` | You can follow your own entire range of `IP Addresses`. All of this completely an example. | # managed-network |


## Parameters of Managed Virtual Network 

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