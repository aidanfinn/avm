// Copyright (c) Cloud Mechanix
// Licensed under the MIT License.

metadata name = 'Network Manager Routing Configuration'
metadata description = 'Deploys one or more Routing Configurations for Azure Network Manager.'

// ============= //
// Parameters    //
// ============= //

@sys.description('The name of the parent Azure Network Manager.')
param networkManagerName string

import { securityAdminConfigurationType } from '../network-managers-types.bicep'
@sys.description('The routing configuration to deploy.')
param securityAdminConfiguration securityAdminConfigurationType

// ================//
// Deployments     //
// ================//

resource securityAdminConfigurationModule 'Microsoft.Network/networkManagers/securityAdminConfigurations@2024-07-01' = {
  name: '${networkManagerName}/${securityAdminConfiguration.name}'
  properties: {
    description: securityAdminConfiguration.?description ?? ''
    applyOnNetworkIntentPolicyBasedServices: securityAdminConfiguration.applyOnNetworkIntentPolicyBasedServices ?? ['None']
    networkGroupAddressSpaceAggregationOption: securityAdminConfiguration.networkGroupAddressSpaceAggregationOption ?? 'None'
  }
}

// ================//
// Outputs         //
// ================//

output id string = securityAdminConfigurationModule.id
output name string = securityAdminConfigurationModule.name

// =============== //
//   Definitions   //
// =============== //
