// Copyright (c) Cloud Mechanix
// Licensed under the MIT License.

targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'Deploys the module aligned with Azure Well-Architected Framework best practices.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'test-virtual-networks-basic-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nvgmwaf'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = take(toLower(uniqueString(newGuid())), 12)

@description('Optional. A timestamp to inject into the tags of each resource.')
param timestamp string = utcNow()

// -- Parameters for nestedDependencies module --
@description('Name for the virtual network to create in nested dependencies.')
param virtualNetworkName string = 'dep-${namePrefix}-vnet-${serviceShort}'

@description('Name for the local network gateway to create in nested dependencies.')
param localNetworkGatewayName string = 'dep-${namePrefix}-lng-${serviceShort}'

// -- Parameters for diagnosticDependencies module --
@description('Storage account name for diagnostics.')
@maxLength(24)
param storageAccountName string = 'dep${namePrefix}diasa${serviceShort}01'

@description('Log Analytics Workspace name for diagnostics.')
param logAnalyticsWorkspaceName string = 'dep-${namePrefix}-law-${serviceShort}'

@description('Event Hub Namespace name for diagnostics.')
param eventHubNamespaceName string = 'dep-${namePrefix}-evhns-${serviceShort}'

@description('Event Hub name inside the namespace for diagnostics.')
param eventHubNamespaceEventHubName string = 'dep-${namePrefix}-evhns-${serviceShort}'

// -- Parameters for main test deployment module --
@description('Name prefix for the main deployment module.')
param mainDeploymentNamePrefix string = '${namePrefix}${serviceShort}001'

@description('Partner Link ID (GUID) for main deployment.')
param partnerLinkId string = 'cca1ef9c-c4b1-4c3d-8973-7e5341ab6792'

@description('Description for the main deployment.')
param mainDescription string = 'Test deployment for WAF-aligned Network Manager'

@description('Tags to apply to main deployment resources.')
param mainTags object = {
  environment: 'test'
  project: 'network-managers'
  timestamp: timestamp
}

@description('Network Manager scopes for main deployment.')
param networkManagerScopes object = {
  managementGroups: [
    '/providers/Microsoft.Management/managementGroups/${tenant().tenantId}'
  ]
  subscriptions: []
}

@description('Network Manager scope accesses for main deployment.')
param networkManagerScopeAccesses array = [
  'Connectivity'
  'SecurityAdmin'
  'Routing'
]

@description('IPAM pools for main deployment.')
param ipamPools array = [
  {
    name: 'testIpamPool1'
    addressPrefixes: [
      '10.1.0.0/16'
    ]
    description: 'Test IPAM Pool1 for WAF-aligned Network Manager'
    displayName: 'Test IPAM Pool1'
  }
  {
    name: 'testIpamPool2'
    addressPrefixes: [
      '10.2.0.0/16'
    ]
    description: 'Test IPAM Pool2 for WAF-aligned Network Manager'
    displayName: 'Test IPAM Pool2'
  }
]

// ============ //
// Dependencies //
// ============ //

resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: resourceLocation
  tags: mainTags
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    location: resourceLocation
    virtualNetworkName: virtualNetworkName
    localNetworkGatewayName: localNetworkGatewayName
  }
}

module diagnosticDependencies 'diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: storageAccountName
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    eventHubNamespaceName: eventHubNamespaceName
    eventHubNamespaceEventHubName: eventHubNamespaceEventHubName
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
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${mainDeploymentNamePrefix}${iteration}'
      partnerLinkId: partnerLinkId
      location: resourceLocation
      tags: mainTags
      ipamPools: ipamPools
      networkGroups: nestedDependencies.outputs.spokeVnetResourceIds
      diagnosticSettings: [
        {
          name: 'customSetting'
          metricCategories: [
            {
              category: 'AllMetrics'
            }
          ]
          eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
          eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
          storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
          workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
        }
      ]
      networkManagerConfig: {
        name: mainDeploymentNamePrefix
        description: 'This is a test deployment for WAF-aligned Network Manager'
        networkManagerScopes: { subscriptions: [subscription().id] }
        networkManagerScopeAccesses: networkManagerScopeAccesses
      }
    }
  }
]

// ============== //
// Outputs        //
// ============== //

output nestedDependenciesOutputs object = nestedDependencies.outputs
output diagnosticDependenciesOutputs object = diagnosticDependencies.outputs
output result object = testDeployment[0].outputs
