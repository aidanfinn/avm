// Microsoft.Network/networkManagers/routingConfigurations@2024-09-01-preview

import { addressPrefixType } from './networkManagers.bicep'

@export()
@sys.description('Defines the structure of a routing configuration.')
type routingConfigurationType = {
  @minLength(1)
  @maxLength(64)
  @sys.description('The name of the routing configuration.')
  name: string

  @sys.description('The description of the routing configuration.')
  description: string?

  @sys.description('The list of applicable network groups.')
  ruleCollections: routingConfigurationRuleCollectionType[]?
}

@export()
@sys.description('Defines the Rules Collections of a Routing Configuration')
type routingConfigurationRuleCollectionType = {
  @minLength(1)
  @maxLength(64)
  @sys.description('The name of the rule collection.')
  name: string

  @sys.description('The description of the rule collection.')
  description: string?

  @sys.description('The list of network groups to which this rule collection applies.')
  appliesTo: routingConfigurationRulesCollectionAppliesToType[]?

  @sys.description('Indicates whether BGP route propagation is disabled.')
  disableBgpRoutePropagation: 'False' | 'True'

  @sys.description('The list of peering route propagation rules.')
  peeringRoutePropagationRules: routingConfigurationRulesCollectionPeeringRoutePropagationRulesType[]?

  @sys.description('Defines the structure of a rule type.')
  rules: routingConfigurationRuleType[]?
}

@export()
@sys.description('Defines the structure of a rules collection applies to type.')
type routingConfigurationRulesCollectionAppliesToType = {
  @sys.description('The ID of the network group to which this rule collection applies.')
  networkGroupId: string
}

@export()
@sys.description('Defines the structure of a peering route propagation rule.')
type routingConfigurationRulesCollectionPeeringRoutePropagationRulesType = {
  propagationOption: 'Default' | 'DisableAllPeeringPrefixes'
}

@export()
@sys.description('Defines the structure of a rule type.')
type routingConfigurationRuleType = {
  @minLength(1)
  @maxLength(64)
  @sys.description('The name of the rule.')
  name: string

  @sys.description('The description of the rule.')
  description: string?

  @sys.description('The list of network groups to which this rule applies.')
  destination: addressPrefixType?

  @sys.description('The list of next hop configurations for the rule.')
  nextHop: routingConfigurationNextHopType?
}

@export()
type routingConfigurationNextHopType = {
  @sys.description('The type of the next hop.')
  type: 'Internet' | 'NoNextHop' | 'VirtualAppliance' | 'VirtualNetworkGateway' | 'VnetLocal'

  @sys.description('The IP address of the next hop if the type is VirtualAppliance.')
  nextHopAddress: string?
}
