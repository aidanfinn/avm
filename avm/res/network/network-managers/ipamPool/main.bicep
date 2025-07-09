// Copyright (c) Cloud Mechanix
// Licensed under the MIT License.

metadata name = 'Network Manager IPAM Pools'
metadata description = 'Deploys one or more IPAM Pools for Azure Network Manager.'

// ============= //
// Parameters    //
// ============= //

@description('The name of the parent Azure Network Manager.')
param networkManagerName string

@description('The location of the parent resource.')
param location string

@description('The IPAM pool configuration to deploy.')
param ipamPool ipamPoolType


// ================//
// Deployments     //
// ================//

resource ipamPoolRes 'Microsoft.Network/networkManagers/ipamPools@2024-05-01' = {
  name: '${networkManagerName}/${ipamPool.name}-ipalmPool'
  location: ipamPool.?location ?? location
  tags: ipamPool.?tags ?? {}
  properties: {
    addressPrefixes: ipamPool.addressPrefixes
    description: ipamPool.?description ?? ''
    displayName: ipamPool.?displayName ?? ipamPool.name
    parentPoolName: ipamPool.?parentPoolName ?? ''
  }
}

// ================//
// Outputs         //
// ================//

output id string = ipamPoolRes.id
output name string = ipamPoolRes.name
output addressPrefixes array = ipamPoolRes.properties.addressPrefixes

// =============== //
//   Definitions   //
// =============== //


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
