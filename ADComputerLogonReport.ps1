# Import the Active Directory module
Import-Module ActiveDirectory

# Function to prompt for a yes/no response
function Prompt-YesNo($message) {
    do {
        $response = Read-Host "$message (y/n)"
    } while ($response -notmatch '^(y|n)$')
    Write-Host ""
    return $response -eq 'y'
}

# Prompt the user to specify the AD server (or domain controller)
$adServer = Read-Host "Enter the FQDN or name of the Active Directory server (e.g., DC01 or dc01.contoso.com)"
Write-Host ""

# Determine if the user wants to filter by OU or query the entire domain
if (Prompt-YesNo "Would you like to filter by a specific OU or container?") {
    # Ask the user to provide the OU or container name
    $ouName = Read-Host "Enter the name of the OU or container (e.g., 'Computers')"
    Write-Host ""

    # Search for the specified name in both OUs and containers
    $ouObject = Get-ADOrganizationalUnit -Server $adServer -Filter "Name -eq '$ouName'" -ErrorAction SilentlyContinue
    $cnObject = Get-ADObject -Server $adServer -Filter "Name -eq '$ouName' -and ObjectClass -eq 'container'" -ErrorAction SilentlyContinue

    if ($ouObject) {
        $searchBase = $ouObject.DistinguishedName
        Write-Host "Found OU '$ouName'. Using search base: $searchBase"
    } elseif ($cnObject) {
        $searchBase = $cnObject.DistinguishedName
        Write-Host "Found container '$ouName'. Using search base: $searchBase"
    } else {
        Write-Host "OU or container '$ouName' not found on server '$adServer'. Exiting." -ForegroundColor Red
        exit
    }
    Write-Host ""
} else {
    # Get the default domain's distinguished name as the search base
    $searchBase = (Get-ADDomain -Server $adServer).DistinguishedName
    Write-Host "No specific OU or container selected. Using the domain's root as the search base: $searchBase"
    Write-Host ""
}

# Get computer objects and last logon information
$computers = Get-ADComputer -Filter * -Server $adServer -SearchBase $searchBase -Properties LastLogonDate |
    Select-Object Name, @{Name='LastLogonDate';Expression={$_.LastLogonDate}} |
    Where-Object { $_.LastLogonDate -ne $null } |
    Sort-Object LastLogonDate -Descending

# Display results
if ($computers.Count -eq 0) {
    Write-Host "No computers found with last logon information." -ForegroundColor Yellow
    Write-Host ""
} else {
    Write-Host "Computers sorted by last logon date:" -ForegroundColor Green
    $computers | Format-Table -AutoSize
    Write-Host ""
}

# Optionally export to CSV
if (Prompt-YesNo "Would you like to export the results to a CSV file?") {
    $csvPath = Read-Host "Enter the full file path for the CSV (e.g., C:\Temp\ADComputers.csv)"
    Write-Host ""
    $computers | Export-Csv -Path $csvPath -NoTypeInformation -Force
    Write-Host "Results exported to $csvPath" -ForegroundColor Green
    Write-Host ""
}