// Copyright (c) Cloud Mechanix
// Licensed under the MIT License.

metadata name = 'Network Manager Routing Configuration'
metadata description = 'Deploys a Routing Configuration for Azure Network Manager.'

// ============= //
// Parameters    //
// ============= //

@sys.description('The name of the parent Azure Network Manager.')
param networkManagerName string

import { routingConfigurationType } from '../types/routingConfigurations.bicep'
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

module ruleCollectionModules 'ruleCollection.bicep' = [
  for (ruleCollection, i) in (routingConfiguration.?ruleCollections ?? []): {
  name: 'ruleCollectionModules-${i}'
  params: {
    routingConfigurationName: routingConfig.name
    ruleCollection: ruleCollection
  }
}]

// ================//
// Outputs         //
// ================//

@sys.description('The resource ID of the Routing Configuration.')
output id string = routingConfig.id

@sys.description('The name of the Routing Configuration.')
output name string = routingConfig.name

@sys.description('The rule collections of the Routing Configuration.')
output ruleCollections array = [
  for (i, ruleCollection) in range(0, length(routingConfiguration.?ruleCollections ?? [])): {
    id: ruleCollectionModules[i].outputs.id
    name: ruleCollectionModules[i].outputs.name
    rules: ruleCollectionModules[i].outputs.rules
  }
]

// =============== //
//   Definitions   //
// =============== //
