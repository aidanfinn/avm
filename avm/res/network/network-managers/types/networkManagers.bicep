// Microsoft.Network/networkManagers

@export()
type networkManagersType = {
  @sys.description('The resource name.')
  name: string

  @sys.description('A description of the network manager.')
  description: string? 

  @sys.description('Scope Access.')
  networkManagerScopeAccesses: string[]?

  @sys.description('Scope of Network Manager.')
  networkManagerScopes: networkManagerScopesType
}

@export()
type networkManagerScopesType = {
  @sys.description('List of management groups.')
  managementGroups: string[]?

  @sys.description('List of subscriptions.')
  subscriptions: string[]?
}
