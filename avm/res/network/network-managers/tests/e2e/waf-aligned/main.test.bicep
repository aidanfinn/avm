// Copyright (c) Cloud Mechanix
// Licensed under the MIT License.

targetScope = 'subscription'

metadata name = 'Using only defaults'
metadata description = 'This instance deploys the module with the minimum set of required parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = toLower(take(uniqueString(subscription().id, resourceLocation), 10))

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = 'netmantest'

@description('Optional. A timestamp to inject into the tags of each resource.')
param timestamp string = utcNow()

@description('Tags to apply to main deployment resources.')
param mainTags object = {
  environment: 'test'
  project: 'network-managers'
  timestamp: timestamp
}

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
  tags: mainTags
}

// ============== //
// Test Setup     //
// ============== //

// Dependencies
// ============

module nestedDependencies './dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    location: resourceLocation
  }
}

// Diagnostics
// ===========

module diagnosticDependencies './diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: take('dep${resourceGroupName}diasa01', 24)
    logAnalyticsWorkspaceName: 'dep-${resourceGroupName}-law'
    eventHubNamespaceEventHubName: 'dep-${resourceGroupName}-evh'
    eventHubNamespaceName: 'dep-${resourceGroupName}-evhns'
    location: resourceLocation
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${iteration}'
    params: {
      name: '${namePrefix}-nm'
      location: resourceLocation
      tags: mainTags
      networkManagerConfig: {
        name: 'mainDeploymentNamePrefix'
        networkManagerScopes: {
          managementGroups: []
          subscriptions: [subscription().id]
        }
        description: 'This is a test deployment for the Network Manager module using all options.'
      }
      diagnosticSettings: [
        {
          name: 'customSetting'
          eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
          eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
          storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
          workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
        }
      ]
      ipamPools: [
        {
          name: 'ipamPool1'
          addressPrefixes: ['10.1.0.0/16']
          description: 'IPAM test pool 1'
          displayName: 'IPAM Pool 1'
          tags: union(mainTags, {
            poolPurpose: 'ipamPool1'
          })
        }
        {
          name: 'ipamPool2'
          addressPrefixes: ['10.2.0.0/16']
          description: 'IPAM test pool 2'
          displayName: 'IPAM Pool 2'
          tags: union(mainTags, {
            poolPurpose: 'ipamPool2'
          })
        }
      ]
      networkGroups: [
        {
          name: 'networkGroup1'
          location: resourceLocation
          description: 'Network Group 1'
          memberType: 'VirtualNetwork'
          staticMemberResourceIds: [
            nestedDependencies.outputs.spokeVnetResourceIds[0].id
            nestedDependencies.outputs.spokeVnetResourceIds[1].id
            nestedDependencies.outputs.spokeVnetResourceIds[2].id
          ]
        }
        {
          name: 'networkGroup2'
          location: resourceLocation
          description: 'Network Group 2'
          memberType: 'VirtualNetwork'
        }
      ]
    }
  }
]

// ============== //
// Outputs        //
// ============== //

output result object = testDeployment[0].outputs
