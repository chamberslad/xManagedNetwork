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
This document will be covering combination of using Managed Network resources conjunction with Terrraform like Bastion Host, RouteTable(s), NSG(s), Peering(s), Service Endpoint(s), Delegation, Private Endpoint(s), Flow logging for NSG(s), Monitoring Options and so forth.
</h3>

---
- [What’s In This Document 📖](#whats-in-this-document-)
- [Inputs of Managed Network](#inputs-of-managed-network)
- [Parameters of Managed Network 🌪️](#parameters-of-managed-network-️)
  - [ServiceId](#serviceid)
  - [EnvironmentInstanceId](#environmentinstanceid)
  - [InstanceId](#instanceid)
  - [Region](#region)
  - [Tags](#tags)
  - [vNetworkSettings](#vnetworksettings)
  - [vSubnetsSettings](#vsubnetssettings)
  - [MonitoringSettings](#monitoringsettings)
- [Get up and running in a minute 🚀](#get-up-and-running-in-a-minute-)
 
--- 
## What’s In This Document 📖
This document is intended  to explain custom Terraform Module for using Managed Network purpose. It will deploy fully configured and ready to use consistent virtual network for any purpose of using it. 

You can create a virtual network with this module. Also you can manage these resources;

☑️  Ability to control and manage DNS Settings on the Virtual Network <br>
☑️  Ability to control and manage creating Subnet(s) on the Virtual Network <br>
☑️  Ability to control creating NSG(s) per subnet-level on the Virtual Network <br>
☑️  Ability to control and Ingress and Egress Rules of NSG per subnet-level on the Virtual Network <br>
☑️  Ability to control creating Routes in UDR(s) for aligning Transit Network Service and Internet Access Service <br>
☑️  Ability to control creating Service Endpoint(s) per subnet-level on the Virtual Network <br>
☑️  Ability to control creating Delegation per subnet-level on the Virtual Network <br>
☑️  Ability to control creating Private Endpoint Policies per subnet-level on the Virtual Network <br>
☑️  Ability to deploy Managed Bastion Host on the Virtual Network <br>
☑️  Ability to control and manage DDoS protection attachment on the Virtual Network <br>
☑️  Ability to control and manage Network Flow Log(s) and Traffic Analytics on the Network Resources <br>
☑️  Ability to control and configure Diagnostics Logging Profile for Managed Network Resources to Storage Account <br>
🚩  Ability to create and configure Peering Settings for Platform Network Services <br>
🚩  Ability to control and configure Diagnostics Logging Profile for Managed Network Resources to Event Hub <br>
🚩  Ability to control and configure Diagnostics Logging Profile for Managed Network Resources to Log Analytics <br>

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
| Region                | string | None    | (Required) Specifies the Azure location to deploy the resource. Changing this forces a new resource to be created.|
| Tags                  | object | None    | (Required) map of tags for the deployment.	                                                        |
| vNetworkSettings      | object | None    | (Required) This parameters is referred to properties of Virtual Network.                           |
| vSubnetSettings       | object | None    | (Required) This parameters is referred to properties of Subnet(s) on the Virtual Network.          |
| MonitoringSettings    | object | None    | (Required) This parameters is referred to properties of Monitoring Configuration.                  |

|        |                                                                                            |
| ------ | ------------------------------------------------------------------------------------------ |
| `NOTE` | You can follow your own entire range of `IP Addresses`. All of this completely an example. |


---


## Parameters of Managed Network 🌪️

### ServiceId
This parameters is referred to as the resource prefix and describes service names.

Example

```hcl
ServiceId = "xs101"
```

### EnvironmentInstanceId
(Optional) This parameters is referred to as the ResourceInstanceId.   

Example

```hcl
EnvironmentInstanceId = "01"
```

### InstanceId
This parameters is referred to as the environment Id which includes Env and InstanceId.

Example

```hcl
InstanceId = "01"
```

### Region
(Required) Specifies the Azure location to deploy the resource. Changing this forces a new resource to be created.	

Example

```hcl
Region = "West Europe"
```

### Tags
(Required) map of tags for the deployment

Example

```hcl
Tags = {
  account      = "x101"
  team_project = "TBC"
}
```

### vNetworkSettings
(Required) Configuration object describing the networking configuration. (see example below)

| input                             | Type   | Optional  | Comment                                                                                                      |
| --------------------------------  | ------ | -------   | ------------------------------------------------------------------------------------------------------------ |
| vNetRange                         | list   | mandatory | Address Prefixes for the subnets                                                                             |
| vDNSSettings                      | object | mandatory | You can provide list of DNS Servers, if you are not provided, uses the default Azure DNS                     |
| vNetPeeringSettings               | object | mandatory | Address prefix for subnet                                                                                    |
| RequiredBastionHost               | bool   | mandatory | You can easily enabling Azure Bastion Service for Managed Network Resources                                  |

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

For each subnet, create an object that contain the following fields (see example below)

| input                             | Type   | Optional  | Comment                                                                                                      |
| --------------------------------  | ------ | -------   | ------------------------------------------------------------------------------------------------------------ |
| Name                              | string | mandatory | Name of the virtual subnet                                                                                   |
| Range                             | string | mandatory | Address prefix for subnet                                                                                    |
| RequiredInternetAccess            | bool   | optional  | Route Table is create depends on your selection on the block of vNetPeering Settings. If subnet does not require to connect Internet Access Service, you can declare value '*false*'|
| RequiredNetworkAccess             | bool   | optional  | If subnet does not require to connect Network Access Service, you can declare value '*false*'                |
| RequiredSecurityGroup             | bool   | optional  | If subnet does not require Network Security Group, you can declare value '*false*'                           |
| ServiceEndpoints                  | list   | optional  | Service endpoints for the subnet. You can set ["All"] or individual ["Microsoft.EventHub","Microsoft.Web"]   |
| EnforcePrivateLinkEdpointPolicies | bool   | None      | Enable or Disable network policies for the private link endpoint on the subnet. Conflicts with '**EnforcePrivateLinkServicePolicies**' |
| EnforcePrivateLinkServicePolicies | bool   | None      | Enable or Disable network policies for the private link service on the subnet. Conflicts with '**EnforcePrivateLinkEdpointPolicies**'  |
| Delegation                        | object | None      | Defines a subnet delegation feature. takes an object as described in the following example.                  |
| NSGIngress                        | list   | None      | NSG is always created for each subnet. List will tune the NSG entries for inbound flows.                     |
| NSGEgress                         | list   | None      | NSG is always created for each subnet. List will tune the NSG entries for outbound flows.                    |


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
  },
  "Subnet03" = {
    Name                  = "AppSubnet03"
    Range                 = "10.10.20.32/28"
  }
}

```

### MonitoringSettings
This parameters is referred to properties of Monitoring Configuration.

```hcl
variable "MonitoringSettings" {
 description = "This parameters is referred to properties of Monitoring Configuration.."
}
```

Example

```hcl

MonitoringSettings = {
    DiagnosticSettings = {
      StorageAccountLog = false
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

```

---

## Get up and running in a minute 🚀 
We need to start by cloning the xManagedNetwork repository. It contains all the terraform files which needed to set up a new managed virtual network.

1. **Clone the xManaged Network Repository - example branch.**

   ```bash
   git clone -b example https://github.com/hasangural/xManagedNetwork.git

   or 

   ```
2. **Initialize Terraform**

   Get your Gatsby blog set up in a single command:

   ```bash
   terraform init
   ```
  <details>
  <summary>Click to expand - see output of script</summary>

  ```bash
  # You should see example of output as below-stated.
    "❯ terraform init"

    "Initializing modules..."
    "- xBastion in modules\xBastion"
    "- xMonitoring in modules\xMonitoring"
    "- xNetwork in modules\xNetwork"
    "- xRouteTable in modules\xRouteTable"
    "- xSecurityGroup in modules\xSecurityGroup"

    "Initializing the backend..."

    "Initializing provider plugins..."
    "- Checking for available provider plugins..."
    "- Downloading plugin for provider 'azurerm' (hashicorp/azurerm) 2.15.0..."

    "Terraform has been successfully initialized!"

    "You may now begin working with Terraform. Try running 'terraform plan' to see"  
    "any changes that are required for your infrastructure. All Terraform commands"
    "should now work."

    "If you ever set or change modules or backend configuration for Terraform,"      
    "rerun this command to reinitialize your working directory. If you forget, other"
    "commands will detect it and remind you to do so if necessary."
      ```
  </details>
---

## Example of Managed Network Variables 📜 

If you mind using xManaged Network terraform module for your subscription, you need required to amend **tfvars** file convenient to your configuration detail. Below-stated file is an example of tfvars.

```hcl

SubscriptionId = ""
TenantId       = ""
ClientId       = ""
SecretKey      = ""

##### Env Details #####

ServiceId             = "xs101"
EnvironmentInstanceId = "d01" # This could be t01 - p01  
InstanceId            = "01"
Region                = "West Europe"

Tags = {
  account      = "vstsaccount"
  team_project = "VDC"
}
######  Env Details #####

##### Network Details #####

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

##### Subnet Details #####
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
  },
  "Subnet03" = {
    Name                  = "AppSubnet03"
    Range                 = "10.10.20.32/28"
  }
}

MonitoringSettings = {
    DiagnosticSettings = {
      StorageAccountLog = false
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

```


