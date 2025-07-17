# AVM Module: Network Manager Security Admin Configuration

## Overview

This Bicep module deploys a Security Admin Configuration for Azure Network Manager, along with associated rule collections.

## Metadata

- **Name**: `Network Manager Security Admin Configuration`
- **Description**: Deploys one or more Security Admin Configurations for Azure Network Manager.
- **License**: MIT
- **Author**: Cloud Mechanix

## Parameters

| Name                        | Type   | Description                                                                                  | Required |
|-----------------------------|--------|----------------------------------------------------------------------------------------------|----------|
| `networkManagerName`       | string | Mandatory. The name of the parent Azure Network Manager.                                    | Yes      |
| `securityAdminConfiguration` | `securityAdminConfigurationType` | Mandatory. The Security Admin Configuration to deploy.                        | Yes      |

## Resources

### Security Admin Configuration

```bicep
resource securityAdminConfigurationModule 'Microsoft.Network/networkManagers/securityAdminConfigurations@2024-07-01' = {
  name: '${networkManagerName}/${securityAdminConfiguration.name}'
  properties: {
    description: securityAdminConfiguration.?description ?? ''
    applyOnNetworkIntentPolicyBasedServices: securityAdminConfiguration.?applyOnNetworkIntentPolicyBasedServices ?? ['None']
    networkGroupAddressSpaceAggregationOption: securityAdminConfiguration.?networkGroupAddressSpaceAggregationOption ?? 'None'
  }
}
```

### Rule Collections

```bicep
module ruleCollectionModule './ruleCollection.bicep' = [for ruleCollection in securityAdminConfiguration.?ruleCollections ?? []: {
  name: '${networkManagerName}-${ruleCollection.name}'
  params: {
    securityAdminConfigurationName: securityAdminConfigurationModule.name
    ruleCollection: ruleCollection
  }
}]
```

## Outputs

| Name             | Type   | Description                                                  |
|------------------|--------|--------------------------------------------------------------|
| `id`             | string | The resource ID of the Security Admin Configuration.         |
| `name`           | string | The name of the Security Admin Configuration.                |
| `ruleCollections`| array  | The rule collections of the Security Admin Configuration.    |

### Output Structure for `ruleCollections`

```json
[
  {
    "id": "<resource-id>",
    "name": "<rule-collection-name>",
    "rules": [ /* rules output from module */ ]
  }
]
```

## File Structure

```
📁 modules
 └── 📄 main.bicep
     └── 📄 ruleCollection.bicep
          └── 📄 rule.bicep
```
