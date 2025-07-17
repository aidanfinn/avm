# Network Manager Routing Configuration Module

**Bicep Module**: `routingConfiguration.bicep`  
**Description**: Deploys a Routing Configuration for Azure Network Manager, including optional Rule Collections.

---

## Table of Contents

- [Parameters](#parameters)
- [Resources Deployed](#resources-deployed)
- [Outputs](#outputs)
- [Description](#description)
- [Example Usage](#example-usage)

---

## Parameters

| Name                  | Type                            | Description                                                              | Required |
|-----------------------|----------------------------------|--------------------------------------------------------------------------|----------|
| `networkManagerName`  | `string`                         | The name of the parent Azure Network Manager.                            | Yes      |
| `routingConfiguration`| `routingConfigurationType`       | The routing configuration to deploy, including optional rule collections.| Yes      |

---

## Resources Deployed

- `Microsoft.Network/networkManagers/routingConfigurations@2024-05-01` – Deploys the routing configuration.
- `ruleCollection.bicep` (module) – Deploys optional rule collections if specified in the `routingConfiguration` object.

---

## Outputs

| Name               | Type     | Description                                                           |
|--------------------|----------|-----------------------------------------------------------------------|
| `id`               | `string` | The resource ID of the Routing Configuration.                         |
| `name`             | `string` | The name of the Routing Configuration.                                |
| `ruleCollections`  | `array`  | The rule collections of the Routing Configuration, if any were deployed.|

---

## Description

This Bicep module is designed to deploy a Routing Configuration as part of an Azure Virtual Network Manager (AVNM). It supports optional nested rule collections by referencing an external `ruleCollection.bicep` module. 

It is fully aligned with AVM documentation standards for modular Azure resource deployments.

---

## Example Usage

```bicep
module routingConfig 'routingConfiguration.bicep' = {
  name: 'routingConfig'
  params: {
    networkManagerName: 'my-avnm'
    routingConfiguration: {
      name: 'routingConfig1'
      description: 'Sample routing configuration'
      ruleCollections: [
        {
          name: 'ruleCollection1'
          rules: [
            {
              name: 'rule1'
              destination: {
                destinationAddress: '10.0.0.0/16'
                type: 'AddressPrefix'
              }
              nextHop: {
                nextHopType: 'VirtualAppliance'
                nextHopAddress: '10.1.1.1'
              }
            }
          ]
        }
      ]
    }
  }
}
```

---

## Notes

- Ensure `ruleCollection.bicep` is available in the same directory or accessible path.
- This module assumes AVNM is already deployed and accessible using the provided `networkManagerName`.

---

© Cloud Mechanix – Licensed under MIT