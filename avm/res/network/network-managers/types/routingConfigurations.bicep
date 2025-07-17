// Microsoft.Network/networkManagers/routingConfigurations@2024-09-01-preview

@export()
@sys.description('Defines the structure of a routing configuration.')
type routingConfigurationType = {
  @minLength(1)
  @maxLength(64)
  @sys.description('Mandatory. The name of the routing configuration.')
  name: string

  @sys.description('Optional. The description of the routing configuration.')
  description: string?

  @sys.description('Optional. The list of applicable network groups.')
  ruleCollections: routingConfigurationRuleCollectionType[]?
}

@export()
@sys.description('Defines the Rules Collections of a Routing Configuration')
type routingConfigurationRuleCollectionType = {
  @minLength(1)
  @maxLength(64)
  @sys.description('Mandatory. The name of the rule collection.')
  name: string

  @sys.description('Optional. The description of the rule collection.')
  description: string?

  @sys.description('Optional. The list of network groups to which this rule collection applies.')
  appliesToGroups: routingConfigurationRulesCollectionappliesToGroupsType[]?

  @sys.description('Optional. Indicates whether BGP route propagation is disabled. True | False Default = True')
  disableBgpRoutePropagation: 'False' | 'True'

  @sys.description('Optional. The list of peering route propagation rules.')
  peeringRoutePropagationRules: routingConfigurationRulesCollectionPeeringRoutePropagationRulesType[]?

  @sys.description('Optional. Defines the structure of a rule type.')
  rules: routingConfigurationRuleType[]?
}

@export()
@sys.description('Defines the structure of a rules collection applies to type.')
type routingConfigurationRulesCollectionappliesToGroupsType = {
  @sys.description('Mandatory. The ID of the network group to which this rule collection applies.')
  networkGroupName: string
}

@export()
@sys.description('Mandatory. Defines the structure of a peering route propagation rule.')
type routingConfigurationRulesCollectionPeeringRoutePropagationRulesType = {
  propagationOption: 'Default' | 'DisableAllPeeringPrefixes'
}

@export()
@sys.description('Defines the structure of a rule type.')
type routingConfigurationRuleType = {
  @minLength(1)
  @maxLength(64)
  @sys.description('Mandatory. The name of the rule.')
  name: string

  @sys.description('Optional. The description of the rule.')
  description: string?

  @sys.description('Optional. The list of network groups to which this rule applies.')
  destination: destinationType?

  @sys.description('Optional. The list of next hop configurations for the rule.')
  nextHop: routingConfigurationNextHopType?
}

@export()
type routingConfigurationNextHopType = {
  @sys.description('Mandatory. The type of the next hop.')
  nextHopType: 'Internet' | 'NoNextHop' | 'VirtualAppliance' | 'VirtualNetworkGateway' | 'VnetLocal'

  @sys.description('Optional. The IP address of the next hop if the type is VirtualAppliance.')
  nextHopAddress: string?
}


@export()
@sys.description('Defines an address prefix and its type.')
type destinationType = {
  @sys.description('Mandatory. The address prefix value.')
  destinationAddress: string

  @sys.description('Mandatory. The type of address prefix. AddressPrefix | ServiceTag.')
  type: 'AddressPrefix' | 'ServiceTag'
}
