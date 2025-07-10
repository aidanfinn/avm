// Copyright (c) Cloud Mechanix
// Licensed under the MIT License.

metadata name = 'Network Manager Routing Rules Collection'
metadata description = 'Deploys a Rule Collection to a Routing Configuration in Azure Network Manager.'

// ============= //
// Parameters    //
// ============= //

@sys.description('The name of the parent Routing Configuration in Azure Network Manager.')
param routingConfigName string

import { routingConfigurationRuleCollectionType } from '../network-managers-types.bicep'
@sys.description('The Rule Collection to deploy.')
param ruleCollection routingConfigurationRuleCollectionType

// ================//
// Deployments     //
// ================//

resource ruleCollectionModule 'Microsoft.Network/networkManagers/routingConfigurations/ruleCollections@2024-09-01-preview' = {
  name: '${routingConfigName}/${ruleCollection.name}'
  properties: {
    appliesTo: ruleCollection.?appliesTo ?? []
    description: ruleCollection.?description ?? ''
    disableBgpRoutePropagation: ruleCollection.disableBgpRoutePropagation ?? 'True'
    peeringRoutePropagationRules: ruleCollection.?peeringRoutePropagationRules ?? []
  }
}

module rulesModule 'rule.bicep' = [for rule in ruleCollection.?rules ?? []: {
  name: rule.name
  params: {
    ruleCollectionName: ruleCollection.name
    rule: rule
  }
}]

// ================//
// Outputs         //
// ================//

@sys.description('The resource ID of the Rule Collection.')
output id string = ruleCollectionModule.id

@sys.description('The name of the Rule Collection')
output name string = ruleCollectionModule.name

@sys.description('The rules of the Rule Collection.')
output rules array = [
  for (i, rule) in range(0, length(ruleCollection.?rules ?? [])): {
    id: rulesModule[i].outputs.id
    name: rulesModule[i].outputs.name
  }
]

// =============== //
//   Definitions   //
// =============== //
