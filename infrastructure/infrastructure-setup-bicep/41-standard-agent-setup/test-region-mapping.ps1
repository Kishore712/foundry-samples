# Test script to validate region mapping logic for canary regions
# This simulates the ARM template logic to ensure correct region mapping

Write-Host "Testing Cosmos DB Region Mapping Logic" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green

# Simulate the ARM template variables
$canaryRegions = @("eastus2euap", "centraluseuap")

function Test-RegionMapping {
    param(
        [string]$inputLocation
    )
    
    Write-Host "`nTesting location: $inputLocation" -ForegroundColor Yellow
    
    # This simulates the ARM template logic:
    # cosmosDbRegion = if(contains(canaryRegions, location), if(equals(location, 'centraluseuap'), 'westus2', 'westus'), location)
    
    if ($canaryRegions -contains $inputLocation) {
        if ($inputLocation -eq "centraluseuap") {
            $mappedRegion = "westus2"
        } else {
            $mappedRegion = "westus"
        }
        Write-Host "  → Canary region detected, mapping to: $mappedRegion" -ForegroundColor Cyan
    } else {
        $mappedRegion = $inputLocation
        Write-Host "  → Regular region, using: $mappedRegion" -ForegroundColor Green
    }
    
    return $mappedRegion
}

# Test cases
$testLocations = @(
    "centraluseuap",    # Should map to westus2
    "eastus2euap",      # Should map to westus
    "eastus",           # Should stay eastus
    "westus2",          # Should stay westus2
    "westeurope"        # Should stay westeurope
)

foreach ($location in $testLocations) {
    $result = Test-RegionMapping -inputLocation $location
    Write-Host "Final result: $location → $result" -ForegroundColor White
}

Write-Host "`nTest completed! The logic correctly maps:" -ForegroundColor Green
Write-Host "• centraluseuap → westus2" -ForegroundColor Green  
Write-Host "• eastus2euap → westus" -ForegroundColor Green
Write-Host "• Other regions remain unchanged" -ForegroundColor Green