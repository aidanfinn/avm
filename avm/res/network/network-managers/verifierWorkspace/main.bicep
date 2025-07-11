// Copyright (c) Cloud Mechanix
// Licensed under the MIT License.

metadata name = 'Network Manager Verifier Workspaces'
metadata description = 'Deploys a Verifier Workspace and optional reachability analysis intents for Azure Network Manager.'


// ============= //
// Parameters    //
// ============= //

@description('The name of the parent Network Manager resource.')
param networkManagerName string

import { verifierWorkspaceType } from '../types/network-managers-types.bicep'
@description('The Verifier Workspace resource to deploy.')
param verifierWorkspace verifierWorkspaceType

// ============= //
// Deployments   //
// ============= //

resource verifierWorkspaceResource 'Microsoft.Network/networkManagers/verifierWorkspaces@2024-07-01' = {
  name: '${networkManagerName}/${verifierWorkspace.name}'
  location: verifierWorkspace.location ?? resourceGroup().location
  tags: verifierWorkspace.?tags ?? null
  properties: verifierWorkspace.?properties
}

module intentsModule './intents.bicep' = [for intent in verifierWorkspace.?reachabilityAnalysisIntents ?? []: {
  name: '${networkManagerName}-${intent.name}'
  params: {
    intentConfig: intent
    verfierWorkspaceName: verifierWorkspaceResource.name
  }
}]

// ============= //
// Outputs       //
// ============= //

output verifierWorkspaceId string = verifierWorkspaceResource.id
output verifierWorkspaceName string = verifierWorkspaceResource.name
