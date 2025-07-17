// Copyright (c) Cloud Mechanix
// Licensed under the MIT License.

metadata name = 'Network Manager Verifier Workspaces'
metadata description = 'Deploys a Verifier Workspace and optional reachability analysis intents for Azure Network Manager.'


// ============= //
// Parameters    //
// ============= //

@description('The name of the parent Network Manager resource.')
param networkManagerName string

import { verifierWorkspaceType } from '../types/verifierWorkspaces.bicep'
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

@sys.description('The resource ID of the Verifier Workspace.')
output id string = verifierWorkspaceResource.id

@sys.description('The name of the Verifier Workspace.')
output name string = verifierWorkspaceResource.name

@sys.description('The rules of the Rule Collection.')
output reachabilityAnalysisIntents array = [
  for (i, rule) in range(0, length(verifierWorkspace.?reachabilityAnalysisIntents ?? [])): {
    id: intentsModule[i].outputs.id
    name: intentsModule[i].outputs.name
  }
]
