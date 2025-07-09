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

@sys.description('Defines the structure of a connectivity configuration.')
type connectivityConfigurationType = {
  @sys.description('The name of the connectivity configuration.')
  @minLength(1)
  name: string

  @sys.description('The description of the connectivity configuration.')
  description: string

  @sys.description('The connectivity topology (e.g., HubAndSpoke, Mesh).')
  connectivityTopology: 'HubAndSpoke' | 'Mesh'

  @sys.description('An array of hub resource IDs.')
  hubs: array

  @sys.description('Indicates whether the configuration is global.')
  isGlobal: 'bool | string'

  @sys.description('Indicates whether to delete existing peering configurations when applying this connectivity configuration.')
  deleteExistingPeering: 'bool | string'

  @sys.description('An array of group resource IDs to which the configuration applies.')
  appliesToGroups: array
}
