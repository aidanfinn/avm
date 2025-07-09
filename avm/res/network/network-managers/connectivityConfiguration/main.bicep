// File: avm/res/network/network-managers/connectivityConfiguration/main.bicep

@description('The name of the parent Network Manager resource.')
param networkManagerName string

@description('Array of connectivity configurations to deploy.')
param connectivityConfigurations array

// Deploy connectivity configurations using a loop
resource connectivityConfiguration 'Microsoft.Network/networkManagers/connectivityConfigurations@2024-05-01' = [for config in connectivityConfigurations: {
  name: '${networkManagerName}/${config.name}'
  properties: {
    appliesToGroups: config.appliesToGroups
    connectivityTopology: config.connectivityTopology
    hubs: config.hubs ?? null
    isGlobal: config.isGlobal ?? false
    deleteExistingPeering: config.deleteExistingPeering ?? false
    description: config.description ?? null
  }
}]

// Outputs
output names array = [for config in connectivityConfigurations: config.name]
output resourceIds array = [for (i, config) in connectivityConfigurations: connectivityConfiguration[i].id]
