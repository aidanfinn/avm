# Bicep Module: Network Manager IPAM Pool

## Module Metadata

- **Name**: Network Manager IPAM Pool
- **Description**: Deploys an IPAM Pool for Azure Network Manager.
- **Version**: N/A (no versioning specified in source)
- **Owner**: Cloud Mechanix
- **License**: MIT

---

## Parameters

| Name                | Type    | Required | Description                                                 |
|---------------------|---------|----------|-------------------------------------------------------------|
| `networkManagerName`| string  | Yes      | The name of the parent Azure Network Manager.               |
| `location`          | string  | Yes      | The location of the parent resource.                        |
| `ipamPool`          | object  | Yes      | The IPAM pool configuration to deploy (defined in type `ipamPoolType`). |

---

## Resources Deployed

### `Microsoft.Network/networkManagers/ipamPools@2024-05-01`

| Property         | Value / Expression                                      |
|------------------|---------------------------------------------------------|
| `name`           | `${networkManagerName}/${ipamPool.name}-ipamPool`       |
| `location`       | `ipamPool.location ?? location`                         |
| `tags`           | `ipamPool.tags ?? {}`                                   |
| `properties`     |                                                         |
| - `addressPrefixes`  | `ipamPool.addressPrefixes`                         |
| - `description`      | `ipamPool.description ?? ''`                       |
| - `displayName`      | `ipamPool.displayName ?? ipamPool.name`            |
| - `parentPoolName`   | `ipamPool.parentPoolName ?? ''`                    |

---

## Outputs

| Name              | Type   | Description                                |
|-------------------|--------|--------------------------------------------|
| `id`              | string | The resource ID of the IPAM Pool.          |
| `name`            | string | The name of the IPAM Pool.                 |
| `addressPrefixes` | array  | The address prefixes of the IPAM Pool.     |

---

## Notes

- This module expects an external type definition for `ipamPoolType`, which must include properties like `name`, `location`, `tags`, `addressPrefixes`, `description`, `displayName`, and `parentPoolName`.
- The module supports conditional fallbacks using the null-conditional operator (`?`) for optional values.