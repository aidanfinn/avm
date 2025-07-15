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
