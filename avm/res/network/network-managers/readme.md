# Azure Network Manager AVM Module

## Description
Deploys an Azure Network Manager resource with optional configurations including IPAM Pools, Network Groups, Connectivity Configurations, Routing Configurations, Security Admin Configurations, and Verifier Workspaces. This module adheres to the Azure Verified Modules (AVM) specification.

## Simple Usage

```bicep
module networkManagerModule 'br:cloudmechanixavm.azurecr.io/avm/res/network/network-managers:v1.0' = {
  name: 'networkManagerModule'
  params: {
    name: 'networkManagerModule'
    networkManagerConfig: {
      name: 'mycompany-vnm'
      networkManagerScopes: {}
    }
  }
}
```

## Metadata
```bicep
metadata name = 'Network Manager'
metadata description = 'Deploys an Azure Network Manager resource with specified scope and optional configurations.'
metadata avm.name = 'network-manager'
metadata avm.type = 'module'
metadata avm.rp = 'Microsoft.Network'
metadata avm.resource = 'networkManagers'
metadata avm.version = '0.1.0'
metadata avm.owner = 'Cloud Mechanix'
```

## Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `partnerLinkId` | `string` | Optional | Optional. Customer Usage Attribution (CUA) ID for partner tracking. Defaults to Cloud Mechanix. |
| `location` | `string` | Optional | Optional. Location for all resources. |
| `name` | `string` | **Mandatory** | Mandatory. The name of the Azure Network Manager resource. Must be 1-80 characters. Regex: `^[a-zA-Z0-9_.-]+$` |
| `tags` | `object` | Optional | Optional. Tags to apply to the Network Manager resource. |
| `networkManagerConfig` | `object` | **Mandatory** | Mandatory. The configuration for the Network Manager resource. |
| `lock` | `object` | Optional | Optional. The lock settings of the service. |
| `diagnosticSettings` | `array` | Optional | Optional. The diagnostic settings of the service. |
| `roleAssignments` | `array` | Optional | Optional. Array of role assignments to create. |
| `ipamPools` | `array` | Optional | Optional. List of IPAM pools to create under the Network Manager. |
| `networkGroups` | `array` | Optional | Optional. List of network groups to create under the Network Manager. |
| `connectivityConfigurations` | `array` | Optional | Optional. An array of connectivity configurations to deploy. |
| `routingConfigurations` | `array` | Optional | Optional. An array of routing configurations to deploy under the Network Manager. |
| `securityAdminConfigurations` | `array` | Optional | Optional. An array of security admin configurations to deploy. |
| `verifierWorkspaces` | `array` | Optional | Optional. An array of verifier workspaces to deploy under the Network Manager. |

## Outputs

| Name | Type | Description |
|------|------|-------------|
| `resourceGroupName` | `string` | The resource group the Network Manager was deployed in. |
| `name` | `string` | The name of the deployed Network Manager. |
| `resourceId` | `string` | The resource ID of the deployed Network Manager. |
| `location` | `string` | The location of the deployed Network Manager. |
| `ipamPools` | `array` | An array of objects with the ID, name, and address prefixes of each deployed IPAM pool. |
| `networkGroups` | `array` | An array of objects with the ID and name of each deployed Network Group. |
| `connectivityConfigurations` | `array` | An array of objects with the ID and name of each deployed Connectivity Configuration. |
| `routingConfigurations` | `array` | An array of objects with the ID, name, and rule collections of each deployed routing configuration. |
| `securityAdminConfigurations` | `array` | An array of objects with the ID, name, and rule collections of each deployed security admin configuration. |
| `verifierWorkspaces` | `array` | An array of objects with the ID and name of each deployed verifier workspace. |
