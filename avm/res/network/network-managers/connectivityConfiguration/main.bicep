// Copyright (c) Cloud Mechanix
// Licensed under the MIT License.

metadata name = 'Network Manager Connectivity Configuration'
metadata description = 'Deploys a Connectivity Configuration in Azure Network Manager.'

// ============= //
// Parameters    //
// ============= //

@description('The name of the parent Network Manager resource.')
param networkManagerName string

import { connectivityConfigurationType } from '../types/connectivityConfigurations.bicep'
@description('A Connectivity Configuration to deploy.')
param connectivityConfiguration connectivityConfigurationType

// ================//
// Deployments     //
// ================//
resource connectivityConfigurationModule 'Microsoft.Network/networkManagers/connectivityConfigurations@2024-07-01' = {
  name: '${networkManagerName}/${connectivityConfiguration.name}'
  properties: {
    description: connectivityConfiguration.description ?? ''
    connectivityTopology: connectivityConfiguration.connectivityTopology ?? 'HubAndSpoke'
    hubs: [
      for hub in (connectivityConfiguration.?hubs ?? []): {
        resourceType: hub.resourceType == 'virtualHub'
          ? 'Microsoft.Network/virtualHubs'
          : 'Microsoft.Network/virtualNetworks'
        resourceId: hub.resourceId
      }
    ]
    appliesToGroups: [
      for group in (connectivityConfiguration.?appliesToGroups ?? []):       {
        networkGroupId: resourceId(
          'Microsoft.Network/networkManagers/networkGroups',
          networkManagerName,
          group.networkGroupName
        )
        groupConnectivity: group.groupConnectivity
        useHubGateway: group.?useHubGateway ?? 'False'
        isGlobal: group.?isGlobal ?? 'False'
      }
    ]
    deleteExistingPeering: connectivityConfiguration.deleteExistingPeering ?? 'False'
    isGlobal: connectivityConfiguration.?isGlobal ?? 'False'
    connectivityCapabilities: {
      connectedGroupPrivateEndpointsScale: connectivityConfiguration.?connectivityCapabilities.connectedGroupPrivateEndpointsScale ?? 'Standard'
      connectedGroupAddressOverlap: connectivityConfiguration.?connectivityCapabilities.connectedGroupAddressOverlap ?? 'Allowed'
      peeringEnforcement: connectivityConfiguration.?connectivityCapabilities.peeringEnforcement ?? 'Unenforced'
    }
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
