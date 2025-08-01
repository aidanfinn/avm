// Copyright (c) Cloud Mechanix
// Licensed under the MIT License.

metadata name = 'Network Manager Verifier Workspace Intent'
metadata description = 'Deploys an Intent for a Verifier Workspace in Azure Network Manager.'

// ============= //
// Parameters    //
// ============= //

import { verifierWorkspaceReachabilityAnalysisIntents } from '../types/verifierWorkspaces.bicep'
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
    description: intentConfig.?description ?? ''
    destinationResourceId: intentConfig.destinationResourceId
    ipTraffic: intentConfig.ipTraffic
    sourceResourceId: intentConfig.sourceResourceId
  }
}

// ============= //
// Outputs       //
// ============= //

@sys.description('The resource ID of the deployed intent.')
output id string = intents.id

@sys.description('The name of the deployed intent.')
output name string = intents.name
