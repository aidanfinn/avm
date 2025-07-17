// Microsoft.Network/networkManagers@2024-07-01

@export()
type networkManagersType = {
  @sys.description('Mandatory. The resource name for the Network Manager.')
  name: string

  @sys.description('Optional. A description of the Network Manager.')
  description: string? 

  @sys.description('Optional. Define the features to enable in Network Manager. Connectivity | Routing | SecurityAdmin. Default = None')
  networkManagerScopeAccesses: ('Connectivity' | 'Routing' | 'SecurityAdmin')[]?

  @sys.description('Optional. Define the Management Groups or Subscriptions that the Network Manager will manage. Defeault = current subscription')
  networkManagerScopes: networkManagerScopesType
}

@export()
type networkManagerScopesType = {
  @sys.description('Optional. List of management groups. Default = none')
  managementGroups: string[]?

  @sys.description('Optional. List of subscriptions. Default = current subscription.')
  subscriptions: string[]?
}

// Shared types used by Network Manager sub-resources

