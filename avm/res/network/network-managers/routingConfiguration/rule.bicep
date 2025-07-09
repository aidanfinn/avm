// Copyright (c) Cloud Mechanix
// Licensed under the MIT License.

metadata name = 'Network Manager Rules Collection'
metadata description = 'Deploys one or more Rules to a Rules Collections in a Routing Configurations for Azure Network Manager.'

// ============= //
// Parameters    //
// ============= //

@sys.description('Mandatory. The name of the parent Routing Configuration in Azure Network Manager.')
param ruleCollectionName string

@sys.description('Mandatory. The Rule to deploy.')
param rule ruleType

// ================//
// Deployments     //
// ================//

resource ruleModule 'Microsoft.Network/networkManagers/routingConfigurations/ruleCollections/rules@2024-05-01' = {
  name: '${ruleCollectionName}/${rule.name}'
  properties: {
    description: rule.?description ?? ''
    destination: rule.?destination ?? {}
    nextHop: rule.?nextHop ?? {}
  }
}

// ================//
// Outputs         //
// ================//

@sys.description('The ID of the deployed rule module.')
output id string = ruleModule.id

@sys.description('The name of the deployed rule module.')
output name string = ruleModule.name

// =============== //
//   Definitions   //
// =============== //

@sys.description('Defines the structure of a rule type.')
type ruleType = {
  @sys.description('The name of the rule.')
  name: string

  @sys.description('The description of the rule.')
  description: string?

  @sys.description('The list of network groups to which this rule applies.')
  destination: ruleDestinationType?

  @sys.description('The list of next hop configurations for the rule.')
  nextHop: nextHopType?
}

@sys.description('Defines the structure of a rule destination.')
type ruleDestinationType = {
  @sys.description('The type of the destination address.')
  destinationAddress: string

  @sys.description('The type of the destination address prefix or service tag. Defaults to "AddressPrefix".')
  type: 'AddressPrefix' | 'ServiceTag'
}

type nextHopType = {
  @sys.description('The type of the next hop.')
  nextHopType: 'Internet' | 'NoNextHop' | 'VirtualAppliance' | 'VirtualNetworkGateway' | 'VnetLocal'

  @sys.description('The IP address of the next hop if the type is VirtualAppliance.')
  nextHopAddress: string?
}
