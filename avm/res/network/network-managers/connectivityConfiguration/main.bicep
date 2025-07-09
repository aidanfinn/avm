// Copyright (c) Cloud Mechanix
// Licensed under the MIT License.

metadata name = 'Network Manager Connectivity Configurations'
metadata description = 'Deploys one or more Connectivity Configurations for Azure Network Manager.'

// ============= //
// Parameters    //
// ============= //

@description('The name of the parent Network Manager resource.')
param networkManagerName string

@description('Array of connectivity configurations to deploy.')
param connectivityConfigurations array

// ================//
// Deployments     //
// ================//

resource connectivityConfiguration 'Microsoft.Network/networkManagers/connectivityConfigurations@2024-05-01' = [for config in connectivityConfigurations: {
  name: '${networkManagerName}/${config.name}'
  properties: {
    appliesToGroups: config.appliesToGroups
    connectivityTopology: config.connectivityTopology
    hubs: config.hubs ?? null
    isGlobal: config.isGlobal ?? false
    deleteExistingPeering: config.deleteExistingPeering ?? false
    description: config.description ?? null
  }
}]

// ================//
// Outputs         //
// ================//

output names array = [for config in connectivityConfigurations: config.name]
output resourceIds array = [for (i, config) in connectivityConfigurations: connectivityConfiguration[i].id]

// =============== //
//   Definitions   //
// =============== //
