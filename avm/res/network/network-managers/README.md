# avm/res/network/network-managers `[Microsoft.Network/networkManagers]`

This module deploys an Azure Network Manager resource with specified scope and optional configurations including IPAM pools and network groups.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Notes](#Notes)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/networkManagers` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/networkManagers) |
| `Microsoft.Resources/deployments` | [2021-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2021-04-01/deployments) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/network/network-managers:<version>`.

### Using only defaults

This instance deploys the module with the minimum set of required parameters.

<details>

<summary>via Bicep module</summary>

```bicep
module networkManagers 'br/public:avm/res/network/network-managers:<version>' = {
  name: 'networkManagersDeployment'
  params: {
    // Required parameters
    name: 'netmgr-min-001'
    // Non-required parameters
    location: '<location>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "name": {
      "value": "netmgr-min-001"
    },
    "location": {
      "value": "<location>"
    }
  }
}
```

</details>
<p>

### Using large parameter set

This instance deploys the module with most of its features enabled.

<details>

<summary>via Bicep module</summary>

```bicep
module networkManagers 'br/public:avm/res/network/network-managers:<version>' = {
  name: 'networkManagersDeployment'
  params: {
    // Required parameters
    name: 'netmgr-max-001'
    // Non-required parameters
    description: 'This is a sample network manager for testing'
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        logAnalyticsDestinationType: 'Dedicated'
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
          }
        ]
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    ipamPools: [
      {
        addressPrefixes: [
          '10.0.0.0/16'
          '10.1.0.0/16'
        ]
        description: 'IPAM pool for production workloads'
        displayName: 'Production IPAM Pool'
        location: '<location>'
        name: 'prod-ipam-pool'
        tags: {
          Environment: 'Production'
          Purpose: 'IPAM'
        }
      }
    ]
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    networkGroups: [
      {
        description: 'Network group for production spoke networks'
        location: '<location>'
        memberType: 'Static'
        name: 'prod-spokes'
        staticMemberResourceIds: [
          {
            resourceId: '<virtualNetworkResourceId>'
          }
        ]
      }
    ]
    networkManagerScopeAccesses: [
      'Connectivity'
      'SecurityAdmin'
      'Routing'
    ]
    networkManagerScopes: {
      managementGroups: [
        '/providers/Microsoft.Management/managementGroups/<managementGroupId>'
      ]
      subscriptions: [
        '/subscriptions/<subscriptionId>'
      ]
    }
    partnerLinkId: '<partnerLinkId>'
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Network Contributor'
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "name": {
      "value": "netmgr-max-001"
    },
    "description": {
      "value": "This is a sample network manager for testing"
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "logAnalyticsDestinationType": "Dedicated",
          "logCategoriesAndGroups": [
            {
              "categoryGroup": "allLogs"
            }
          ],
          "metricCategories": [
            {
              "category": "AllMetrics"
            }
          ],
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "ipamPools": {
      "value": [
        {
          "addressPrefixes": [
            "10.0.0.0/16",
            "10.1.0.0/16"
          ],
          "description": "IPAM pool for production workloads",
          "displayName": "Production IPAM Pool",
          "location": "<location>",
          "name": "prod-ipam-pool",
          "tags": {
            "Environment": "Production",
            "Purpose": "IPAM"
          }
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "networkGroups": {
      "value": [
        {
          "description": "Network group for production spoke networks",
          "location": "<location>",
          "memberType": "Static",
          "name": "prod-spokes",
          "staticMemberResourceIds": [
            {
              "resourceId": "<virtualNetworkResourceId>"
            }
          ]
        }
      ]
    },
    "networkManagerScopeAccesses": {
      "value": [
        "Connectivity",
        "SecurityAdmin",
        "Routing"
      ]
    },
    "networkManagerScopes": {
      "value": {
        "managementGroups": [
          "/providers/Microsoft.Management/managementGroups/<managementGroupId>"
        ],
        "subscriptions": [
          "/subscriptions/<subscriptionId>"
        ]
      }
    },
    "partnerLinkId": {
      "value": "<partnerLinkId>"
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Network Contributor"
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the Azure Network Manager resource. Must be 1-80 characters, using only a-z, A-Z, 0-9, _, ., or -. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-description) | string | A description of the Azure Virtual Network Manager resource. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`ipamPools`](#parameter-ipampools) | array | List of IPAM pools to create under the Network Manager. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`networkGroups`](#parameter-networkgroups) | array | List of network groups to create under the Network Manager. |
| [`networkManagerScopeAccesses`](#parameter-networkmanagerscopeaccesses) | array | The list of network manager features to apply to the Network Manager. |
| [`networkManagerScopes`](#parameter-networkmanagerscopes) | object | The scopes for the Network Manager. |
| [`partnerLinkId`](#parameter-partnerlinkid) | string | Customer Usage Attribution (CUA) ID for partner tracking. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-tags) | object | Tags to apply to the Network Manager resource. |

### Parameter: `name`

The name of the Azure Network Manager resource. Must be 1-80 characters, using only a-z, A-Z, 0-9, _, ., or -.

- Required: Yes
- Type: string
- MinLength: 1
- MaxLength: 80

### Parameter: `description`

A description of the Azure Virtual Network Manager resource.

- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticSettings`

The diagnostic settings of the service.

- Required: No
- Type: array

### Parameter: `ipamPools`

List of IPAM pools to create under the Network Manager.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

The lock settings of the service.

- Required: No
- Type: object

### Parameter: `networkGroups`

List of network groups to create under the Network Manager.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `networkManagerScopeAccesses`

The list of network manager features to apply to the Network Manager.

- Required: No
- Type: array
- Default: `['Connectivity', 'SecurityAdmin', 'Routing']`
- Allowed:
  ```Bicep
  [
    'Connectivity'
    'SecurityAdmin'
    'Routing'
  ]
  ```

### Parameter: `networkManagerScopes`

The scopes for the Network Manager.

- Required: No
- Type: object
- Default: `{ managementGroups: ['/providers/Microsoft.Management/managementGroups/${tenant().tenantId}'], subscriptions: [] }`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`managementGroups`](#parameter-networkmanagerscopesmanagementgroups) | array | List of management groups. |
| [`subscriptions`](#parameter-networkmanagerscopessubscriptions) | array | List of subscriptions. |

### Parameter: `networkManagerScopes.managementGroups`

List of management groups.

- Required: Yes
- Type: array

### Parameter: `networkManagerScopes.subscriptions`

List of subscriptions.

- Required: Yes
- Type: array

### Parameter: `partnerLinkId`

Customer Usage Attribution (CUA) ID for partner tracking.

- Required: No
- Type: string
- Default: `'cca1ef9c-c4b1-4c3d-8973-7e5341ab6792'`

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

### Parameter: `tags`

Tags to apply to the Network Manager resource.

- Required: No
- Type: object
- Default: `{}`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `ipamPools` | array | An array of objects containing the resource ID, name, and address prefixes for each deployed IPAM pool. |
| `location` | string | The location of the deployed Network Manager. |
| `name` | string | The name of the deployed Network Manager. |
| `resourceGroupName` | string | The resource group the virtual network gateway was deployed. |
| `resourceId` | string | The resource ID of the deployed Network Manager. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |
| `./ipamPool/main.bicep` | Local reference |
| `./networkGroup/main.bicep` | Local reference |

## Notes

### Parameter Usage: `networkManagerScopes`

You can specify the scopes for the network manager by providing management group IDs and subscription IDs. The default scope is the root management group of the tenant.

<details>

<summary>Parameter JSON format</summary>

```json
"networkManagerScopes": {
    "value": {
        "managementGroups": [
            "/providers/Microsoft.Management/managementGroups/mg-example"
        ],
        "subscriptions": [
            "/subscriptions/12345678-1234-1234-1234-123456789012"
        ]
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
networkManagerScopes: {
    managementGroups: [
        '/providers/Microsoft.Management/managementGroups/mg-example'
    ]
    subscriptions: [
        '/subscriptions/12345678-1234-1234-1234-123456789012'
    ]
}
```

</details>

### Parameter Usage: `ipamPools`

You can create IPAM pools under the Network Manager to manage IP address allocation.

<details>

<summary>Parameter JSON format</summary>

```json
"ipamPools": {
    "value": [
        {
            "name": "prod-ipam-pool",
            "addressPrefixes": [
                "10.0.0.0/16",
                "10.1.0.0/16"
            ],
            "description": "IPAM pool for production workloads",
            "displayName": "Production IPAM Pool",
            "location": "West Europe",
            "tags": {
                "Environment": "Production",
                "Purpose": "IPAM"
            }
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
ipamPools: [
    {
        name: 'prod-ipam-pool'
        addressPrefixes: [
            '10.0.0.0/16'
            '10.1.0.0/16'
        ]
        description: 'IPAM pool for production workloads'
        displayName: 'Production IPAM Pool'
        location: 'West Europe'
        tags: {
            Environment: 'Production'
            Purpose: 'IPAM'
        }
    }
]
```

</details>

### Parameter Usage: `networkGroups`

You can specify network groups with static members to be created under the Network Manager.

<details>

<summary>Parameter JSON format</summary>

```json
"networkGroups": {
    "value": [
        {
            "name": "prod-spokes",
            "description": "Network group for production spoke networks",
            "location": "West Europe",
            "memberType": "Static",
            "staticMemberResourceIds": [
                {
                    "resourceId": "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rg-example/providers/Microsoft.Network/virtualNetworks/vnet-spoke1"
                },
                {
                    "resourceId": "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rg-example/providers/Microsoft.Network/virtualNetworks/vnet-spoke2"
                }
            ]
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
networkGroups: [
    {
        name: 'prod-spokes'
        description: 'Network group for production spoke networks'
        location: 'West Europe'
        memberType: 'Static'
        staticMemberResourceIds: [
            {
                resourceId: '/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rg-example/providers/Microsoft.Network/virtualNetworks/vnet-spoke1'
            }
            {
                resourceId: '/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rg-example/providers/Microsoft.Network/virtualNetworks/vnet-spoke2'
            }
        ]
    }
]
```

</details>

### Parameter Usage: `roleAssignments`

Create role assignments on the Network Manager. You can define multiple role assignments.

<details>

<summary>Parameter JSON format</summary>

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Network Contributor",
            "principalId": "12345678-1234-1234-1234-123456789012",
            "principalType": "ServicePrincipal"
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
roleAssignments: [
    {
        roleDefinitionIdOrName: 'Network Contributor'
        principalId: '12345678-1234-1234-1234-123456789012'
        principalType: 'ServicePrincipal'
    }
]
```

</details>
