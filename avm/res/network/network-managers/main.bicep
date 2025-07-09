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

@sys.description('Optional. A description of the Azure Virtual Network Manager resource.')
param description string = ''

@sys.description('Optional tags to apply to the Network Manager resource. Example: { "environment": "production", "project": "networking" }')
param tags object = {}

@sys.description('Optional. The scopes for the Network Manager. Default is the root management group of the tenant. You can specify management groups or subscriptions.')
param networkManagerScopes object = {
  managementGroups: [
    '/providers/Microsoft.Management/managementGroups/${tenant().tenantId}'
  ]
  subscriptions: []
}

@sys.description('Optional. The list of network manager features to apply to the Network Manager. Default is Connectivity, SecurityAdmin, and Routing.')
param networkManagerScopeAccesses array = [
  'Connectivity'
  'SecurityAdmin'
  'Routing'
]

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@sys.description('Optional. The lock settings of the service.')
param lock lockType?

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@sys.description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@sys.description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@sys.description('Optional. List of IPAM pools to create under the Network Manager.')
param ipamPools ipamPoolType[] = []

@sys.description('Optional. List of network groups to create under the Network Manager.')
param networkGroups networkGroupType[] = []

@sys.description('An array of connectivity configurations to deploy.')
param connectivityConfigurations connectivityConfigurationType[] = []


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
}

resource networkManager 'Microsoft.Network/networkManagers@2024-05-01' = {
  name: name
  location: location
  tags: !empty(tags) ? tags : null
  properties: {
    description: !empty(description) ? description : null
    networkManagerScopes: networkManagerScopes
    networkManagerScopeAccesses: networkManagerScopeAccesses
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
    name: roleAssignment.?name ?? guid(
      networkManager.id,
      roleAssignment.principalId,
      roleAssignment.roleDefinitionId
    )
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

module ipamPoolModules './ipamPool/main.bicep' = [for (pool, i) in ipamPools: {
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
}]

module networkGroupModules 'networkGroup/main.bicep' = [for (group, i) in networkGroups: {
  name: '${take(name, 37)}-networkGroup-${i}'
  params: {
    networkManagerName: networkManager.name
    name: group.name
    description: group.?description ?? ''
    memberType: group.memberType ?? 'Static'
    staticMemberResourceIds: group.?staticMemberResourceIds ?? []
  }
}]

module connectivityConfigurationsModule './connectivityConfiguration/main.bicep' = [for (configs, i) in connectivityConfigurations: {
  name: '${take(name, 37)}-connectivity-${i}'
  params: {
    networkManagerName: networkManager.name
    connectivityConfigurations: connectivityConfigurations
  }
}]

// ================//
// Outputs         //
// ================//

@sys.description('The resource group the virtual network gateway was deployed.')
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

@sys.description('An array of objects containing the resource ID, name, and address prefixes for each deployed IPAM pool.')
output connectivityConfigurations array = [
  for (i, pool) in range(0, length(connectivityConfigurations)): {
    id: connectivityConfigurationsModule[i].outputs.resourceIds
  }
]

// =============== //
//   Definitions   //
// =============== //

@sys.description('Defines the structure for an IPAM pool to be deployed under the Azure Network Manager.')
type ipamPoolType = {
  @sys.description('The name of the IPAM pool. Must be unique within the Network Manager. Must start with a letter or number and may contain letters, numbers, underscores (_), periods (.), and hyphens (-). The name must end with a letter, number, or underscore. Max length: 64.')
  name: string

  @sys.description('Optional. The Azure region where the IPAM pool will be created. Defaults to the resource group location if not specified.')
  location: string ?

  @sys.description('An array of CIDR address prefixes to assign to the IPAM pool. Example: ["10.0.0.0/16", "10.1.0.0/16"].')
  addressPrefixes: array

  @sys.description('Optional. A description for the IPAM pool, which can provide additional context for the resource.')
  description: string ?

  @sys.description('Optional. A friendly display name for the IPAM pool to use in the Azure Portal.')
  displayName: string ?

  @sys.description('Optional. The name of the parent IPAM pool, if creating a nested pool hierarchy.')
  parentPoolName: string ?

  @sys.description('Optional. A dictionary of resource tags to apply to the IPAM pool. Example: { "env": "prod", "costCenter": "1234" }')
  tags: object ?

  @sys.description('Optional. The provisioning state of the IPAM pool. This is generally managed by Azure and should not be set manually.')
  provisioningState: string ?
}

@sys.description('Defines the structure of a network group used with Azure Virtual Network Manager.')
type networkGroupType = {
  @sys.description('The name of the network group.')
  name: string

  @sys.description('The region where the network group is deployed. Must match the region of the Network Manager.')
  location: string

  @sys.description('A description of the network group.')
  description: string?

  @sys.description('The type of the group member.')
  memberType: 'Static' | 'Dynamic'

  @sys.description('The static list of member resources for the network group.')
  staticMemberResourceIds: networkGroupStaticMemberResourceType[]?
}

@sys.description('Defines a static member resource of a network group.')
type networkGroupStaticMemberResourceType = {
  @sys.description('The resource ID of the static member to be added to the network group.')
  resourceId: string
}


@sys.description('Defines the structure of a connectivity configuration.')
type connectivityConfigurationType = {
  @sys.description('The name of the connectivity configuration.')
  @minLength(1)
  name: string

  @sys.description('The description of the connectivity configuration.')
  description: string

  @sys.description('The connectivity topology (e.g., HubAndSpoke, Mesh).')
  connectivityTopology: 'HubAndSpoke' | 'Mesh'

  @sys.description('An array of hub resource IDs.')
  hubs: array

  @sys.description('Indicates whether the configuration is global.')
  isGlobal: bool

  @sys.description('An array of group resource IDs to which the configuration applies.')
  appliesToGroups: array
}
