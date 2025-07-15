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
