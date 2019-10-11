import-module Microsoft.Online.SharePoint.PowerShell
$cred = get-credential
[String]$orgName = "<TenantName>"
[System.Array]$ExternalUsers = ""
[Int]$sitenumber,$currentuser
Write-host "Connecting to site https://$orgname-admin.sharepoint.com"
try {
    Connect-SPOService -Url "https://$orgname-admin.sharepoint.com" -Credential $cred
}
Catch {
    Write-host "Failed to connect"
}

$sites = get-sposite -Limit All
Write-host "found $($sites.count) sites at $orgname"
#get all external users by running
clear-variable sitenumber,currentuser -ErrorAction SilentlyContinue
foreach ($site in $sites) {
    $sitenumber ++
write-progress -Activity "processing site $($site.Title)" -Id 1 -PercentComplete ($sitenumber / $sites.Count * 100)
    $SiteUsers = get-spoexternaluser -SiteUrl $site.url -pagesize 50
    Foreach ($ExternalUser in $SiteUsers) {
        $currentuser ++
        Write-Progress -Activity "processing $($Externaluser.displayname)" -Id 2 -PercentComplete ($currentuser / $siteusers.Count * 100)
        $Guest = [PSCustomObject] @{
            'URL'         = $Site.URL;
            'Site'        = $Site.Title;
            'DisplayName' = $ExternalUser.DisplayName;
            'Email'       = $ExternalUser.Email;
            'Created'     = $ExternalUser.WhenCreated
        }
        
        $ExternalUsers += $guest
    }
    If ($currentuser){clear-variable currentuser}
    
    write-progress -id 2 -Completed -Activity "Done"
}
clear-host
Write-host "Done processing."
Write-host "I found $($ExternalUsers.Count) external users in those $($sites.count) sites"

$ExternalUsers | format-table

Write-host "" 
Write-host -ForegroundColor Yellow "Please note that because of internal PowerShell plumbing, this script can only find a maximum of 50 external users " -NoNewline
Write-host -ForegroundColor Red  "per site"