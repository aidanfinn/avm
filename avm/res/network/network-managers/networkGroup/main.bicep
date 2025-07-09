// Copyright (c) Cloud Mechanix
// Licensed under the MIT License.

metadata name = 'Network Manager Network Groups'
metadata description = 'Deploys one or more Network Groups for Azure Network Manager.'

// ============= //
// Parameters    //
// ============= //

@sys.description('Name of the parent Network Manager resource.')
param networkManagerName string

@sys.description('Name of the Network Group.')
param name string

@sys.description('Optional description for the Network Group.')
param description string = ''

@sys.description('The type of the group member.')
param memberType string

@sys.description('The static list of member resources for the network group.')
param staticMemberResourceIds array = []

// ================//
// Deployments     //
// ================//

resource networkGroup 'Microsoft.Network/networkManagers/networkGroups@2024-05-01' = {
  name: '${networkManagerName}/${name}-networkGroup'
  properties: {
    description: !empty(description) ? description : null
    memberType: memberType
  }
}

resource staticMembers 'Microsoft.Network/networkManagers/networkGroups/staticMembers@2024-05-01' = [for (member, i) in staticMemberResourceIds: if (!empty(staticMemberResourceIds)) {
  name: '${name}-networkGroup-member${i}'
  parent: networkGroup
  properties: {
    resourceId: member.staticMemberResourceIds
  }
}]

// ================//
// Outputs         //
// ================//

output id string = networkGroup.id
output name string = networkGroup.name
