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

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@sys.description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

@sys.description('Optional. The current date and time - this is automatically calculated and does not need to be used.')
param runbuookStartDate string = utcNow()

@sys.description('Optional. The name of the Storage Account used to store the routing configuration.')
param storageAccountName string

import { hubDetailsType } from '../types/automation.bicep'
@sys.description('Mandatory. Details of the hub Virtual Network where routes will be applied.')
param hubDetails hubDetailsType

// ================//
// Variables       //
// ================//

// ================//
// Deployments     //
// ================//

module automationAccount 'br/public:avm/res/automation/automation-account:0.17.0' = {
  name: '${resourceGroupName}-automationAccount'
  scope: resourceGroup(resourceGroupName)
  params: {
    name: '${resourceGroupName}-aa'
    location: location
    tags: union(tags, {
      Purpose: 'Execute the runbook to automatically configure routes in the hub Virtual Network.'
    })
    lock: lock
    roleAssignments: roleAssignments
    runbooks: [
      {
        name: 'update-hub-routes'
        description: 'Runbook to update hub routes based on the configuration file in the Storage Account.'
        automationAccountName: '${resourceGroupName}-aa'
        type: 'PowerShell72'
        uri: 'https://raw.githubusercontent.com/aidanfinn/avm/refs/heads/main/avm/ptn/network/update-hub-routes/runbook/updateHubRoutes.ps1'
        location: location
        tags: union(tags, {
          Purpose: 'Runbook to update hub routes based on the configuration file in the Storage Account.'
        })
      }
    ]
    schedules: [
      {
        name: 'hourly-schedule'
        description: 'Hourly schedule to run the Update Hub Routes runbook.'
        startTime: runbuookStartDate
        interval: 1
        frequency: 'Hour'
      }
    ]
    jobSchedules: [
      {
        name: 'update-hub-routes-hourly'
        automationAccountName: '${resourceGroupName}-aa'
        runbookName: 'update-hub-routes'
        scheduleName: 'hourly-schedule'
        parameters: {
          HubSubscriptionId: hubDetails.?hubSubscriptionId ?? subscription().subscriptionId
          HubResourceGroup: hubDetails.hubResourceGroup
          HubVNetName: hubDetails.hubVNetName
          StorageAccountName: storageAccountName
          StorageContainerName: 'route-automation-config'
          BlobName: 'route-automation-config.json'
        }
      }
    ]
    managedIdentities: {
      systemAssigned: true
    }
    diagnosticSettings: diagnosticSettings
  }
}

// ================//
// Outputs         //
// ================//

@sys.description('The name of the Automation Account deployed.')
output name string = automationAccount.outputs.name

@sys.description('The resource group the Automation Account was deployed into.')
output resourceGroupName string = resourceGroupName

@sys.description('The resource ID of the Automation Account deployed.')
output resourceId string = automationAccount.outputs.resourceId

@sys.description('The principal ID of the Automation Account\'s system assigned managed identity.')
output systemAssignedMIPrincipalId string = automationAccount.outputs.systemAssignedMIPrincipalId!
