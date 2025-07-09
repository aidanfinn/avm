# Module: Network Manager Network Group

This module deploys a Network Group within an Azure Network Manager, enabling the grouping of virtual networks or subscriptions for centralized network management, such as connectivity or security configurations. The module is part of the Azure Verified Modules (AVM) initiative, providing standardized and reusable Infrastructure as Code (IaC) for Azure deployments.

> **Note**: This module is intended to be referenced as follows:
> ```bicep
> module networkGroup 'br:cloudmechanixavm.azurecr.io/avm/res/network/network-managers/networkGroup:<version>' = {
>   name: 'networkGroupDeployment'
>   params: {
>     // Required parameters
>     networkManagerName: '<networkManagerName>'
>     networkGroupName: '<networkGroupName>'
>   }
> }
> ```

## Resource Types

| Resource Type | API Version |
|---------------|-------------|
| `Microsoft.Network/networkManagers/networkGroups` | 2023-04-01 |
| `Microsoft.Authorization/locks` | 2020-05-01 |
| `Microsoft.Authorization/roleAssignments` | 2020-10-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Required | Description |
| --- | --- | --- | --- | --- |
| `networkManagerName` | string |  | Yes | The name of the parent Network Manager resource. |
| `networkGroupName` | string |  | Yes | The name of the Network Group. Must be unique within the Network Manager. |
| `location` | string | `resourceGroup().location` | No | The Azure region where the Network Group will be deployed. |
| `memberType` | string | `'VirtualNetwork'` | No | The type of members in the Network Group. Allowed values: `'VirtualNetwork'`, `'Subscription'`. |
| `staticMembers` | array | `[]` | No | Array of static members (e.g., virtual networks or subscriptions) to include in the Network Group. |
| `description` | string | `''` | No | A description of the Network Group. |
| `tags` | object | `{}` | No | Tags to apply to the Network Group resource. |
| `lock` | string | `''` | No | Specifies the lock level for the resource. Possible values: `''` (None), `'CanNotDelete'`, `'ReadOnly'`. |
| `roleAssignments` | array | `[]` | No | Array of role assignments to grant permissions on the Network Group. |
| `enableTelemetry` | bool | `true` | No | Enables or disables usage telemetry for the module. |

### Parameter Usage: `staticMembers`

The `staticMembers` parameter specifies the resources (e.g., virtual networks) included in the Network Group:

```bicep
staticMembers: [
  {
    name: 'virtualNetworkSpoke1'
    resourceId: '<virtualNetworkResourceId>'
  }
  {
    name: 'virtualNetworkSpoke2'
    resourceId: '<virtualNetworkResourceId>'
  }
]