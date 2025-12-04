// Copyright (c) Cloud Mechanix
// Licensed under the MIT License.

targetScope = 'subscription'

metadata name = 'Update Hub Routes'
metadata description = 'Deploys the Update Hub Routes pattern to automatically apply User-Defined Routes to a hub Virtual Network.'

// ============= //
// Parameters    //
// ============= //

@sys.description('Optional. Customer Usage Attribution (CUA) ID for partner tracking. Defaults to Cloud Mechanix.')
param partnerLinkId string = 'cca1ef9c-c4b1-4c3d-8973-7e5341ab6792'

@sys.description('Optional. Location for all resources.')
param location string = 'northeurope'

@sys.description('Optional. Tags to apply to the Network Manager resource. Example: { "environment": "production", "project": "networking" }')
param tags object = {}

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@sys.description('Optional. The lock settings of the service.')
param lock lockType?

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@sys.description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@sys.description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@sys.description('Optional. The name of the resource group to deploy the solution into.')
param resourceGroupName string = '${subscription().displayName}-auto'

// ================//
// Variables       //
// ================//

// ================//
// Deployments     //
// ================//

#disable-next-line no-deployments-resources
resource partnerLink 'Microsoft.Resources/deployments@2021-04-01' = if (!empty(partnerLinkId)) {
  name: 'pid-${partnerLinkId}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
  tags: union(tags, {
    'partner-attribution': 'pid-${partnerLinkId}'
  })
}

module resourceGroup 'br/public:avm/res/resources/resource-group:0.4.2' = {
  name: 'resourceGroupDeployment'
  params: {
    name: resourceGroupName
    location: location
    tags: union(tags, {
      Purpose: 'A solution to automate the creation and maintenance of User-Defined Routes in the hub Virtual Network.'
    })
    lock: lock
  }
}

// ================//
// Outputs         //
// ================//

@sys.description('The resource group the solution was deployed into.')
output resourceGroupName string = resourceGroup.outputs.name
