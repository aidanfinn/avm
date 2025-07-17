// Microsoft.Network/networkManagers/securityAdminConfigurations@2024-07-01

@export()
@sys.description('Defines the structure of a Security Admin Configuration.')
type securityAdminConfigurationType = {
  @minLength(1)
  @maxLength(64)
  @sys.description('Mandatory. The name of the Security Admin Configuration.')
  name: string

  @sys.description('Optional. A description of the Security Admin Configuration.')
  description: string?

  @sys.description('Optional. Enum list of network intent policy based services to apply: All | AllowRulesOnly | None. Default = None.')
  applyOnNetworkIntentPolicyBasedServices: ('All' | 'AllowRulesOnly' | 'None')[]

  @sys.description('Optional. Determine update behavior for changes to network groups referenced within the rules in this configuration.: Manual | None. Default = None.')
  networkGroupAddressSpaceAggregationOption: 'Manual' | 'None'

  rulesCollections: securityAdminConfigurationRulesCollectionsType[]?
} 

@export()
@sys.description('Defines the Rules Collections of a Security Admin Configuration.')
type securityAdminConfigurationRulesCollectionsType = {
  @minLength(1)
  @maxLength(64)
  @sys.description('Mandatory. The name of the rule collection.')
  name: string

  @sys.description('Optional. Groups for configuration.')
  appliesToGroups: securityAdminConfigurationAppliesToGroupsType[]?

  @sys.description('Optional. The description of the rule collection.')
  description: string?

  @sys.description('Optional. The rules in the Rules Collection of a Security Admin Configuration.')
  rules: securityAdminConfigurationRuleType[]?
}

@export()
@sys.description('An array of network groups that this rule collection applies to.')
type securityAdminConfigurationAppliesToGroupsType = {
  @sys.description('Mandatory. The ID of the network group to which this rule collection applies.') 
  networkGroupId: string
}

@export()
@sys.description('Defines the structure of a rule type for Security Admin Configuration.')
type securityAdminConfigurationRuleType = {
  @minLength(1)
  @maxLength(64)
  @sys.description('Mandatory. The name of the rule.')
  name: string 

  @sys.description('Optional. The properties of the rule.')
  properties: securityAdminConfigurationRulePropertiesType
}

@export()
@sys.description('Defines the properties of a Security Admin Configuration Rule.')
type securityAdminConfigurationRulePropertiesType = {

  @sys.description('Mandatory. Indicates the access allowed for this particular rule. Allow | AlwaysAllow | Deny.')
  access: 'Allow' | 'AlwaysAllow' | 'Deny'

  @sys.description('Optional. The description of the rule.')
  description: string?

  @sys.description('Optional. An array of destination port ranges for the rule.')
  destinationPortRanges: string[]?

  @sys.description('Optional. The destination address prefixes. CIDR or destination IP ranges.')
  destinations: addressPrefixType[]?

  @sys.description('Mandatory. Indicates if the direction of traffic that is managed. Inbound | Outbound.')
  direction: 'Inbound' | 'Outbound'

  @description('Mandatory. Indicates the priority of the rule. Must be an integer between 1 and 4096.')
  @minValue(1)
  @maxValue(4096)
  priority: int

  @sys.description('Mandatory. The protocol for the rule. Ah | Any | Esp | Icmp | Tcp | Udp.') 
  protocol: 'Ah' | 'Any' | 'Esp' | 'Icmp' | 'Tcp' | 'Udp'
  
  @sys.description('Optional. An array of source port ranges for the rule.')
  sourcePortRanges: string[]?

  @sys.description('Optional. The source address prefixes. CIDR or destination IP ranges.')
  sources: addressPrefixType[]?
}


@export()
@sys.description('Defines an address prefix and its type.')
type addressPrefixType = {
  @sys.description('Mandatory. The address prefix value.')
  addressPrefix: string

  @sys.description('Mandatory. The type of address prefix. IPPrefix | NetworkGroup | ServiceTag.')
  addressPrefixType: 'IPPrefix' | 'NetworkGroup' | 'ServiceTag'
}
