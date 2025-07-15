// Copyright (c) Cloud Mechanix
// Licensed under the MIT License.

metadata name = 'Network Manager Network Groups'
metadata description = 'Deploys one or more Network Groups for Azure Network Manager.'

// ============= //
// Parameters    //
// ============= //

@sys.description('Name of the parent Network Manager resource.')
param networkManagerName string

import { networkGroupType } from '../types/networkGroups.bicep'
@sys.description('The Network Group to deploy.')
param networkGroup networkGroupType

// ================//
// Deployments     //
// ================//

resource networkGroupModule 'Microsoft.Network/networkManagers/networkGroups@2024-05-01' = {
  name: '${networkManagerName}/${networkGroup.name}'
  properties: {
    description: networkGroup.?description ?? ''
    memberType: networkGroup.memberType
  }
}

resource staticMembers 'Microsoft.Network/networkManagers/networkGroups/staticMembers@2024-05-01' = [for (member, i) in networkGroup.?staticMemberResourceIds ?? []: {
  name: '${networkGroup.name}-member${i}'
  parent: networkGroupModule
  properties: {
    resourceId: member
  }
}]

// ================//
// Outputs         //
// ================//

output id string = networkGroupModule.id
output name string = networkGroupModule.name
