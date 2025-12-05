@export()
@sys.description('The parameters for customising which hub VIrtual Network will be updated.')
type hubDetailsType = {
  @sys.description('The subscription ID of the hub Virtual Network.')
  hubSubscriptionId: string ?

  @sys.description('The resource group of the hub Virtual Network.')
  hubResourceGroup: string

  @sys.description('The name of the hub Virtual Network.')
  hubVNetName: string
}
