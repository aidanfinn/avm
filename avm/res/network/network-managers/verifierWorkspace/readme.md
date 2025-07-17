
# Network Manager Verifier Workspaces

Deploys a Verifier Workspace and optional reachability analysis intents for Azure Network Manager.

---

## Parameters

| Name               | Type               | Description                                       | Required |
|--------------------|--------------------|-------------------------------------------------|----------|
| `networkManagerName`| `string`           | Mandatory. The name of the parent Network Manager resource. | Yes      |
| `verifierWorkspace`| `verifierWorkspaceType` | Mandatory. The Verifier Workspace resource to deploy. | Yes      |

---

## Deployments

### Resource: verifierWorkspaceResource

- **Type:** `Microsoft.Network/networkManagers/verifierWorkspaces@2024-07-01`
- **Name:** `${networkManagerName}/${verifierWorkspace.name}`
- **Location:** `verifierWorkspace.location` or resource group's location if not provided
- **Tags:** Optional tags from `verifierWorkspace`
- **Properties:**
  - `description`: Optional description, defaults to empty string

### Module: intentsModule (commented out)

- For each reachability analysis intent in `verifierWorkspace.reachabilityAnalysisIntents`, deploy a module `intents.bicep`.
- Parameters:
  - `intentConfig`: The intent config object
  - `verfierWorkspaceName`: Name of the verifier workspace resource

---

## Outputs

| Name                 | Type     | Description                          |
|----------------------|----------|------------------------------------|
| `id`                 | `string` | The resource ID of the Verifier Workspace. |
| `name`               | `string` | The name of the Verifier Workspace. |

<!-- 
// Uncomment below if intents module is used
| `reachabilityAnalysisIntents` | `array`  | Array of deployed reachability analysis intents with their IDs and names. |
-->

---

## Definitions

(Definitions are imported from `../types/verifierWorkspaces.bicep`)
