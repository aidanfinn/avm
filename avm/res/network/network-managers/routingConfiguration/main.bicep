// Copyright (c) Cloud Mechanix
// Licensed under the MIT License.

metadata name = 'Network Manager Routing Configuration'
metadata description = 'Deploys a Routing Configuration for Azure Network Manager.'

// ============= //
// Parameters    //
// ============= //

@sys.description('The name of the parent Azure Network Manager.')
param networkManagerName string

import { routingConfigurationType } from '../types/network-managers-types.bicep'
@sys.description('The routing configuration to deploy.')
param routingConfiguration routingConfigurationType

// ================//
// Deployments     //
// ================//

resource routingConfig 'Microsoft.Network/networkManagers/routingConfigurations@2024-05-01' = {
  name: '${networkManagerName}/${routingConfiguration.name}'
  properties: {
    description: routingConfiguration.?description ?? ''
  }
}

module ruleCollectionsModule 'rulesCollection.bicep' = [for ruleCollection in routingConfiguration.?ruleCollections ?? []: {
  name: '${routingConfig.name}-${ruleCollection.name}'
  params: {
    routingConfigName: routingConfig.name
    ruleCollection: ruleCollection
  }
}]

// ================//
// Outputs         //
// ================//

output id string = routingConfig.id
output name string = routingConfig.name

// =============== //
//   Definitions   //
// =============== //

