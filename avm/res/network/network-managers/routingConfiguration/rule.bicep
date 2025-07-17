// Copyright (c) Cloud Mechanix
// Licensed under the MIT License.

metadata name = 'Network Manager Network Manager routing Rule.'
metadata description = 'Deploys a routing Rule in a Rule Collection in a Routing Configuration for Azure Network Manager.'

// ============= //
// Parameters    //
// ============= //

@sys.description('Mandatory. The name of the parent Rule Collection.')
param ruleCollectionName string

import { routingConfigurationRuleType } from '../types/routingConfigurations.bicep'
@sys.description('Mandatory. The routing Rule Collection to deploy.')
param rule routingConfigurationRuleType

// ================//
// Deployments     //
// ================//

resource routingRuleResource 'Microsoft.Network/networkManagers/routingConfigurations/ruleCollections/rules@2024-05-01' = {
  name: '${ruleCollectionName}/${rule.name}'
  properties: {
    description: rule.?description ?? ''
    destination: {
      type: 'AddressPrefix'
      destinationAddress: '0.0.0.0/0'
    }
    nextHop: {
      nextHopType: 'VirtualAppliance'
      nextHopAddress: '10.1.1.4'
    }
  }
}

// ================//
// Deployments     //
// ================//

// ================//
// Outputs         //
// ================//

@sys.description('The resource ID of the routing Rule.')
output id string = routingRuleResource.id

@sys.description('The name of the routing Rule.')
output name string = routingRuleResource.name

// =============== //
//   Definitions   //
// =============== //
