// Copyright (c) Cloud Mechanix
// Licensed under the MIT License.

metadata name = 'Network Manager Routing Configuration Rule Collection'
metadata description = 'Deploys a Rule Collection in a Routing Configuration for Azure Network Manager.'

// ============= //
// Parameters    //
// ============= //

@sys.description('Mandatory. The name of the parent Routing Configuration.')
param routingConfigurationName string

import { routingConfigurationRuleCollectionType } from '../types/routingConfigurations.bicep'
@sys.description('Mandatory. The routing Rule Collection to deploy.')
param ruleCollection routingConfigurationRuleCollectionType

// ================//
// Deployments     //
// ================//

resource ruleCollectionResource 'Microsoft.Network/networkManagers/routingConfigurations/ruleCollections@2024-05-01' = {
  name: '${routingConfigurationName}/${ruleCollection.name}'
  properties: {
    appliesTo: [
      for group in (ruleCollection.?appliesToGroups ?? []): {
        networkGroupId: resourceId(
          'Microsoft.Network/networkManagers/networkGroups',
          split(routingConfigurationName, '/')[0],
          group.networkGroupName
        )
      }
    ]
    disableBgpRoutePropagation: ruleCollection.disableBgpRoutePropagation ?? 'True'
    description: ruleCollection.?description ?? ''
  }
}

module ruleModule 'rule.bicep' = [
  for (rule, i) in (ruleCollection.?rules ?? []): {
  name: 'rules-${i}'
  params: {
    rule: rule
    ruleCollectionName: ruleCollectionResource.name
  }
}]

// ================//
// Outputs         //
// ================//

@sys.description('The resource ID of the Rule Collection.')
output id string = ruleCollectionResource.id

@sys.description('The name of the Rule Collection')
output name string = ruleCollectionResource.name

@sys.description('The rules of the Rule Collection.')
output rules array = [
  for (i, rule) in range(0, length(ruleCollection.?rules ?? [])): {
    id: ruleModule[i].outputs.id
    name: ruleModule[i].outputs.name
  }
]


// =============== //
//   Definitions   //
// =============== //
