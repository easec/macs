# Anslut till Microsoft Graph och Azure
Connect-MgGraph -Scopes "Organization.Read.All","Domain.Read.All"
Connect-AzAccount -UseDeviceAuthentication

# Hämta kundinformation
$org = Get-MgOrganization
$domain = Get-MgDomain | Where-Object { $_.IsInitial -eq $true }

# Hämta prenumerationer i kundens tenant
$subscriptions = Get-AzSubscription -TenantId $org.Id |
    Where-Object {
        $_.Name -match 'identity|management|connectivity'
    }

# Visa kundinformation
[PSCustomObject]@{
    CustomerName = $org.DisplayName
    TenantId     = $org.Id
    TenantDomain = $domain.Id
} | Format-List

# Visa matchande prenumerationer
$subscriptions |
    Select-Object Name, Id, State |
    Format-Table -AutoSize
