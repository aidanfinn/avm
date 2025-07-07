# Azure Verified Module: Network Manager

This AVM-compliant Bicep module deploys an [Azure Virtual Network Manager](https://learn.microsoft.com/azure/virtual-network-manager/overview) resource. The module supports WAF-aligned parameters for observability, security, and governance, including optional lock, diagnostic settings, and role assignments.

## 📦 Module Registry Reference

```bicep
module networkManagerModule 'br:<registry>/avm/res/network/network-managers:<version>' = { ... }
```

Replace `<registry>` with your Bicep registry (e.g. `br/public`) and `<version>` with the required version tag.

---

## 🔧 Parameters

| Name                          | Type     | Description                                                                                      | Default                                                                 |
|-------------------------------|----------|--------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------|
| `name`                        | `string` | **Required.** Name of the Network Manager (1–80 chars, `^[a-zA-Z0-9_.-]+$`).                     | –                                                                       |
| `location`                    | `string` | Azure region where the Network Manager is deployed.                                              | `resourceGroup().location`                                             |
| `description`                 | `string` | Optional description of the Network Manager.                                                     | `''`                                                                    |
| `tags`                        | `object` | Optional tags to apply to the Network Manager.                                                   | `{}`                                                                    |
| `partnerLinkId`              | `string` | Customer Usage Attribution (CUA) ID for partner tracking.                                        | `'cca1ef9c-c4b1-4c3d-8973-7e5341ab6792'` (Cloud Mechanix default)      |
| `networkManagerScopes`       | `object` | Scope for the Network Manager. Management groups or subscriptions.                              | `{ managementGroups: ["/providers/Microsoft.Management/managementGroups/${tenant().tenantId}"], subscriptions: [] }` |
| `networkManagerScopeAccesses`| `array`  | List of features to apply: `Connectivity`, `SecurityAdmin`, `Routing`.                          | `[ 'Connectivity', 'SecurityAdmin', 'Routing' ]`                       |
| `lock`                        | `object` | Optional resource lock. Supports `CanNotDelete`, `ReadOnly`, or `None`.                         | `{}`                                                                    |
| `diagnosticSettings`         | `array`  | Optional diagnostics settings. Send logs/metrics to Log Analytics, Event Hub, or Storage.       | `[]`                                                                    |
| `roleAssignments`            | `array`  | Optional array of role assignments to apply at the Network Manager level.                       | `[]`                                                                    |

---

## ✅ Basic Usage

Deploy a basic Network Manager in the current subscription and tenant root management group:

```bicep
module networkManager 'br:public/avm/res/network/network-managers:0.1.0' = {
  name: 'networkManagerBasic'
  params: {
    name: 'centralNetMgr'
  }
}
```

---

## 🚀 Advanced Usage

Deploy a Network Manager with locks, diagnostics, role assignments, and partner attribution:

```bicep
module networkManager 'br:public/avm/res/network/network-managers:0.1.0' = {
  name: 'networkManagerAdvanced'
  params: {
    name: 'corpNetMgr'
    location: 'westeurope'
    description: 'Corporate-wide virtual network manager'
    tags: {
      environment: 'prod'
      project: 'networking'
    }
    partnerLinkId: 'cca1ef9c-c4b1-4c3d-8973-7e5341ab6792'
    networkManagerScopes: {
      managementGroups: [
        '/providers/Microsoft.Management/managementGroups/contoso'
      ]
      subscriptions: [
        '/subscriptions/11111111-2222-3333-4444-555555555555'
      ]
    }
    networkManagerScopeAccesses: [
      'Connectivity'
      'SecurityAdmin'
    ]
    lock: {
      kind: 'CanNotDelete'
      name: 'protectNetMgr'
    }
    diagnosticSettings: [
      {
        name: 'netMgrDiagnostics'
        workspaceResourceId: '/subscriptions/.../resourceGroups/.../providers/Microsoft.OperationalInsights/workspaces/centralLogs'
        metricCategories: [
          { category: 'AllMetrics', enabled: true }
        ]
        logCategoriesAndGroups: [
          { categoryGroup: 'allLogs', enabled: true }
        ]
        logAnalyticsDestinationType: 'Dedicated'
      }
    ]
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

## 📤 Outputs

| Name               | Type     | Description                                                |
|--------------------|----------|------------------------------------------------------------|
| `resourceGroupName`| `string` | The resource group where the Network Manager is deployed.  |
| `name`             | `string` | The name of the Network Manager.                          |
| `resourceId`       | `string` | The full resource ID of the Network Manager.              |
| `location`         | `string` | The Azure region of the deployed Network Manager.         |

---

## 🧪 Test Scenarios

- [ ] Deploy to subscription scope
- [ ] Deploy with only required parameters
- [ ] Deploy with all optional parameters (lock, diagnostics, roles)
- [ ] Deploy to multiple scopes (MG + subs)

---

## 📘 Resources

- [Azure Virtual Network Manager Documentation](https://learn.microsoft.com/en-us/azure/virtual-network-manager/)
- [Azure Verified Modules (AVM) Standards](https://azure.github.io/Azure-Verified-Modules/)
