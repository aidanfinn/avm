# Network Manager Connectivity Configuration Module

> **Module Name:** `Network Manager Connectivity Configuration`  
> **Description:** Deploys a Connectivity Configuration in Azure Network Manager.  
> **Author:** Cloud Mechanix  
> **License:** MIT  

---

## Parameters

| Name                    | Type                                | Required | Description |
|-------------------------|-------------------------------------|----------|-------------|
| `networkManagerName`    | `string`                            | ✅       | **Mandatory.** The name of the parent Network Manager resource. |
| `connectivityConfiguration` | `connectivityConfigurationType` | ✅       | **Mandatory.** A Connectivity Configuration to deploy. |

---

## Resources Deployed

### Microsoft.Network/networkManagers/connectivityConfigurations

Deploys a connectivity configuration under the specified Azure Network Manager. This resource configures connectivity topology and applies rules to network groups.

**Properties include:**

- `description`: Optional string. Defaults to an empty string if not provided.
- `connectivityTopology`: Optional. Defaults to `HubAndSpoke`.
- `hubs`: Array of hubs to use for connectivity.
  - `resourceType`: Either `Microsoft.Network/virtualHubs` or `Microsoft.Network/virtualNetworks`.
  - `resourceId`: Resource ID of the hub.
- `appliesToGroups`: Array of network groups the configuration applies to.
  - `networkGroupId`: Derived from `networkManagerName` and `networkGroupName`.
  - `groupConnectivity`: Type of connectivity between members.
  - `useHubGateway`: Optional, default `False`.
  - `isGlobal`: Optional, default `False`.
- `deleteExistingPeering`: Optional, default `False`.
- `isGlobal`: Optional, default `False`.
- `connectivityCapabilities`: Optional object:
  - `connectedGroupPrivateEndpointsScale`: Optional, default `Standard`.
  - `connectedGroupAddressOverlap`: Optional, default `Allowed`.
  - `peeringEnforcement`: Optional, default `Unenforced`.

---

## Outputs

| Name | Type | Description |
|------|------|-------------|
| `name` | `string` | The resource ID of the Connectivity Configuration. |
| `id`   | `string` | The name of the Connectivity Configuration. |

---

## Notes

- This module does **not** create a Network Manager or network groups. These must already exist.
- The module expects referenced network groups and hub resources to already be deployed and available.
