// Microsoft.Network/networkManagers/ipamPools@2024-07-01

@export()
@sys.description('Defines the structure for an IPAM pool to be deployed under the Azure Network Manager.')
type ipamPoolType = {

  @minLength(1)
  @maxLength(64)
  @sys.description('The name of the IPAM pool. Must be unique within the Network Manager. Must start with a letter or number and may contain letters, numbers, underscores (_), periods (.), and hyphens (-). The name must end with a letter, number, or underscore. Max length: 64.')
  name: string

  @sys.description('Optional. The Azure region where the IPAM pool will be created. Defaults to the resource group location if not specified.')
  location: string ?

  @sys.description('An array of CIDR address prefixes to assign to the IPAM pool. Example: ["10.0.0.0/16", "10.1.0.0/16"].')
  addressPrefixes: array

  @sys.description('Optional. A description for the IPAM pool, which can provide additional context for the resource.')
  description: string ?

  @minLength(1)
  @maxLength(64)
  @sys.description('Optional. A friendly display name for the IPAM pool to use in the Azure Portal.')
  displayName: string ?

  @sys.description('Optional. The name of the parent IPAM pool, if creating a nested pool hierarchy.')
  parentPoolName: string ?

  @sys.description('Optional. A dictionary of resource tags to apply to the IPAM pool. Example: { "env": "prod", "costCenter": "1234" }')
  tags: object ?
}

// Microsoft.Network/networkManagers/networkGroups@2024-07-01

@export()
@sys.description('Defines the structure of a network group used with Azure Virtual Network Manager.')
type networkGroupType = {
  @minLength(1)
  @maxLength(64)
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

// Microsoft.Network/networkManagers/connectivityConfigurations@2024-07-01

@export()
@sys.description('Defines the structure of a connectivity configuration.')
type connectivityConfigurationType = {
  @sys.description('The name of the connectivity configuration.')
  @minLength(1)
  name: string

  @sys.description('An array of group resource IDs to which the configuration applies.')
  appliesToGroups: array

  @sys.description('Defines the capabilities of a connectivity configuration in Azure Network Manager.')
  connectivityCapabilities: connectivityConfigurationCapabilitiesType?

  @sys.description('The connectivity topology (e.g., HubAndSpoke, Mesh).')
  connectivityTopology: 'HubAndSpoke' | 'Mesh'

  @sys.description('Indicates whether to delete existing peering configurations when applying this connectivity configuration.')
  deleteExistingPeering: 'true' | 'false'

  @sys.description('The description of the connectivity configuration.')
  description: string

  @sys.description('An array of hub resource IDs.')
  hubs: connectivityConfigurationHubType[]?

  @sys.description('Flag if global mesh is supported.')
  isGlobal: 'False' | 'True'
}

@export()
@sys.description('Defines the capabilities of a connectivity configuration in Azure Network Manager.')
type connectivityConfigurationCapabilitiesType = {
  @sys.description('Mandatory. Behavior to handle overlapped IP address space among members of the connected group of the connectivity configuration. Allowed | Disallowed')
  connectedGroupAddressOverlap: 'Allowed' | 'Disallowed'

  @sys.description('Mandatory. Option indicating the scale of private endpoints allowed in the connected group of the connectivity configuration. Allowed | Disallowed')
  connectedGroupPrivateEndpointsScale: 'HighScale' | 'Standard'

  @sys.description('Mandatory. Option indicating enforcement of peerings created by the connectivity configuration. Allowed | Disallowed')
  peeringEnforcement: 'Enforced' | 'Unenforced'
}

@export()
@sys.description('A hub item.')
type connectivityConfigurationHubType = {
  @sys.description('Resource Id.')
  resourceId: string

  @sys.description('Resource Type.')
  resourceType: string
}

// Microsoft.Network/networkManagers/routingConfigurations@2024-09-01-preview

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
@sys.description('Defines an address prefix and its type.')
type addressPrefixType = {
  addressPrefix: string
  addressPrefixType: 'IPPrefix' | 'NetworkGroup' | 'ServiceTag'
}

@export()
type routingConfigurationNextHopType = {
  @sys.description('The type of the next hop.')
  type: 'Internet' | 'NoNextHop' | 'VirtualAppliance' | 'VirtualNetworkGateway' | 'VnetLocal'

  @sys.description('The IP address of the next hop if the type is VirtualAppliance.')
  nextHopAddress: string?
}

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
  priority: int

  @sys.description('Mandatory. The protocol for the rule. Ah | Any | Esp | Icmp | Tcp | Udp.') 
  protocol: 'Ah' | 'Any' | 'Esp' | 'Icmp' | 'Tcp' | 'Udp'
  
  @sys.description('Optional. An array of source port ranges for the rule.')
  sourcePortRanges: string[]?

  @sys.description('Optional. The source address prefixes. CIDR or destination IP ranges.')
  sources: addressPrefixType[]?
}

// Microsoft.Network/networkManagers/verifierWorkspaces@2024-07-01

@export()
@description('Defines a Verifier Workspace resource with optional intents and runs.')
type verifierWorkspaceType = {
  @minLength(1)
  @maxLength(64)
  @description('Mandatory. The name of the Verifier Workspace resource.')
  name: string

  @description('Mandatory. The Azure region for the resource.')
  location: string

  @sys.description('Optional. Properties of Verifier Workspace resource.')
  properties: verifierWorkspacePropertiesType

  @sys.description('Optional. A dictionary of resource tags to apply to the IPAM pool. Example: { "env": "prod", "costCenter": "1234" }')
  tags: object ?

  @sys.description('Optional. Define and test connectivity expectations between resources')
  reachabilityAnalysisIntents: verifierWorkspaceReachabilityAnalysisIntents[]?
}

@export()
@sys.description('Properties of Verifier Workspace resource.')
type verifierWorkspacePropertiesType = {
  @description('Optional. A description of the Verifier Workspace.')
  description: string
}

@export()
@sys.description('Define and test connectivity expectations between resources')
type verifierWorkspaceReachabilityAnalysisIntents = {
  @minLength(1)
  @maxLength(64)
  @sys.description('Mandatory. The name of the intent.')
  name: string

  @sys.description('Optional. The description of the Analysis Intent')
  description: string?

  @sys.description('Mandatory. Destination resource ID to verify the reachability path of.')
  destinationResourceId: string

  @sys.description('Mandatory. IP traffic information.')
  ipTraffic: verifierWorkspaceReachabilityAnalysisIntentsIpTraffic

  @sys.description('Mandatory. Source resource ID to verify the reachability path of.')
  sourceResourceId: string
}

@export()
@sys.description('IP traffic information for a Verifier Workspace Reachability Analysis Intent.')
type verifierWorkspaceReachabilityAnalysisIntentsIpTraffic = {
  @sys.description('Mandatory. List of destination IP addresses of the traffic.')
  destinationIps: string[]

  @sys.description('Mandatory. The destination ports of the traffic.')
  destinationPorts: string[]

  @sys.description('Mandatory. A string array containing any of Any | ICMP | TCP | UDP')
  protocols: verifierWorkspaceReachabilityAnalysisIntentsprotocolType[]

  @sys.description('Mandatory. List of source IP addresses of the traffic.')
  sourceIps: string[]

  @sys.description('Mandatory. The source ports of the traffic.')
  sourcePorts: string[]
}

@export()
@sys.description('Mandatory. A string array containing any of Any | ICMP | TCP | UDP')
type verifierWorkspaceReachabilityAnalysisIntentsprotocolType = 'Any' | 'ICMP' | 'TCP' | 'UDP'
