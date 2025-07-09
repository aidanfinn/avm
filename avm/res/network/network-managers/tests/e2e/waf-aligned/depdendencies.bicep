@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the Local Network Gateway to create.')
param localNetworkGatewayName string

var addressPrefix = '10.1.0.0/22'

// Define VNets with base address spaces
var spokeVnetConfigs = [
  {
    name: 'spoke1-vnet'
    addressPrefix: '10.1.10.0/24'
  }
  {
    name: 'spoke2-vnet'
    addressPrefix: '10.1.11.0/24'
  }
  {
    name: 'spoke3-vnet'
    addressPrefix: '10.1.12.0/24'
  }
]

// Number of subnets to create per VNet
var spokeSubnetCount = 2

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: cidrSubnet(addressPrefix, 25, 0)
        }
      }
    ]
  }
}

resource localNetworkGateway 'Microsoft.Network/localNetworkGateways@2024-07-01' = {
  name: localNetworkGatewayName
  location: location
  properties: {
    gatewayIpAddress: '100.100.100.100'
    localNetworkAddressSpace: {
      addressPrefixes: [
        '192.168.0.0/24'
      ]
    }
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
output vnetResourceId string = virtualNetwork.id

@description('The resource ID of the created Local Network Gateway.')
output localNetworkGatewayResourceId string = localNetworkGateway.id

@description('An array of resource IDs for the created spoke VNets.')
output spokeVnetResourceIds array = [
  for (i, spokeVnet) in range(0, length(spokeVnetConfigs)): {
    id: spokeVnets[i].id
  }
]
