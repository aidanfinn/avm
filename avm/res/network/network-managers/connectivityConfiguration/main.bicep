// Copyright (c) Cloud Mechanix
// Licensed under the MIT License.

metadata name = 'Network Manager Connectivity Configuration'
metadata description = 'Deploys a Connectivity Configuration in Azure Network Manager.'

// ============= //
// Parameters    //
// ============= //

@description('The name of the parent Network Manager resource.')
param networkManagerName string

import { connectivityConfigurationType } from '../network-managers-types.bicep'
@description('A Connectivity Configuration to deploy.')
param connectivityConfiguration connectivityConfigurationType

// ============= //
// Variables     //
// ============= //

var resolvedConnectivityCapabilities = empty(connectivityConfiguration.?connectivityCapabilities) ? null : {
  connectedGroupAddressOverlap: connectivityConfiguration.?connectivityCapabilities.connectedGroupAddressOverlap ?? 'Disallowed'
  connectedGroupPrivateEndpointsScale: connectivityConfiguration.?connectivityCapabilities.connectedGroupPrivateEndpointsScale ?? 'Standard'
  peeringEnforcement: connectivityConfiguration.?connectivityCapabilities.peeringEnforcement ?? 'Enforced'
}

// ================//
// Deployments     //
// ================//

resource connectivityConfigurationModule 'Microsoft.Network/networkManagers/connectivityConfigurations@2024-07-01' = {
  name: '${networkManagerName}/${connectivityConfiguration.name}'
  properties: {
    connectivityTopology: connectivityConfiguration.connectivityTopology ?? 'HubAndSpoke'
    deleteExistingPeering: connectivityConfiguration.deleteExistingPeering ?? false
    isGlobal: connectivityConfiguration.isGlobal ?? false

    // Optional blocks conditionally included
    ...(empty(connectivityConfiguration.appliesToGroups) ? {} : {
      appliesToGroups: connectivityConfiguration.appliesToGroups
    })
    ...(empty(resolvedConnectivityCapabilities) ? {} : {
      connectivityCapabilities: resolvedConnectivityCapabilities
    })
    ...(empty(connectivityConfiguration.description) ? {} : {
      description: connectivityConfiguration.description
    })
    ...(empty(connectivityConfiguration.?hubs) ? {} : {
      hubs: connectivityConfiguration.?hubs
    })
  }
}

// ================//
// Outputs         //
// ================//

output name string = connectivityConfigurationModule.name
output id string = connectivityConfigurationModule.id

// =============== //
//   Definitions   //
// =============== //
