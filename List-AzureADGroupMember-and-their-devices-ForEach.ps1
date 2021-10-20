Connect-AzureAD

$GroupMembers = Get-AzureADGroupMember -ObjectId "911cad46-0b62-4363-ae16-64f8353a46c5"

ForEach ($GroupMember in $GroupMembers) {
    Get-AzureADUserRegisteredDevice -ObjectId $GroupMember.ObjectId
}
