// Copyright (c) Cloud Mechanix
// Licensed under the MIT License.

metadata name = 'Network Manager IPAM Pools'
metadata description = 'Deploys one or more IPAM Pools for Azure Network Manager.'

// ============= //
// Parameters    //
// ============= //

@sys.description('Optional. Location for all resources.')
param location string = resourceGroup().location

@sys.description('Optional. List of IPAM pools to create under the Network Manager.')
param ipamPools ipamPoolType[]

@sys.description('Mandatory. The name of the Azure Network Manager resource. Must be 1-80 characters, using only a-z, A-Z, 0-9, _, ., or -. Regex: ^[a-zA-Z0-9_.-]+$')
param networkManagerName string 

// ================//
// Deployments     //
// ================//

resource networkManager 'Microsoft.Network/networkManagers@2024-05-01' existing =  {
  name: networkManagerName
}

resource ipamPoolsRes 'Microsoft.Network/networkManagers/ipamPools@2024-05-01' = [for pool in ipamPools: {
  parent: networkManager
  name: pool.name
  location: pool.?location ?? location
  tags: pool.?tags ?? {}
  properties: {
    addressPrefixes: pool.addressPrefixes
    description: pool.?description ?? ''
    displayName: pool.?displayName ?? pool.name
    parentPoolName: pool.?parentPoolName  ?? ''
  }
}]

// ================//
// Outputs         //
// ================//

@sys.description('An array of objects containing the resource ID, name, and address prefixes for each deployed IPAM pool(s).')
output ipamPools array = [
  for (i, pool) in ipamPools: {
    id: ipamPoolsRes[pool].id
    name: ipamPoolsRes[pool].name
    addressPrefixes: ipamPoolsRes[pool].properties.addressPrefixes
  }
]

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
