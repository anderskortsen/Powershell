
#Gets Azure AD Group Member of specific group and then lists all the devices this user registred
$Result=@()
$Users = Get-AzureADGroupMember -ObjectId "911cad46-0b62-4363-ae16-64f8353a46c5" | Select UserPrincipalName,ObjectId
$Users | ForEach-Object {
$user = $_
Get-AzureADUserRegisteredDevice -ObjectId $user.ObjectId | ForEach-Object {
$Result += New-Object PSObject -property @{ 
DeviceOwner = $user.UserPrincipalName
DeviceName = $_.DisplayName
DeviceOSType = $_.DeviceOSType
DeviceOSVersion =$_.DeviceOSVersion
ApproximateLastLogonTimeStamp = $_.ApproximateLastLogonTimeStamp
}
}
}
$Result | Select DeviceOwner,DeviceName,DeviceOSType,DeviceOSVersion,ApproximateLastLogonTimeStamp

#Export results to CSV
#$Result | Export-CSV "C:\Temp\AzureADJoinedDevices.csv" -NoTypeInformation -Encoding UTF8
