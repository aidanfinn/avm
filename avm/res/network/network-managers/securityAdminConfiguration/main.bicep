// Copyright (c) Cloud Mechanix
// Licensed under the MIT License.

metadata name = 'Network Manager Security Admin Configuration'
metadata description = 'Deploys one or more Security Admin Configurations for Azure Network Manager.'

// ============= //
// Parameters    //
// ============= //

@sys.description('The name of the parent Azure Network Manager.')
param networkManagerName string

import { securityAdminConfigurationType } from '../types/securityAdminConfigurations.bicep'
@sys.description('The routing configuration to deploy.')
param securityAdminConfiguration securityAdminConfigurationType

// ================//
// Deployments     //
// ================//

resource securityAdminConfigurationModule 'Microsoft.Network/networkManagers/securityAdminConfigurations@2024-07-01' = {
  name: '${networkManagerName}/${securityAdminConfiguration.name}'
  properties: {
    description: securityAdminConfiguration.?description ?? ''
    applyOnNetworkIntentPolicyBasedServices: securityAdminConfiguration.?applyOnNetworkIntentPolicyBasedServices ?? ['None']
    networkGroupAddressSpaceAggregationOption: securityAdminConfiguration.?networkGroupAddressSpaceAggregationOption ?? 'None'
  }
}

module ruleCollectionModule './ruleCollection.bicep' = [for ruleCollection in securityAdminConfiguration.?ruleCollections ?? []: {
  name: '${networkManagerName}-${ruleCollection.name}'
  params: {
    securityAdminConfigurationName: securityAdminConfigurationModule.name
    ruleCollection: ruleCollection
  }
}]

// ================//
// Outputs         //
// ================//

@sys.description('The resource ID of the Security Admin Configuration.')
output id string = securityAdminConfigurationModule.id

@sys.description('The name of the Security Admin Configuration.')
output name string = securityAdminConfigurationModule.name

@sys.description('The rule collections of the Security Admin Configuration.')
output ruleCollections array = [
  for (i, ruleCollection) in range(0, length(securityAdminConfiguration.?ruleCollections ?? [])): {
    id: ruleCollectionModule[i].outputs.id
    name: ruleCollectionModule[i].outputs.name
    rules: ruleCollectionModule[i].outputs.rules
  }
]

// =============== //
//   Definitions   //
// =============== //
