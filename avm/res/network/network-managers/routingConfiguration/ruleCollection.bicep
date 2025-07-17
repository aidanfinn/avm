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
    rule: {
      name: rule.name
    }
    ruleCollectionName: ruleCollectionResource.name
  }
}]

// ================//
// Outputs         //
// ================//

// =============== //
//   Definitions   //
// =============== //
