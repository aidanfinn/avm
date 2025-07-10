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

// ================//
// Deployments     //
// ================//

resource connectivityConfigurationModule 'Microsoft.Network/networkManagers/connectivityConfigurations@2024-05-01' = {
  name: '${networkManagerName}/${connectivityConfiguration.name}'
  properties: {
    appliesToGroups: connectivityConfiguration.appliesToGroups ?? null
    connectivityTopology: connectivityConfiguration.connectivityTopology ?? 'HubAndSpoke'
    hubs: connectivityConfiguration.hubs ?? null
    isGlobal: connectivityConfiguration.isGlobal ?? false
    deleteExistingPeering: connectivityConfiguration.deleteExistingPeering ?? false
    description: connectivityConfiguration.description ?? null
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
