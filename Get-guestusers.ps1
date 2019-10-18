$_default_log = $env:userprofile + '\Documents\azuread_guest_accounts.csv'
Get-AzureADUser -Filter "userType eq 'Guest'" -All $true | select DisplayName,`
    UserPrincipalName,Mail,Department,UserType,CreationType,RefreshTokensValidFromDateTime,AccountEnabled,`
    @{name='Licensed';expression={if($_.AssignedLicenses){$TRUE}else{$False}}},`
    @{name='Plan';expression={if($_.AssignedPlans){$TRUE}else{$False}}},ObjectId | export-csv $_default_log -NoTypeInformation -Encoding utf8