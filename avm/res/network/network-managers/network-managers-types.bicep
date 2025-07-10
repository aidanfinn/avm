
@export()
@sys.description('Defines the structure for an IPAM pool to be deployed under the Azure Network Manager.')
type ipamPoolType = {
  @sys.description('The name of the IPAM pool. Must be unique within the Network Manager. Must start with a letter or number and may contain letters, numbers, underscores (_), periods (.), and hyphens (-). The name must end with a letter, number, or underscore. Max length: 64.')
  name: string

  @sys.description('Optional. The Azure region where the IPAM pool will be created. Defaults to the resource group location if not specified.')
  location: string ?

  @sys.description('An array of CIDR address prefixes to assign to the IPAM pool. Example: ["10.0.0.0/16", "10.1.0.0/16"].')
  addressPrefixes: array

  @sys.description('Optional. A description for the IPAM pool, which can provide additional context for the resource.')
  description: string ?

  @sys.description('Optional. A friendly display name for the IPAM pool to use in the Azure Portal.')
  displayName: string ?

  @sys.description('Optional. The name of the parent IPAM pool, if creating a nested pool hierarchy.')
  parentPoolName: string ?

  @sys.description('Optional. A dictionary of resource tags to apply to the IPAM pool. Example: { "env": "prod", "costCenter": "1234" }')
  tags: object ?

  @sys.description('Optional. The provisioning state of the IPAM pool. This is generally managed by Azure and should not be set manually.')
  provisioningState: string ?
}

@export()
@sys.description('Defines the structure of a network group used with Azure Virtual Network Manager.')
type networkGroupType = {
  @sys.description('The name of the network group.')
  name: string

  @sys.description('The region where the network group is deployed. Must match the region of the Network Manager.')
  location: string

  @sys.description('A description of the network group.')
  description: string?

  @sys.description('The type of the group member.')
  memberType: 'Static' | 'Dynamic'

  @sys.description('The static list of member resources for the network group.')
  staticMemberResourceIds: networkGroupStaticMemberResourceType[]?
}

@export()
@sys.description('Defines a static member resource of a network group.')
type networkGroupStaticMemberResourceType = {
  @sys.description('The resource ID of the static member to be added to the network group.')
  resourceId: string
}

@export()
@sys.description('Defines the structure of a connectivity configuration.')
type connectivityConfigurationType = {
  @sys.description('The name of the connectivity configuration.')
  @minLength(1)
  name: string

  @sys.description('The description of the connectivity configuration.')
  description: string

  @sys.description('The connectivity topology (e.g., HubAndSpoke, Mesh).')
  connectivityTopology: 'HubAndSpoke' | 'Mesh'

  @sys.description('An array of hub resource IDs.')
  hubs: array

  @sys.description('Indicates whether the configuration is global.')
  isGlobal: 'bool | string'

  @sys.description('Indicates whether to delete existing peering configurations when applying this connectivity configuration.')
  deleteExistingPeering: 'bool | string'

  @sys.description('An array of group resource IDs to which the configuration applies.')
  appliesToGroups: array
}

@export()
@sys.description('Defines the structure of a routing configuration.')
type routingConfigurationType = {
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
  @sys.description('The name of the rule.')
  name: string

  @sys.description('The description of the rule.')
  description: string?

  @sys.description('The list of network groups to which this rule applies.')
  destination: routingConfigurationRuleDestinationType?

  @sys.description('The list of next hop configurations for the rule.')
  nextHop: routingConfigurationNextHopType?
}

@export()
@sys.description('Defines the structure of a rule destination.')
type routingConfigurationRuleDestinationType = {
  @sys.description('The type of the destination address.')
  destinationAddress: string

  @sys.description('The type of the destination address prefix or service tag. Defaults to "AddressPrefix".')
  type: 'AddressPrefix' | 'ServiceTag'
}

@export()
type routingConfigurationNextHopType = {
  @sys.description('The type of the next hop.')
  type: 'Internet' | 'NoNextHop' | 'VirtualAppliance' | 'VirtualNetworkGateway' | 'VnetLocal'

  @sys.description('The IP address of the next hop if the type is VirtualAppliance.')
  nextHopAddress: string?
}

@export()
@sys.description('Defines the structure of a Security Admin Configuration.')
type securityAdminConfigurationType = {
  @sys.description('Mandatory. The name of the Security Admin Configuration.')
  name: string

  @sys.description('Optional. The resource ID of the Security Admin Configuration.')
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
  @sys.description('Mandatory. The name of the rule.')
  name: string 

  @sys.description('Optional. The description of the rule. Custom or Default. Default = Default.')
  kind: 'Custom' | 'Default'?

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
  destinations: securityAdminConfigurationRulePropertiesAddressPrefxesType[]?

  @sys.description('Mandatory. Indicates if the direction of traffic that is managed. Inbound | Outbound.')
  direction: 'Inbound' | 'Outbound'

  @description('Mandatory. Indicates the priority of the rule. Must be an integer between 1 and 4096.')
  priority: int

  @sys.description('Mandatory. The protocol for the rule. Ah | Any | Esp | Icmp | Tcp | Udp.') 
  protocol: 'Ah' | 'Any' | 'Esp' | 'Icmp' | 'Tcp' | 'Udp'
  
  @sys.description('Optional. An array of source port ranges for the rule.')
  sourcePortRanges: string[]?

  @sys.description('Optional. The source address prefixes. CIDR or destination IP ranges.')
  sources: securityAdminConfigurationRulePropertiesAddressPrefxesType[]?
}

@export()
@sys.description('Defines the The destination address prefixes. CIDR or destination IP ranges..')
type securityAdminConfigurationRulePropertiesAddressPrefxesType = {
  @sys.description('Mandatory. Address prefix.')
  addressPrefix: 'string'

  @sys.description('Mandatory. The type of the address prefix. IPPrefix | NetworkGroup | ServiceTag.')
  addressPrefixType: 'IPPrefix' | 'NetworkGroup' | 'ServiceTag'
}
