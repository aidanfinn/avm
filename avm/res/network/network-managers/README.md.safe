
# Azure Virtual Network Manager Bicep Module

This Bicep module deploys Azure Virtual Network Manager resources, including IPAM pools, network groups, connectivity configurations, routing configurations, security admin configurations, and diagnostic settings, aligned with Azure Well-Architected Framework (WAF) standards.

Credit to Microsoft for usage of types shared from the offical Azure Verified Modules: https://github.com/Azure/bicep-registry-modules/tree/main/avm

---

## Parameters

### General Parameters

| Name               | Type   | Description                                            | Default                     | Required |
|--------------------|--------|--------------------------------------------------------|-----------------------------|----------|
| `resourceGroupName` | string | Name of the resource group to deploy resources into.   | `test-virtual-networks-basic-rg` | No       |
| `resourceLocation`  | string | Azure location where resources will be deployed.       | `deployment().location`     | No       |
| `virtualNetworkName`| string | Name of the primary Virtual Network to create.         | -                           | Yes      |
| `localNetworkGatewayName` | string | Name of the Local Network Gateway to create.      | -                           | Yes      |

---

### IPAM Pools

| Name                     | Type   | Description                                           | Default | Required |
|--------------------------|--------|-------------------------------------------------------|---------|----------|
| `ipamPools`              | array  | Array of IPAM pool objects to define IP address management pools. | `[]`    | No       |

#### IPAM Pool Properties

| Name                | Type   | Description                                | Default | Required |
|---------------------|--------|--------------------------------------------|---------|----------|
| `name`              | string | Name of the IPAM pool.                      | -       | Yes      |
| `addressPrefixes`   | array  | Array of address prefixes in CIDR notation for the pool. | -       | Yes      |
| `description`       | string | Description of the IPAM pool.               | -       | No       |
| `displayName`       | string | Display name for the IPAM pool.             | -       | No       |

---

### Network Groups

| Name                 | Type   | Description                                           | Default | Required |
|----------------------|--------|-------------------------------------------------------|---------|----------|
| `networkGroups`       | array  | Array of network group objects defining sets of network resources. | `[]`    | No       |

#### Network Group Properties

| Name                    | Type   | Description                                           | Default | Required |
|-------------------------|--------|-------------------------------------------------------|---------|----------|
| `name`                  | string | Name of the network group.                             | -       | Yes      |
| `location`              | string | Azure region of the network group.                     | -       | Yes      |
| `description`           | string | Description for the network group.                     | -       | No       |
| `memberType`            | string | Type of membership: `Static` or `Dynamic`.             | -       | Yes      |
| `staticMemberResourceIds` | array | List of resource IDs when `memberType` is `Static`.   | `[]`    | No       |
| `query`                 | string | Query string when `memberType` is `Dynamic`.          | -       | No       |

---

### Connectivity Configurations

| Name                       | Type   | Description                                            | Default | Required |
|----------------------------|--------|--------------------------------------------------------|---------|----------|
| `connectivityConfigurations` | array | Connectivity configuration objects specifying connections between network groups. | `[]`    | No       |

#### Connectivity Configuration Properties

| Name                     | Type    | Description                                         | Default | Required |
|--------------------------|---------|-----------------------------------------------------|---------|----------|
| `name`                   | string  | Name of the connectivity configuration.             | -       | Yes      |
| `location`               | string  | Azure region of the configuration.                   | -       | Yes      |
| `description`            | string  | Description of the connectivity configuration.       | -       | No       |
| `networkGroupIds`        | array   | Array of resource IDs for local network groups.      | -       | Yes      |
| `remoteNetworkGroupIds`  | array   | Array of resource IDs for remote network groups.     | `[]`    | No       |
| `allowForwardedTraffic`  | bool    | Allow forwarded traffic flag.                         | `false` | No       |
| `allowGatewayTransit`    | bool    | Allow gateway transit flag.                           | `false` | No       |
| `useRemoteGateways`      | bool    | Use remote gateways flag.                             | `false` | No       |

---

### Routing Configurations

| Name                     | Type   | Description                                            | Default | Required |
|--------------------------|--------|--------------------------------------------------------|---------|----------|
| `routingConfigurations`  | array  | Routing configuration objects defining routing policies. | `[]`    | No       |

#### Routing Configuration Properties

| Name                    | Type    | Description                                         | Default | Required |
|-------------------------|---------|-----------------------------------------------------|---------|----------|
| `name`                  | string  | Name of the routing configuration.                   | -       | Yes      |
| `location`              | string  | Azure region of the routing configuration.           | -       | Yes      |
| `description`           | string  | Description of the routing configuration.             | -       | No       |
| `networkGroupIds`       | array   | Array of resource IDs for network groups associated with the routing config. | -       | Yes      |
| `associatedRouteTables` | array   | Array of resource IDs for associated route tables.    | `[]`    | No       |

---

### Security Admin Configurations

| Name                       | Type   | Description                                             | Default | Required |
|----------------------------|--------|---------------------------------------------------------|---------|----------|
| `securityAdminConfigurations` | array | Security admin configuration objects defining network security rules. | `[]`    | No       |

#### Security Admin Configuration Properties

| Name                     | Type   | Description                                             | Default | Required |
|--------------------------|--------|---------------------------------------------------------|---------|----------|
| `name`                   | string | Name of the security admin configuration.               | -       | Yes      |
| `location`               | string | Azure region of the security configuration.             | -       | Yes      |
| `description`            | string | Description of the security configuration.               | -       | No       |
| `networkGroupIds`        | array  | Array of resource IDs for network groups under security admin control. | -       | Yes      |
| `adminRules`             | array  | Array of admin rule objects defining security rules.    | `[]`    | No       |

##### Admin Rule Properties

| Name                 | Type    | Description                                    | Default | Required |
|----------------------|---------|------------------------------------------------|---------|----------|
| `name`               | string  | Name of the admin rule.                         | -       | Yes      |
| `description`        | string  | Description of the rule.                         | -       | No       |
| `priority`           | int     | Priority of the rule (lower is higher priority). | -       | Yes      |
| `action`             | string  | Action to take: `Allow` or `Deny`.              | -       | Yes      |
| `sourceAddressPrefix`| string  | Source address prefix for the rule.              | -       | Yes      |
| `destinationAddressPrefix` | string | Destination address prefix for the rule.      | -       | Yes      |
| `protocol`           | string  | Protocol for the rule (e.g., `Tcp`, `Udp`, `*`).| -       | Yes      |
| `direction`          | string  | Direction of traffic: `Inbound` or `Outbound`.  | -       | Yes      |

---

### Diagnostic Settings

| Name                | Type   | Description                                        | Default | Required |
|---------------------|--------|----------------------------------------------------|---------|----------|
| `diagnosticSettings` | array  | Diagnostic settings for logging and monitoring.    | `[]`    | No       |

#### Diagnostic Setting Properties

| Name                         | Type   | Description                                                  | Default | Required |
|------------------------------|--------|--------------------------------------------------------------|---------|----------|
| `name`                       | string | Name of the diagnostic setting.                              | -       | Yes      |
| `metricCategories`           | array  | List of metric category objects to monitor.                   | -       | No       |
| `eventHubName`               | string | Name of the Event Hub to send diagnostics to.                | -       | No       |
| `eventHubAuthorizationRuleResourceId` | string | Resource ID for Event Hub authorization rule.             | -       | No       |
| `storageAccountResourceId`   | string | Resource ID for storage account to store diagnostics.         | -       | No       |
| `workspaceResourceId`        | string | Resource ID for Log Analytics workspace.                      | -       | No       |

##### Metric Category Properties

| Name      | Type   | Description                         | Default | Required |
|-----------|--------|-------------------------------------|---------|----------|
| `category`| string | Category of metrics to collect.     | -       | Yes      |

---

## Outputs

| Name                            | Type    | Description                                      |
|--------------------------------|---------|------------------------------------------------|
| `virtualNetworkId`              | string  | The resource ID of the deployed Virtual Network. |
| `localNetworkGatewayId`         | string  | The resource ID of the deployed Local Network Gateway. |
| `ipamPoolIds`                  | array   | Array of resource IDs for the deployed IPAM pools. |
| `networkGroupIds`               | array   | Array of resource IDs for the deployed network groups. |
| `connectivityConfigurationIds` | array   | Array of resource IDs for the connectivity configurations. |
| `routingConfigurationIds`      | array   | Array of resource IDs for the routing configurations. |
| `securityAdminConfigurationIds`| array   | Array of resource IDs for the security admin configurations. |
| `diagnosticSettingIds`          | array   | Array of resource IDs for the diagnostic settings. |

---

## Resources deployed

| Type                                                        | API Version         | Description                         |
|-------------------------------------------------------------|---------------------|-----------------------------------|
| `Microsoft.Network/virtualNetworks`                         | `2022-07-01`        | Virtual Network resource.          |
| `Microsoft.Network/localNetworkGateways`                    | `2022-07-01`        | Local Network Gateway resource.    |
| `Microsoft.Network/ipamPools`                               | `2022-07-01`        | IPAM Pool resource for IP address management. |
| `Microsoft.Network/networkGroups`                           | `2022-07-01`        | Network Group resource.             |
| `Microsoft.Network/connectivityConfigurations`              | `2022-07-01`        | Connectivity Configuration resource. |
| `Microsoft.Network/routingConfigurations`                   | `2022-07-01`        | Routing Configuration resource.    |
| `Microsoft.Network/securityAdminConfigurations`             | `2022-07-01`        | Security Admin Configuration resource. |
| `Microsoft.Insights/diagnosticSettings`                     | `2021-05-01-preview`| Diagnostic settings for monitoring and logging. |

---

## References

- Azure Virtual Network Manager documentation: https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-manager-overview
- Azure Bicep documentation: https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/
- Azure Well-Architected Framework: https://learn.microsoft.com/en-us/azure/architecture/framework/
- AVM Bicep modules GitHub repository: https://github.com/aidanfinn/avm
