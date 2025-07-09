# Module: Network Manager Connectivity Configuration

This module deploys one or more Connectivity Configurations within an Azure Network Manager, enabling the definition of network topologies such as Hub-and-Spoke or Mesh for virtual networks. The module is part of the Azure Verified Modules (AVM) initiative, providing standardized and reusable Infrastructure as Code (IaC) for Azure deployments.

> **Note**: This module is intended to be referenced as follows:
> ```bicep
> module connectivityConfiguration 'br:cloudmechanixavm.azurecr.io/avm/res/network/network-managers/connectivityConfiguration:<version>' = {
>   name: 'connectivityConfigurationDeployment'
>   params: {
>     // Required parameters
>     networkManagerName: '<networkManagerName>'
>     connectivityConfigurations: [<configurationObject>]
>   }
> }
> ```

## Resource Types

| Resource Type | API Version |
|---------------|-------------|
| `Microsoft.Network/networkManagers/connectivityConfigurations` | 2024-05-01 |
| `Microsoft.Authorization/locks` | 2020-05-01 |
| `Microsoft.Resources/deployments` | 2024-03-01 |

## Parameters

| Parameter Name | Type | Default Value | Required | Description |
| --- | --- | --- | --- | --- |
| `networkManagerName` | string |  | Yes | The name of the parent Network Manager resource. |
| `connectivityConfigurations` | array |  | Yes | Array of connectivity configurations to deploy. See [Parameter Usage: `connectivityConfigurations`](#parameter-usage-connectivityconfigurations). |
| `location` | string | `resourceGroup().location` | No | The Azure region where the connectivity configurations will be deployed. |
| `lock` | string | `''` | No | Specifies the lock level for the connectivity configurations. Possible values: `''` (None), `'CanNotDelete'`, `'ReadOnly'`. |
| `enableTelemetry` | bool | `true` | No | Enables or disables usage telemetry for the module. |

### Parameter Usage: `connectivityConfigurations`

The `connectivityConfigurations` parameter defines network topologies (e.g., HubAndSpoke, Mesh). Example:

```bicep
connectivityConfigurations: [
  {
    name: 'hubSpokeConnectivity'
    appliesToGroups: [
      {
        groupConnectivity: 'None'
        isGlobal: false
        networkGroupResourceId: '<networkGroupResourceId>'
        useHubGateway: false
      }
    ]
    connectivityTopology: 'HubAndSpoke'
    hubs: [
      {
        resourceId: '<virtualNetworkResourceId>'
        resourceType: 'Microsoft.Network/virtualNetworks'
      }
    ]
    deleteExistingPeering: true
    description: 'Hub and Spoke topology configuration'
  }
]