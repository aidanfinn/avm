// Copyright (c) Cloud Mechanix
// Licensed under the MIT License.

targetScope = 'subscription'

metadata name = 'Update Hub Routes'
metadata description = 'Deploys the Update Hub Routes pattern to automatically apply User-Defined Routes to a hub Virtual Network.'

// ============= //
// Parameters    //
// ============= //

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
param resourceGroupName string


// ================//
// Variables       //
// ================//


var randomString = uniqueString(subscription().subscriptionId, tenant().tenantId)

// Calculate max allowed length for resourceGroupName + randomString
// Reserve 2 chars for "sa"
var maxPrefixLength = 24 - 2

// Combine resourceGroupName and randomString, then trim
var combinedPrefix = toLower('${resourceGroupName}${randomString}')
var trimmedPrefix = substring(combinedPrefix, 0, maxPrefixLength)

// Final name
var storageAccountName = '${trimmedPrefix}sa'


// ================//
// Deployments     //
// ================//

module storageAccount 'br/public:avm/res/storage/storage-account:0.6.3' = {
  name: '${storageAccountName}-storageAccount'
  scope: resourceGroup(resourceGroupName)
  params: {
    name: storageAccountName
    location: location
    kind: 'StorageV2'
    accessTier: 'Hot'
    skuName: 'Standard_LRS'
    allowSharedKeyAccess: false
    supportsHttpsTrafficOnly: true
    tags: union(tags, {
      Purpose: 'Stores the route congifuration file that will be used by the Automation Runbook.'
    })
    lock: lock
    blobServices: {
      containers: [
        {
          name: 'route-automation-config'
          publicAccess: 'None'
        }
      ]
    }
  }
}

// ================//
// Outputs         //
// ================//

output name string = storageAccount.outputs.name
output resourceGroupName string = resourceGroupName
output resourceId string = storageAccount.outputs.resourceId
