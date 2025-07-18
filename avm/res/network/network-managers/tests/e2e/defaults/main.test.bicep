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
param resourceGroupName string = 'test-virtual-networks-basic-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nvnmin'

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
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}'
      location: resourceLocation
      tags: mainTags
      networkManagerConfig: {
        name: 'mainDeploymentNamePrefix'
        networkManagerScopes: {}
      }
    }
  }
]

// ============== //
// Outputs        //
// ============== //

output result object = testDeployment[0].outputs
