// Copyright (c) Cloud Mechanix
// Licensed under the MIT License.

metadata name = 'Network Manager'
metadata description = 'Deploys an Azure Network Manager resource with specified scope and optional configurations.'

// ============= //
// Parameters    //
// ============= //

@sys.description('Optional. Customer Usage Attribution (CUA) ID for partner tracking. Defaults to Cloud Mechanix.')
param partnerLinkId string = 'cca1ef9c-c4b1-4c3d-8973-7e5341ab6792'

@sys.description('Optional. Location for all resources.')
param location string = resourceGroup().location

@sys.description('Mandatory. The name of the Azure Network Manager resource. Must be 1-80 characters, using only a-z, A-Z, 0-9, _, ., or -. Regex: ^[a-zA-Z0-9_.-]+$')
@minLength(1)
@maxLength(80)
param name string

@sys.description('Optional tags to apply to the Network Manager resource. Example: { "environment": "production", "project": "networking" }')
param tags object = {}

import { networkManagersType } from './types/networkManagers.bicep'
@sys.description('Mandatory. The configuration for the Network Manager resource.')
param networkManagerConfig networkManagersType

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@sys.description('Optional. The lock settings of the service.')
param lock lockType?

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@sys.description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@sys.description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

import { ipamPoolType } from './types/ipamPools.bicep'
@sys.description('Optional. List of IPAM pools to create under the Network Manager.')
param ipamPools ipamPoolType[] = []

import { networkGroupType } from './types/networkGroups.bicep'
@sys.description('Optional. List of network groups to create under the Network Manager.')
param networkGroups networkGroupType[] = []

import { connectivityConfigurationType } from './types/connectivityConfigurations.bicep'
@sys.description('An array of connectivity configurations to deploy.')
param connectivityConfigurations connectivityConfigurationType[] = []

import { routingConfigurationType } from './types/routingConfigurations.bicep'
@sys.description('An array of routing configurations to deploy under the Network Manager.')
param routingConfigurations routingConfigurationType[] = []

import { verifierWorkspaceType } from './types/verifierWorkspaces.bicep'
@sys.description('An array of routing configurations to deploy under the Network Manager.')
param verifierWorkspaces verifierWorkspaceType[] = []

// ================//
// Variables       //
// ================//

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Network Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '4d97b98b-1d4f-4787-a291-c67834d212e7'
  )
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
}

var formattedRoleAssignments = [
  for (roleAssignment, index) in (roleAssignments ?? []): union(roleAssignment, {
    roleDefinitionId: builtInRoleNames[?roleAssignment.roleDefinitionIdOrName] ?? (contains(
        roleAssignment.roleDefinitionIdOrName,
        '/providers/Microsoft.Authorization/roleDefinitions/'
      )
      ? roleAssignment.roleDefinitionIdOrName
      : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName))
  })
]

// ================//
// Deployments     //
// ================//

@sys.description('Deploys a Customer Usage Attribution (CUA) resource for partner tracking, if a valid CUA ID is provided.')
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

resource networkManager 'Microsoft.Network/networkManagers@2024-07-01' = {
  name: name
  location: location
  tags: !empty(tags) ? tags : null
  properties: {
    description: networkManagerConfig.?description ?? ''
    networkManagerScopes: empty(networkManagerConfig.networkManagerScopes.?managementGroups ?? []) && empty(networkManagerConfig.networkManagerScopes.?subscriptions ?? [])
      ? {
          // No configuration was provided so one must be created
          managementGroups: []
          subscriptions: [subscription().id] // Use the current subscription as the default scope
        }
      : {
          // A configuration has been provided and will be used as supplied
          managementGroups: networkManagerConfig.networkManagerScopes.?managementGroups ?? []
          subscriptions: networkManagerConfig.networkManagerScopes.?subscriptions ?? []
        }
    networkManagerScopeAccesses: !empty(networkManagerConfig.?networkManagerScopeAccesses)
      ? networkManagerConfig.?networkManagerScopeAccesses
      : null
  }
}

resource networkManager_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: networkManager
}

resource networkManager_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
    name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
    properties: {
      storageAccountId: diagnosticSetting.?storageAccountResourceId
      workspaceId: diagnosticSetting.?workspaceResourceId
      eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
      eventHubName: diagnosticSetting.?eventHubName
      metrics: [
        for group in (diagnosticSetting.?metricCategories ?? [{ category: 'AllMetrics' }]): {
          category: group.category
          enabled: group.?enabled ?? true
          timeGrain: null
        }
      ]
      logs: [
        for group in (diagnosticSetting.?logCategoriesAndGroups ?? [{ categoryGroup: 'allLogs' }]): {
          categoryGroup: group.?categoryGroup
          category: group.?category
          enabled: group.?enabled ?? true
        }
      ]
      marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId
      logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
    }
    scope: networkManager
  }
]

resource networkManager_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(networkManager.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: networkManager
  }
]

module ipamPoolModules './ipamPool/main.bicep' = [
  for (pool, i) in (ipamPools ?? []): {
    name: '${take(name, 50)}-ipamPool-${i}'
    params: {
      networkManagerName: networkManager.name
      location: pool.?location ?? location
      ipamPool: {
        name: pool.name
        addressPrefixes: pool.addressPrefixes
        description: pool.?description ?? ''
        displayName: pool.?displayName ?? pool.name
        parentPoolName: pool.?parentPoolName ?? ''
        tags: pool.?tags ?? {}
      }
    }
  }
]

module networkGroupModules 'networkGroup/main.bicep' = [
  for (group, i) in (networkGroups ?? []): {
    name: '${take(name, 37)}-networkGroup-${i}'
    params: {
      networkManagerName: networkManager.name
      networkGroup: group
    }
  }
]

module connectivityConfigurationsModule './connectivityConfiguration/main.bicep' = [
  for (config, i) in (connectivityConfigurations ?? []): {
    name: '${take(name, 37)}-connectivity-${i}'
    params: {
      networkManagerName: networkManager.name
      connectivityConfiguration: config
    }
    dependsOn: [
      networkGroupModules
    ]
  }
]

module routingConfigurationModules './routingConfiguration/main.bicep' = [
  for (config, i) in (routingConfigurations ?? []): {
    name: '${take(name, 37)}-routing-${i}'
    params: {
      networkManagerName: networkManager.name
      routingConfiguration: config
    }
    dependsOn: [
      networkGroupModules
    ]
  }
]

module verifierWorkspaceModules './verifierWorkspace/main.bicep' = [
  for (config, i) in (verifierWorkspaces ?? []): {
    name: '${take(name, 37)}-verifier-${i}'
    params: {
      networkManagerName: networkManager.name
      verifierWorkspace: config
    }
  }
]

// ================//
// Outputs         //
// ================//

@sys.description('The resource group the Network Manager was deployed.')
output resourceGroupName string = resourceGroup().name

@sys.description('The name of the deployed Network Manager.')
output name string = networkManager.name

@sys.description('The resource ID of the deployed Network Manager.')
output resourceId string = networkManager.id

@sys.description('The location of the deployed Network Manager.')
output location string = networkManager.location

@sys.description('An array of objects containing the resource ID, name, and address prefixes for each deployed IPAM pool.')
output ipamPools array = [
  for (i, pool) in range(0, length(ipamPools)): {
    id: ipamPoolModules[i].outputs.id
    name: ipamPoolModules[i].outputs.name
    addressPrefixes: ipamPoolModules[i].outputs.addressPrefixes
  }
]

@sys.description('An array of objects containing the resource ID and name of each deployed Network Group.')
output networkGroups array = [
  for (i, group) in range(0, length(networkGroups)): {
    id: networkGroupModules[i].outputs.id
    name: networkGroupModules[i].outputs.name
  }
]

@sys.description('An array of objects containing the resource ID, name, and address prefixes for each deployed Connectivity Configuration.')
output connectivityConfigurations array = [
  for (i, pool) in range(0, length(connectivityConfigurations)): {
    id: connectivityConfigurationsModule[i].outputs.id
    name: connectivityConfigurationsModule[i].outputs.name
  }
]

@sys.description('An array of objects containing the resource ID and name of each deployed routing configuration.')
output routingConfigurations array = [
  for (i, config) in range(0, length(routingConfigurations)): {
    id: routingConfigurationModules[i].outputs.id
    name: routingConfigurationModules[i].outputs.name
  }
]

@sys.description('An array of objects containing the resource ID and name of each deployed routing configuration.')
output verifierWorkspaces array = [
  for (i, config) in range(0, length(verifierWorkspaces)): {
    id: verifierWorkspaceModules[i].outputs.id
    name: verifierWorkspaceModules[i].outputs.name
  }
]

// =============== //
//   Definitions   //
// =============== //
