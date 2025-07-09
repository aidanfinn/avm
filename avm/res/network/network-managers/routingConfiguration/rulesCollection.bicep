// Copyright (c) Cloud Mechanix
// Licensed under the MIT License.

metadata name = 'Network Manager Rules Collection'
metadata description = 'Deploys one or more Rules Collections to a Routing Configurations for Azure Network Manager.'

// ============= //
// Parameters    //
// ============= //

@sys.description('The name of the parent Routing Configuration in Azure Network Manager.')
param routingConfigName string

@sys.description('The Rule Collection to deploy.')
param ruleCollection ruleCollectionType

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

module rulesModule 'rule.bicep' = [for rule in ruleCollection.?rules!: {
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
  for (i, rule) in range(0, length(ruleCollection.?rules!)): {
    id: rulesModule[i].outputs.id
    name: rulesModule[i].outputs.name
  }
]

// =============== //
//   Definitions   //
// =============== //

@sys.description('Defines the Rules Collections of a Routing Configuration')
type ruleCollectionType = {
  @sys.description('The name of the rule collection.')
  name: string

  @sys.description('The description of the rule collection.')
  description: string?

  @sys.description('The list of network groups to which this rule collection applies.')
  appliesTo: rulesCollectionAppliesToType[]?

  @sys.description('Indicates whether BGP route propagation is disabled.')
  disableBgpRoutePropagation: 'False' | 'True'

  @sys.description('The list of peering route propagation rules.')
  peeringRoutePropagationRules: rulesCollectionPeeringRoutePropagationRulesType[]?

  @sys.description('Defines the structure of a rule type.')
  rules: ruleType[]?
}

@sys.description('Defines the structure of a rules collection applies to type.')
type rulesCollectionAppliesToType = {
  @sys.description('The ID of the network group to which this rule collection applies.')
  networkGroupId: string
}

@sys.description('Defines the structure of a peering route propagation rule.')
type rulesCollectionPeeringRoutePropagationRulesType = {
  propagationOption: 'Default' | 'DisableAllPeeringPrefixes'
}

@sys.description('Defines the structure of a rule type.')
type ruleType = {
  @sys.description('The name of the rule.')
  name: string

  @sys.description('The description of the rule.')
  description: string?

  @sys.description('The list of network groups to which this rule applies.')
  destination: ruleDestinationType?

  @sys.description('The list of next hop configurations for the rule.')
  nextHop: nextHopType?
}

@sys.description('Defines the structure of a rule destination.')
type ruleDestinationType = {
  @sys.description('The type of the destination address.')
  destinationAddress: string

  @sys.description('The type of the destination address prefix or service tag. Defaults to "AddressPrefix".')
  type: 'AddressPrefix' | 'ServiceTag'
}

type nextHopType = {
  @sys.description('The type of the next hop.')
  nextHopType: 'Internet' | 'NoNextHop' | 'VirtualAppliance' | 'VirtualNetworkGateway' | 'VnetLocal'

  @sys.description('The IP address of the next hop if the type is VirtualAppliance.')
  nextHopAddress: string?
}
