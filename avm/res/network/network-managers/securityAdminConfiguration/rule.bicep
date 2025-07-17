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
    access: rule.properties.?access
    description: rule.properties.?description ?? ''
    destinationPortRanges: rule.properties.?destinationPortRanges ?? []
    destinations: rule.properties.?destinations ?? []
    direction: rule.properties.?direction
    priority: rule.properties.?priority
    protocol: rule.properties.?protocol
    sourcePortRanges: rule.properties.?sourcePortRanges ?? []
    sources: rule.properties.?sources ?? []
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
