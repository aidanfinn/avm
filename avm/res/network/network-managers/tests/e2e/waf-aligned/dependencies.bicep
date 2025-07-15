@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

var hubVnetConfig =   {
  name: 'dep-hub-vnet'
  addressPrefix: '10.1.0.0/22'
}

// Define VNets with base address spaces
var spokeVnetConfigs = [
  {
    name: 'dep-spoke1-vnet'
    addressPrefix: '10.1.10.0/24'
  }
  {
    name: 'dep-spoke2-vnet'
    addressPrefix: '10.1.11.0/24'
  }
  {
    name: 'dep-spoke3-vnet'
    addressPrefix: '10.1.12.0/24'
  }
]

// Number of subnets to create per VNet
var spokeSubnetCount = 2

resource hubVirtualNetwork 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  name: hubVnetConfig.name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        hubVnetConfig.addressPrefix
      ]
    }
    subnets: [
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: cidrSubnet(hubVnetConfig.addressPrefix, 27, 0)
        }
      }
      {
        name: 'AzureFirewallSubnet'
        properties: {
          addressPrefix: cidrSubnet(hubVnetConfig.addressPrefix, 24, 1)
        }
      }
    ]
  }
}

resource spokeVnets 'Microsoft.Network/virtualNetworks@2023-09-01' = [for vnet in spokeVnetConfigs: {
  name: vnet.name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnet.addressPrefix
      ]
    }
    subnets: [for i in range(0, spokeSubnetCount - 1): {
      name: 'subnet${i + 1}'
      properties: {
        addressPrefix: cidrSubnet(vnet.addressPrefix, 26, i)
      }
    }]
  }
}]

@description('The resource ID of the created Virtual Network.')
output hubVirtualNetworkResourceId string = hubVirtualNetwork.id

@description('An array of resource IDs for the created spoke VNets.')
output spokeVnetResourceIds array = [
  for (i, spokeVnet) in range(0, length(spokeVnetConfigs)): {
    id: spokeVnets[i].id
  }
]
