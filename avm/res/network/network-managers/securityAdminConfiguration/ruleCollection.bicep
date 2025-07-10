// Copyright (c) Cloud Mechanix
// Licensed under the MIT License.

metadata name = 'Network Manager Security Admin Rules Collection'
metadata description = 'Deploys a Security Admin Rule Collection to a Security Admin Configuration in Azure Network Manager.'

// ============= //
// Parameters    //
// ============= //

@sys.description('The name of the parent Security Admin Configuration in Azure Network Manager.')
param securityAdminConfigurationName string

import { securityAdminConfigurationRulesCollectionsType } from '../network-managers-types.bicep'
@sys.description('The Rule Collection to deploy.')
param ruleCollection securityAdminConfigurationRulesCollectionsType

// ================//
// Deployments     //
// ================//

resource ruleCollectionModule 'Microsoft.Network/networkManagers/securityAdminConfigurations/ruleCollections@2024-07-01' = {
  name: '${securityAdminConfigurationName}/${ruleCollection.name}'
  properties: {
    appliesToGroups: ruleCollection.?appliesToGroups ?? []
    description: ruleCollection.?description ?? ''
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
