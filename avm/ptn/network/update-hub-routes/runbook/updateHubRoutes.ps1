param (
    [Parameter(Mandatory=$true)][string] $HubVNetName,
    [Parameter(Mandatory=$true)][string] $HubResourceGroup,
    [Parameter(Mandatory=$true)][string] $HubSubscriptionId,
    [Parameter(Mandatory=$true)][string] $StorageAccountName,
    [Parameter(Mandatory=$true)][string] $StorageContainerName,
    [Parameter(Mandatory=$true)][string] $BlobName
)

# Authenticate with managed identity
try {
    if (-not (Get-AzContext)) {
        Connect-AzAccount -Identity -ErrorAction Stop
    }
} catch {
    throw "❌ Failed to authenticate with managed identity $_"
}

# Switch to hub subscription
try {
    Select-AzSubscription -SubscriptionId $HubSubscriptionId -ErrorAction Stop
    $currentContext = Get-AzContext
    if ($currentContext.Subscription.Id -ne $HubSubscriptionId) {
        throw "❌ Subscription context switch failed. Current: $($currentContext.Subscription.Id)"
    }
    Write-Output "✅ Context set to hub subscription ${HubSubscriptionId}"
} catch {
    throw "❌ Unable to switch to hub subscription $_"
}

# Load configuration from blob
try {
    $storageContext = New-AzStorageContext -StorageAccountName $StorageAccountName -UseConnectedAccount
    $localPath = "$env:TEMP\$BlobName"
    Get-AzStorageBlobContent -Blob $BlobName -Container $StorageContainerName -Destination $localPath -Context $storageContext -Force 
    if (-not (Test-Path $localPath)) {
        throw "Blob download failed. File not found: $localPath"
    }
    $config = Get-Content $localPath | ConvertFrom-Json
    Write-Output "✅ Loaded configuration from blob"
} catch {
    throw "❌ Failed to load or parse configuration blob $_"
}

# Extract config values
$targetSubnets = $config.configureRouterSubnets.Subnets
$skipPrefixes = $config.configureRouterSubnets.SkipPrefixes
$skipVnets = $config.configureRouterSubnets.SkipVnets
$requiredRoutes = $config.requiredRoutes
$firewallIp = $config.firewallIp

# Get hub VNet and peerings
$hubVNet = Get-AzVirtualNetwork -Name $HubVNetName -ResourceGroupName $HubResourceGroup
$peerings = Get-AzVirtualNetworkPeering -VirtualNetworkName $HubVNetName -ResourceGroupName $HubResourceGroup

$totalAdded = 0
$totalReplaced = 0
$totalSkipped = 0

Write-Output "Starting to add routes to spokes ..." 

foreach ($peering in $peerings) {
    try {
        $remoteVNetId = $peering.RemoteVirtualNetwork.Id
        $vnetIdParts = $remoteVNetId -split "/"
        $remoteSubId = $vnetIdParts[2]
        $remoteRgName = $vnetIdParts[4]
        $remoteVNetName = $vnetIdParts[8]

        if ($remoteVNetName -match "(?i)hub" -or $skipVnets -contains $remoteVNetName) {
            Write-Output "⏭️ Skipping ${remoteVNetName} (excluded by name)"
            continue
        }

        Write-Output "🔄 Processing ${remoteVNetName}"

        try {
            Select-AzSubscription -SubscriptionId $remoteSubId -ErrorAction Stop
        } catch {
            Write-Warning "⚠️ Failed to switch to remote subscription ${remoteSubId} $_"
            continue
        }

        try {
            $remoteVNetDetails = Get-AzVirtualNetwork -Name $remoteVNetName -ResourceGroupName $remoteRgName -ErrorAction Stop
        } catch {
            Write-Warning "⚠️ Failed to retrieve remote VNet ${remoteVNetName} $_"
            continue
        }

        if ($remoteVNetDetails.AddressSpace.AddressPrefixes | Where-Object { $skipPrefixes -contains $_ }) {
            Write-Output "⏭️ Skipping ${remoteVNetName} (excluded by prefix)"
            continue
        }

        Select-AzSubscription -SubscriptionId $HubSubscriptionId

        $vnetIndex = 0

        foreach ($prefix in $remoteVNetDetails.AddressSpace.AddressPrefixes) {
            foreach ($subnetName in $targetSubnets) {
                $subnet = $hubVNet.Subnets | Where-Object { $_.Name -eq $subnetName }
                if (-not $subnet) {
                    Write-Warning "⚠️ Subnet $subnetName not found in hub VNet"
                    continue
                }

                $routeTableId = $subnet.RouteTable.Id
                $routeTableName = ($routeTableId -split "/")[-1]
                $routeTableRg = ($routeTableId -split "/")[4]
                $routeTable = Get-AzRouteTable -Name $routeTableName -ResourceGroupName $routeTableRg

                $existingRoute = $routeTable.Routes | Where-Object { $_.AddressPrefix -eq $prefix }
                $routeName = "${remoteVNetName}-$vnetIndex"

                $isIdentical = $false
                if ($existingRoute) {
                    $isIdentical = (
                        $existingRoute.Name -eq $routeName -and
                        $existingRoute.NextHopType -eq "VirtualAppliance" -and
                        $existingRoute.NextHopIpAddress -eq $firewallIp
                    )
                }

                if ($isIdentical) {
                    Write-Output "🚫 Skipping prefix $prefix — identical route already exists in $routeTableName"
                    $totalSkipped++
                    continue
                }

                if ($existingRoute) {
                    Write-Output "♻️ Replacing route for prefix $prefix in $routeTableName"
                    $routeTable.Routes.Remove($existingRoute)
                    $totalReplaced++
                } else {
                    $totalAdded++
                }

                try {
                    $routeTable = Add-AzRouteConfig -Name $routeName `
                        -AddressPrefix $prefix `
                        -NextHopType "VirtualAppliance" `
                        -NextHopIpAddress $firewallIp `
                        -RouteTable $routeTable

                    Set-AzRouteTable -RouteTable $routeTable
                    Write-Output "✅ Added route $routeName to $routeTableName for $prefix"
                    $vnetIndex++
                } catch {
                    Write-Warning "⚠️ Failed to add route $routeName for $prefix $_"
                }
            }
        }
    } catch {
        Write-Warning "⚠️ Failed to process peering for ${remoteVNetId} $_"
    }
}

Write-Output "Starting to add other required routes ..." 

foreach ($route in $requiredRoutes) {
    foreach ($subnetName in $route.Subnets) {
        $subnet = $hubVNet.Subnets | Where-Object { $_.Name -eq $subnetName }
        if (-not $subnet) {
            Write-Warning "⚠️ Subnet $subnetName not found in hub VNet"
            continue
        }

        $routeTableId = $subnet.RouteTable.Id
        $routeTableName = ($routeTableId -split "/")[-1]
        $routeTableRg = ($routeTableId -split "/")[4]
        $routeTable = Get-AzRouteTable -Name $routeTableName -ResourceGroupName $routeTableRg

        $existingRoute = $routeTable.Routes | Where-Object { $_.AddressPrefix -eq $route.Prefix }

        $isIdentical = $false
        if ($existingRoute) {
            $isIdentical = (
                $existingRoute.Name -eq $route.Name -and
                $existingRoute.NextHopType -eq $route.NextHopType -and
                (
                    $route.NextHopType -ne "VirtualAppliance" -or
                    $existingRoute.NextHopIpAddress -eq $route.NextHopIpAddress
                )
            )
        }

        if ($isIdentical) {
            Write-Output "🚫 Skipping route ${route.Name} — identical route already exists in $routeTableName"
            $totalSkipped++
            continue
        }

        if ($existingRoute) {
            Write-Output "♻️ Replacing route ${route.Name} — existing route differs in $routeTableName"
            $routeTable.Routes.Remove($existingRoute)
            $totalReplaced++
        } else {
            $totalAdded++
        }

        try {
            $params = @{
                Name = $route.Name
                AddressPrefix = $route.Prefix
                NextHopType = $route.NextHopType
                RouteTable = $routeTable
            }
            if ($route.NextHopType -eq "VirtualAppliance" -and $route.PSObject.Properties["NextHopIpAddress"]) {
                $params["NextHopIpAddress"] = $route.NextHopIpAddress
            }

            $routeTable = Add-AzRouteConfig @params
            Set-AzRouteTable -RouteTable $routeTable
            Write-Output "✅ Added route ${route.Name} to $routeTableName"
        } catch {
            Write-Warning "⚠️ Failed to add route ${route.Name} $_"
        }
    }
}

# ✅ Final Summary
Write-Output "🏁 Completed."
Write-Output "➕ New routes added: $totalAdded"
Write-Output "♻️ Routes replaced: $totalReplaced"
Write-Output "🚫 Routes skipped: $totalSkipped"
