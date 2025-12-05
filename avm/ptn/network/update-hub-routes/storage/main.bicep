// Copyright (c) Cloud Mechanix
// Licensed under the MIT License.

metadata name = 'StorageAccount'
metadata description = 'Deploys the Storage Account for the Update Hub Routes pattern to store the required route configurations.'

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
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      resourceAccessRules: []
    }
    blobServices: {
      containers: [
        {
          name: 'route-automation-config'
          publicAccess: 'None'
        }
      ]
    }
    tags: union(tags, {
      Purpose: 'Stores the route congifuration file that will be used by the Automation Runbook.'
    })
    lock: lock
    roleAssignments: roleAssignments
  }
}

// ================//
// Outputs         //
// ================//

@sys.description('The name of the Storage Account deployed.')
output name string = storageAccount.outputs.name

@sys.description('The resource group the Storage Account was deployed into.')
output resourceGroupName string = resourceGroupName

@sys.description('The resource ID of the Storage Account deployed.')
output resourceId string = storageAccount.outputs.resourceId

@sys.description('The name of the Blob Container created to store the route configuration file.')
output containerName string = 'route-automation-config'
