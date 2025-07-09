# Module: Network Manager IPAM Pool

This module deploys an IP Address Management (IPAM) pool within an Azure Network Manager, enabling centralized management of IP address allocations for virtual networks. The module is part of the Azure Verified Modules (AVM) initiative, providing standardized and reusable Infrastructure as Code (IaC) for Azure deployments.

> **Note**: This module is intended to be referenced as follows:
> ```bicep
> module ipamPool 'br:cloudmechanixavm.azurecr.io/avm/res/network/network-managers/ipamPool:<version>' = {
>   name: 'ipamPoolDeployment'
>   params: {
>     // Required parameters
>     networkManagerName: '<networkManagerName>'
>     ipamPoolName: '<ipamPoolName>'
>     addressPrefixes: ['<addressPrefix>']
>   }
> }
> ```

## Resource Types

| Resource Type | API Version |
|---------------|-------------|
| `Microsoft.Network/networkManagers/ipamPools` | 2023-04-01 |
| `Microsoft.Authorization/locks` | 2020-05-01 |
| `Microsoft.Authorization/roleAssignments` | 2020-10-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Required | Description |
| --- | --- | --- | --- | --- |
| `networkManagerName` | string |  | Yes | The name of the parent Network Manager resource. |
| `ipamPoolName` | string |  | Yes | The name of the IPAM pool. Must be unique within the Network Manager. |
| `location` | string | `resourceGroup().location` | No | The Azure region where the IPAM pool will be deployed. |
| `addressPrefixes` | array |  | Yes | Array of IP address prefixes (in CIDR notation) to include in the IPAM pool. |
| `tags` | object | `{}` | No | Tags to apply to the IPAM pool resource. |
| `lock` | string | `''` | No | Specifies the lock level for the resource. Possible values: `''` (None), `'CanNotDelete'`, `'ReadOnly'`. |
| `roleAssignments` | array | `[]` | No | Array of role assignments to grant permissions on the IPAM pool. |
| `enableTelemetry` | bool | `true` | No | Enables or disables usage telemetry for the module. |

### Parameter Usage: `lock`

To apply a resource lock, specify the `lock` parameter as follows:

```bicep
lock: 'CanNotDelete'