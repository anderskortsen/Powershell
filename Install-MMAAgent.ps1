$Servers = Import-Csv -Path "C:\TEMP\Hosts.csv" | Select-Object Hostname

$WorkspaceID = "d4b88a3f-df69-436e-86cb-e996d5b792f6"
$WorkspaceKey = "IcKKlD0sEoiv9kVLVADPUptKP+N2XXBYNC5SRM50nwp1Sok7wEuvozxWUbwZhJJDL2p0MqWntqegB24nrbtrSg=="
$InstallerPath = "\\Sen-dc1\Agent-Deployment\MMASetup-AMD64.exe"

ForEach ($Server in $Servers) {

    Invoke-Command -Computername $Server.Hostname -ScriptBlock {

        Install-OMSAgents -ComputerName Localhost -WorkspaceID $WorkspaceID -WorkspaceKey $WorkspaceKey -InstallerPath $InstallerPath 

    }
}   

