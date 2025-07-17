# Network Manager Network Groups Bicep Module

## Overview

This Bicep module deploys one or more **Network Groups** within an **Azure Network Manager** instance. It includes support for static members and sets appropriate metadata, tags, and properties.

---

## Metadata

- **Name**: `Network Manager Network Groups`
- **Description**: Deploys one or more Network Groups for Azure Network Manager.
- **License**: MIT (c) Cloud Mechanix

---

## Parameters

| Name                | Type   | Description                                                  | Required |
|---------------------|--------|--------------------------------------------------------------|----------|
| `networkManagerName`| string | Name of the parent Network Manager resource.                 | Yes      |
| `networkGroup`      | object | A `networkGroupType` object defining the Network Group.      | Yes      |

---

## Variables

| Name                     | Type    | Description                                                  |
|--------------------------|---------|--------------------------------------------------------------|
| `normalizedStaticMembers`| array   | Normalizes static member resource IDs to objects.            |

---

## Resources

### `Microsoft.Network/networkManagers/networkGroups`

Creates the Network Group resource under the specified Network Manager.

- **Name**: `${networkManagerName}/${networkGroup.name}`
- **Properties**:
  - `description`: Optional description.
  - `memberType`: The type of members (e.g., `VirtualNetwork`).

### `Microsoft.Network/networkManagers/networkGroups/staticMembers`

Creates one or more static members under the created Network Group.

- **Name**: `${networkGroup.name}-static-{i}`
- **Parent**: `networkGroupResource`
- **Properties**:
  - `resourceId`: The resource ID of the static member.

---

## Outputs

| Name        | Type   | Description                                |
|-------------|--------|--------------------------------------------|
| `id`        | string | The resource ID of the Network Group.      |
| `name`      | string | The name of the Network Group.             |

---

## Notes

- This module supports only **static** member addition. Dynamic group membership (by conditions) is not included.
- Ensure the `networkGroupType` parameter follows the AVM custom type standards.
