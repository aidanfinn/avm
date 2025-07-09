# Azure Network Manager AVM Module

This module deploys an [Azure Network Manager](https://learn.microsoft.com/en-us/azure/virtual-network-manager/overview) instance with optional configurations including IPAM pools, network groups, and connectivity configurations.

> **Azure Verified Modules (AVM)**: This module follows the AVM specification for reusable, consistent Bicep modules published to the [Bicep Registry](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/registry-module-consume).

---

## Resource Types

| Resource Type | API Version |
|---------------|-------------|
| `Microsoft.Network/networkManagers` | `2023-09-01` |
| `Microsoft.Network/networkManagers/connectivityConfigurations` | `2023-09-01` |
| `Microsoft.Network/networkManagers/networkGroups` | `2023-09-01` |
| `Microsoft.Network/ipam/ipamPools` | `2023-09-01` |

---

## Parameters

| Name | Type | Description | Required | Default |
|------|------|-------------|----------|---------|
| `partnerLinkId` | `string` | Optional. Customer Usage Attribution (CUA) ID for partner tracking. | No | `'cca1ef9c-c4b1-4c3d-8973-7e5341ab6792'` |
| `location` | `string` | Location for all resources. | No | `resourceGroup().location` |
| `name` | `string` | The name of the Azure Network Manager resource. | Yes | N/A |
| `description` | `string` | Optional description of the Network Manager. | No | `''` |
| `tags` | `object` | Tags to apply to the resource. | No | `{}` |
| `networkManagerScopes` | `object` | Scopes for the Network Manager. | No | Root management group |
| `networkManagerScopeAccesses` | `array` | List of features (e.g., Connectivity, SecurityAdmin, Routing). | No | `["Connectivity", "SecurityAdmin", "Routing"]` |
| `lock` | `lockType` | Optional lock settings for the resource. | No | `null` |
| `diagnosticSettings` | `diagnosticSettingFullType[]` | Optional diagnostic settings for the resource. | No | `null` |
| `roleAssignments` | `roleAssignmentType[]` | Optional array of role assignments to create. | No | `null` |
| `ipamPools` | `ipamPoolType[]` | Optional list of IPAM pools. | No | `[]` |
| `networkGroups` | `networkGroupType[]` | Optional list of network groups. | No | `[]` |
| `connectivityConfigurations` | `connectivityConfigurationType[]` | Array of connectivity configurations to deploy. | Yes | `[]` |

---

## Outputs

| Name | Type | Description |
|------|------|-------------|
| `resourceGroupName` | `string` | The resource group the Network Manager was deployed in. |
| `name` | `string` | The name of the deployed Network Manager. |
| `resourceId` | `string` | The resource ID of the deployed Network Manager. |
| `location` | `string` | The location of the deployed Network Manager. |
| `ipamPools` | `array` | Array of objects for each deployed IPAM pool. |
| `connectivityConfigurations` | `array` | Array of resource IDs of the deployed connectivity configurations. |

---

## Usage

### Basic Example

```bicep
module networkManager 'br:cloudmechanixavm.azurecr.io/avm/res/network/network-managers:<version>' = {
  name: 'deployNetworkManager'
  params: {
    name: 'myNetworkManager'
    connectivityConfigurations: [
      {
        name: 'config1'
        description: 'Hub and spoke config'
        connectivityTopology: 'HubAndSpoke'
        hubs: [
          '/subscriptions/xxxx/resourceGroups/rg1/providers/Microsoft.Network/virtualNetworks/vnet1'
        ]
        isGlobal: false
        appliesToGroups: []
      }
    ]
  }
}
```

### WAF-Aligned Example

```bicep
module networkManager 'br:cloudmechanixavm.azurecr.io/avm/res/network/network-managers:<version>' = {
  name: 'wafAlignedNetworkManager'
  params: {
    name: 'wafNetworkManager'
    tags: {
      environment: 'prod'
      workload: 'network'
    }
    networkManagerScopes: {
      managementGroups: [
        '/providers/Microsoft.Management/managementGroups/myMg'
      ]
    }
    networkManagerScopeAccesses: [
      'Connectivity'
    ]
    connectivityConfigurations: [
      {
        name: 'prodConfig'
        connectivityTopology: 'Mesh'
        description: 'WAF-aligned mesh config'
        isGlobal: true
        appliesToGroups: [
          {
            networkGroupId: '/subscriptions/xxxx/resourceGroups/rg1/providers/Microsoft.Network/networkManagers/nm1/networkGroups/ng1'
            useHubGateway: false
            policy: 'None'
          }
        ]
      }
    ]
  }
}
```

> Replace `<registry-path>` and `<version>` with the appropriate values for your registry/module.

---

## Documentation Links

- [Azure Virtual Network Manager Overview](https://learn.microsoft.com/en-us/azure/virtual-network-manager/overview)
- [Azure Virtual Network Manager Tutorial](https://learn.microsoft.com/en-us/azure/virtual-network-manager/tutorial-network-manager-configure-connectivity)
- [Bicep Registry Modules](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/registry-module-consume)

---

## License

This project is licensed under the [MIT License](LICENSE).

---

## Contributing

Contributions are welcome! If you have suggestions or improvements, please [open an issue](https://github.com/aidanfinn/avm/issues) or submit a PR.

---

## Module Maintenance

This module is maintained by [Cloud Mechanix](https://www.cloudmechanix.com), aligned with the AVM specification.
