// Microsoft.Network/networkManagers/connectivityConfigurations@2024-07-01

@export()
@sys.description('Defines the structure of a connectivity configuration.')
type connectivityConfigurationType = {
  @sys.description('Mandatory. The name of the connectivity configuration.')
  @minLength(1)
  name: string

  @sys.description('Mandatory. An array of group resource IDs to which the configuration applies.')
  appliesToGroups: connectivityConfigurationAppliesToGroupsType[]

  @sys.description('Optional. Defines the capabilities of a connectivity configuration in Azure Network Manager.')
  connectivityCapabilities: connectivityConfigurationCapabilitiesType?

  @sys.description('Optional. The connectivity topology HubAndSpoke | Mesh. Default = HubAndSpoke.')
  connectivityTopology: 'HubAndSpoke' | 'Mesh'

  @sys.description('Optional. Indicates whether to delete existing peering configurations when applying this connectivity configuration. Default = False.')
  deleteExistingPeering: 'True' | 'False'
  @sys.description('The description of the connectivity configuration.')
  description: string

  @sys.description('Optional. An array of hub resource IDs.')
  hubs: connectivityConfigurationHubType[]?

  @sys.description('Optional. Flag if global mesh is supported. Default = False.')
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
  @sys.description('Mandatory. The resource Id of the hub.')
  resourceId: string

  @sys.description('Mandatory. Hub type: virtualNetwork | virtualHub.')
  resourceType: 'virtualNetwork' | 'virtualHub'
}

@export()
@sys.description('An array of group resource IDs to which the configuration applies.')
type connectivityConfigurationAppliesToGroupsType = {
  @sys.description('Mandatory. Group connectivity type.')
  groupConnectivity: 	'DirectlyConnected' | 'None'

  @sys.description('Optional. Flag if global is supported.')
  isGlobal: 'False' | 'True'?

  @sys.description('Mandatory. Network group Id.')
  networkGroupName: string

  @sys.description('Optional. Flag if Hub Virtual Network Gateway or Azure Route Server is used.')
  useHubGateway: 'False' | 'True'?
}
