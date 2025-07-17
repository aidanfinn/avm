// Copyright (c) Cloud Mechanix
// Licensed under the MIT License.

metadata name = 'Network Manager Security Admin Rule'
metadata description = 'Deploys a Rule to a Security Admin Rules Collection in a Security Admin Configuration in Azure Network Manager.'

// ============= //
// Parameters    //
// ============= //

@sys.description('Mandatory. The name of the parent Routing Configuration in Azure Network Manager.')
param ruleCollectionName string

import { securityAdminConfigurationRuleType } from '../types/securityAdminConfigurations.bicep'
@sys.description('Mandatory. The Rule to deploy.')
param rule securityAdminConfigurationRuleType

// ================//
// Deployments     //
// ================//

resource ruleModule 'Microsoft.Network/networkManagers/securityAdminConfigurations/ruleCollections/rules@2024-07-01' = {
  name: '${ruleCollectionName}/${rule.name}'
  kind: 'Custom'
  properties: {
    access: rule.?access
    description: rule.?description ?? ''
    destinationPortRanges: rule.?destinationPortRanges ?? []
    destinations: rule.?destinations ?? []
    direction: rule.?direction
    priority: rule.?priority
    protocol: rule.?protocol
    sourcePortRanges: rule.?sourcePortRanges ?? []
    sources: rule.?sources ?? []
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
