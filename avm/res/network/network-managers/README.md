# Network Manager

Deploys an **Azure Network Manager** resource along with optional sub-resources:
- **Network Groups** via sub-module
- **IPAM Pools** via sub-module
- Diagnostic Settings, Locks, and Role Assignments

---

## 📦 Module Registry Reference

```bicep
module networkManager 'br:cloudmechanixavm.azurecr.io/avm/res/network/network-managers:v0.2' = {
  name: 'networkManager'
  params: {
    name: 'centralNetMgr'
    location: 'westeurope'
    networkGroups: [
      {
        name: 'spoke-group'
        description: 'All spoke VNets'
        networkGroupType: 'ConnectedSecurityGroups'
        associatedNetworks: [
          '/subscriptions/.../resourceGroups/.../providers/Microsoft.Network/virtualNetworks/spoke1-vnet'
          '/subscriptions/.../resourceGroups/.../providers/Microsoft.Network/virtualNetworks/spoke2-vnet'
        ]
        tags: { env: 'prod' }
      }
    ]
    ipamPools: [
      {
        name: 'corp-pool'
        addressPrefixes: ['10.1.0.0/16']
        displayName: 'Corporate Pool'
        tags: { env: 'prod' }
      }
    ]
    diagnosticSettings: [
      {
        name: 'netMgrDiagnostics'
        workspaceResourceId: '/subscriptions/.../resourceGroups/.../providers/Microsoft.OperationalInsights/workspaces/logs'
        metricCategories: [{ category: 'AllMetrics', enabled: true }]
        logCategoriesAndGroups: [{ categoryGroup: 'allLogs', enabled: true }]
        logAnalyticsDestinationType: 'Dedicated'
      }
    ]
    lock: {
      kind: 'CanNotDelete'
      name: 'lock-centralNetMgr'
    }
    roleAssignments: [
      {
        principalId: '00000000-0000-0000-0000-000000000000'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
  }
}
```

---

## 🔧 Parameters

| Name                         | Type     | Description |
|------------------------------|----------|-------------|
| `name`                       | `string` | **Required.** Network Manager name (1–80 chars). |
| `location`                   | `string` | Optional. Azure region. |
| `description`                | `string` | Optional. Description text. |
| `tags`                       | `object` | Optional. Tags. |
| `partnerLinkId`              | `string` | Optional. CUA GUID. |
| `networkManagerScopes`       | `object` | Optional. Scopes: `managementGroups`, `subscriptions`. |
| `networkManagerScopeAccesses`| `array`  | Optional. List of features. |
| `lock`                       | `lockType?` | Optional. Lock settings. |
| `diagnosticSettings`         | `diagnosticSettingFullType[]?` | Optional. Diagnostic settings. |
| `roleAssignments`            | `roleAssignmentType[]?` | Optional. Role assignments. |
| `networkGroups`              | `networkGroupType[]?` | Optional. Network Groups (see type). |
| `ipamPools`                  | `ipamPoolType[]?` | Optional. IPAM pools (see type). |

---

## 🔹 `networkGroupType`

| Property              | Type     | Description |
|-----------------------|----------|-------------|
| `name`                | `string` | Required. |
| `description`         | `string?` | Optional. |
| `networkGroupType`    | `string` | Required (e.g. `ConnectedSecurityGroups`). |
| `associatedNetworks`  | `array`  | Required. Resource IDs of VNets/Subnets. |
| `location`            | `string?` | Optional. |
| `tags`                | `object?` | Optional. |

---

## 🔹 `ipamPoolType`

| Property             | Type     | Description |
|----------------------|----------|-------------|
| `name`               | `string` | Required. |
| `location`           | `string?` | Optional. |
| `addressPrefixes`    | `array`  | Required. List of CIDRs. |
| `description`        | `string?` | Optional. |
| `displayName`        | `string?` | Optional. |
| `parentPoolName`     | `string?` | Optional. |
| `tags`               | `object?` | Optional. |
| `provisioningState`  | `string?` | Optional; managed by Azure. |

---

## 📤 Outputs

| Name                     | Type     | Description |
|--------------------------|----------|-------------|
| `resourceId`             | `string` | Network Manager ID. |
| `name`                   | `string` | Network Manager name. |
| `location`               | `string` | Network Manager region. |
| `networkGroups`          | `array`  | Created Network Groups (id/name). |
| `ipamPools`              | `array`  | Created IPAM pools (id/name/prefixes). |

---

## 🧪 Advanced Usage Example

See Module Registry Reference above for full deployment example with all sub-resources configured.

---

## 📘 Resources

- [Azure Network Manager docs - ARM schema](https://learn.microsoft.com/azure/templates/microsoft.network/networkmanagers)
- [AVM Standards & Guidelines](https://azure.github.io/Azure-Verified-Modules/)
- [Parameter Types: `lockType`, `diagnosticSettingFullType`, `roleAssignmentType`](https://github.com/Azure/avm-helpers)

---
