// Copyright (c) Cloud Mechanix
// Licensed under the MIT License.

metadata name = 'Network Manager Verifier Workspace'
metadata description = 'Deploys a Verifier Workspace and its Intents/Runs in Azure Network Manager.'

// ============= //
// Parameters    //
// ============= //

@description('The name of the parent Network Manager resource.')
param networkManagerName string

@description('The Azure region where the Verifier Workspace will be deployed.')
param location string

import { verifierWorkspaceType } from '../network-managers-types.bicep'
@description('The Verifier Workspace resource to deploy.')
param verifierWorkspace verifierWorkspaceType

// ============= //
// Deployments   //
// ============= //

// Main Verifier Workspace resource
resource verifierWorkspaceResource 'Microsoft.Network/networkManagers/verifierWorkspaces@2024-07-01' = {
  name: '${networkManagerName}/${verifierWorkspace.name}'
  location: location
  tags: verifierWorkspace.tags
  properties: {}
}

// Deploy verifier intents if any
resource intents 'Microsoft.Network/networkManagers/verifierWorkspaces/intents@2024-07-01' = [for intent in verifierWorkspace.intents ?? []: {
  name: intent.name
  parent: verifierWorkspaceResource
  properties: {
    connectivityGroupId: intent.properties.connectivityGroupId
    destination: intent.properties.destination
    protocol: intent.properties.protocol
    destinationPort: intent.properties.destinationPort ?? null
    sourcePort: intent.properties.sourcePort ?? null
  }
}]


// ============= //
// Outputs       //
// ============= //

output verifierWorkspaceId string = verifierWorkspaceResource.id
output verifierWorkspaceName string = verifierWorkspaceResource.name
