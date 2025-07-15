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
