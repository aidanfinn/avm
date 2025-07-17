// Microsoft.Network/networkManagers/verifierWorkspaces@2024-07-01

@export()
@description('Defines a Verifier Workspace resource with optional intents and runs.')
type verifierWorkspaceType = {
  @minLength(1)
  @maxLength(64)
  @description('Mandatory. The name of the Verifier Workspace resource.')
  name: string

  @description('Mandatory. The Azure region for the resource.')
  location: string

  @description('Optional. A description of the Verifier Workspace.')
  description: string

  @sys.description('Optional. A dictionary of resource tags to apply to the IPAM pool. Example: { "env": "prod", "costCenter": "1234" }')
  tags: object ?

  @sys.description('Optional. Define and test connectivity expectations between resources')
  reachabilityAnalysisIntents: verifierWorkspaceReachabilityAnalysisIntents[]?
}

@export()
@sys.description('Define and test connectivity expectations between resources')
type verifierWorkspaceReachabilityAnalysisIntents = {
  @minLength(1)
  @maxLength(64)
  @sys.description('Mandatory. The name of the intent.')
  name: string

  @sys.description('Optional. The description of the Analysis Intent')
  description: string?

  @sys.description('Mandatory. Destination resource ID to verify the reachability path of.')
  destinationResourceId: string

  @sys.description('Mandatory. IP traffic information.')
  ipTraffic: verifierWorkspaceReachabilityAnalysisIntentsIpTraffic

  @sys.description('Mandatory. Source resource ID to verify the reachability path of.')
  sourceResourceId: string
}

@export()
@sys.description('IP traffic information for a Verifier Workspace Reachability Analysis Intent.')
type verifierWorkspaceReachabilityAnalysisIntentsIpTraffic = {
  @sys.description('Mandatory. List of destination IP addresses of the traffic.')
  destinationIps: string[]

  @sys.description('Mandatory. The destination ports of the traffic.')
  destinationPorts: string[]

  @sys.description('Mandatory. A string array containing any of Any | ICMP | TCP | UDP')
  protocols: verifierWorkspaceReachabilityAnalysisIntentsprotocolType[]

  @sys.description('Mandatory. List of source IP addresses of the traffic.')
  sourceIps: string[]

  @sys.description('Mandatory. The source ports of the traffic.')
  sourcePorts: string[]
}

@export()
@sys.description('Mandatory. A string array containing any of Any | ICMP | TCP | UDP')
type verifierWorkspaceReachabilityAnalysisIntentsprotocolType = 'Any' | 'ICMP' | 'TCP' | 'UDP'
