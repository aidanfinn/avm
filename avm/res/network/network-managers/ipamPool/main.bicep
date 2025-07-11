// Copyright (c) Cloud Mechanix
// Licensed under the MIT License.

metadata name = 'Network Manager IPAM Pool'
metadata description = 'Deploys an IPAM Pool for Azure Network Manager.'

// ============= //
// Parameters    //
// ============= //

@description('The name of the parent Azure Network Manager.')
param networkManagerName string

@description('The location of the parent resource.')
param location string

import { ipamPoolType } from '../types/network-managers-types.bicep'
@description('The IPAM pool configuration to deploy.')
param ipamPool ipamPoolType

// ================//
// Deployments     //
// ================//

resource ipamPoolRes 'Microsoft.Network/networkManagers/ipamPools@2024-05-01' = {
  name: '${networkManagerName}/${ipamPool.name}-ipamPool'
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
output addressPrefixes array = ipamPool.addressPrefixes

// =============== //
//   Definitions   //
// =============== //
