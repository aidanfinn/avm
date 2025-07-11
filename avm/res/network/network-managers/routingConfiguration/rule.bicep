// Copyright (c) Cloud Mechanix
// Licensed under the MIT License.

metadata name = 'Network Manager Routing Rule'
metadata description = 'Deploys a Rule to a Rules Collection in a Routing Configurations for Azure Network Manager.'

// ============= //
// Parameters    //
// ============= //

@sys.description('Mandatory. The name of the parent Routing Configuration in Azure Network Manager.')
param ruleCollectionName string

import { routingConfigurationRuleType } from '../types/network-managers-types.bicep'
@sys.description('Mandatory. The Rule to deploy.')
param rule routingConfigurationRuleType

// ================//
// Deployments     //
// ================//

resource ruleModule 'Microsoft.Network/networkManagers/routingConfigurations/ruleCollections/rules@2024-05-01' = {
  name: '${ruleCollectionName}/${rule.name}'
  properties: union(
    {
      description: rule.?description ?? ''
    },
    rule.?destination != null
      ? {
          destination: rule.?destination
        }
      : {},
    rule.?nextHop != null
      ? {
          nextHop: rule.?nextHop
        }
      : {}
  )
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
