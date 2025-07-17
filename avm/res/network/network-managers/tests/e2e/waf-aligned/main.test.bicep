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
param resourceGroupName string = toLower(take(uniqueString(subscription().id, resourceLocation), 12))

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
        networkManagerScopeAccesses: [
          'Connectivity'
          'Routing'
          'SecurityAdmin'
        ]
      }
      diagnosticSettings: [
        {
          name: 'diagnosticSettings1'
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
      connectivityConfigurations: [
        {
          name: 'connectivityConfig1'
          description: 'Connectivity configuration for Network Group 1'
          connectivityTopology: 'HubAndSpoke'
          hubs: [
            {
              resourceType: 'virtualNetwork'
              resourceId: '/subscriptions/6fd7f490-4be8-41e2-bbdc-7f52d1d7162c/resourceGroups/dyipwoqdk6g2/providers/Microsoft.Network/virtualNetworks/dep-hub-vnet'
            }
          ]
          appliesToGroups: [
            {
              networkGroupName: 'networkGroup1'
              groupConnectivity: 'None'
              useHubGateway: 'False'
              isGlobal: 'False'
            }
          ]
          deleteExistingPeering: 'False'
          isGlobal: 'False'
          connectivityCapabilities: {
            connectedGroupPrivateEndpointsScale: 'Standard'
            connectedGroupAddressOverlap: 'Allowed'
            peeringEnforcement: 'Unenforced'
          }
        }
      ]
      routingConfigurations: [
        {
          name: 'routingConfig1'
          description: 'Routing configuration for Network Group 1'
          ruleCollections: [
            {
              name: 'routingConfig1-ruleCollection1'
              disableBgpRoutePropagation: 'True'
              appliesToGroups: [
                {
                  networkGroupName: 'networkGroup1'
                }
              ]
              rules: [
                {
                  name: 'everywhere'
                  description: 'Override the default route all traffic everywhere'
                  destination: {
                    type: 'AddressPrefix'
                    destinationAddress: '0.0.0.0/0'
                  }
                  nextHop: {
                    nextHopType: 'VirtualAppliance'
                    nextHopAddress: '10.1.1.4'
                  }
                }
              ]
            }
          ]
        }
      ]
      securityAdminConfigurations: [
        {
          name: 'securityAdminConfig1'
          description: 'Security Admin Configuration for Network Group 1'
          applyOnNetworkIntentPolicyBasedServices: [
            'None'
          ]
          networkGroupAddressSpaceAggregationOption: 'None'
          ruleCollections: [
            {
              name: 'securityAdminConfig1-ruleCollection1'
              description: 'Rule Collection for Security Admin Configuration 1'
              appliesToGroups: [
                {
                  networkGroupName: 'networkGroup1'
                }
              ]
              rules: [
                {
                  name: 'deny-badguys'
                  access: 'Deny'
                  description: 'Deny traffic from bad guys'
                  direction: 'Inbound'
                  priority: 1
                  protocol: 'Any'
                  sources: [
                    {
                      addressPrefix: '129.228.0.0/16'
                      addressPrefixType: 'IPPrefix'
                    }
                  ]
                }
              ]
            }
          ]
        }
      ]
    }
  }
]

// ============== //
// Outputs        //
// ============== //

@sys.description('The resource ID of the Network Manager.')
output result object = testDeployment[0].outputs
