// Copyright (c) Cloud Mechanix
// Licensed under the MIT License.

metadata name = 'Network Manager Verifier Workspace Intent'
metadata description = 'Deploys an Intent for a Verifier Workspace in Azure Network Manager.'

// ============= //
// Parameters    //
// ============= //

import { verifierWorkspaceReachabilityAnalysisIntents } from '../types/network-managers-types.bicep'
@description('Mandatory. The Verifier Workspace resource to deploy.')
param intentConfig verifierWorkspaceReachabilityAnalysisIntents

@description('Mandatory. The name of the Verifier Workspace resource.')
param verfierWorkspaceName string

// ============= //
// Deployments   //
// ============= //

resource intents 'Microsoft.Network/networkManagers/verifierWorkspaces/reachabilityAnalysisIntents@2024-07-01' = {
  name: '${verfierWorkspaceName}}/${intentConfig.name}'
  properties: {
    description: intentConfig.?description ?? null
    destinationResourceId: intentConfig.destinationResourceId
    ipTraffic: intentConfig.ipTraffic
    sourceResourceId: intentConfig.sourceResourceId
  }
}

// ============= //
// Outputs       //
// ============= //

output id string = intents.id
output name string = intents.name
