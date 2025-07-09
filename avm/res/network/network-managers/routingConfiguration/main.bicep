// Copyright (c) Cloud Mechanix
// Licensed under the MIT License.

metadata name = 'Network Manager Routing Configuration'
metadata description = 'Deploys one or more Routing Configurations for Azure Network Manager.'

// ============= //
// Parameters    //
// ============= //

@sys.description('The name of the parent Azure Network Manager.')
param networkManagerName string

@sys.description('The routing configuration to deploy.')
param routingConfiguration routingConfigurationType

// ================//
// Deployments     //
// ================//

resource routingConfig 'Microsoft.Network/networkManagers/routingConfigurations@2024-05-01' = {
  name: '${networkManagerName}/${routingConfiguration.name}'
  properties: {
    description: routingConfiguration.?description ?? ''
  }
}

// ================//
// Outputs         //
// ================//

output id string = routingConfig.id
output name string = routingConfig.name

// =============== //
//   Definitions   //
// =============== //

@sys.description('Defines the structure of a routing configuration.')
type routingConfigurationType = {
  @sys.description('The name of the routing configuration.')
  name: string

  @sys.description('The description of the routing configuration.')
  description: string?

  @sys.description('The list of applicable network groups.')
  appliesToGroups: array

  @sys.description('The associated routing policy ID, if applicable.')
  routingPolicyId: string?
}
