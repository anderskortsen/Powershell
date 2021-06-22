######################################################
# Anders Høgedal Kortsen
# 16/06/2021
# Connects to SFTP, downloads files, unzip, move, closes session
######################################################

# Connects to FTP server and downloads .7z file to dest folder
& "C:\Program Files (x86)\WinSCP\WinSCP.com" `
  /log="<PATH TO LOG>\WinSCP.log" /ini=nul `
  /command `
  "open ftps://<USERNAME>:<PASSWORD>@<SERVERNAME>/" `
    "get -latest psf-export.7z <PATH TO DOWNLOAD FILE TO>" `
    "rm psf-export.7z" `
    "exit"

$winscpResult = $LastExitCode
if ($winscpResult -eq 0)
{
  Write-Host "Success"
}
else
{
  Write-Host "Error"
}

#Extractes zipped file
<PATH TO 7ZIP ALONE>\7za.exe e "<PATH TO ZIP FILE>"*.7z -p4LTeaDprdYYf -o"<PATH TO EXTRACED FILES>" *.csv -r

#Moves extraced file to WeDo folder
Move-Item -Path "PATH TO EXTRACED FILES"\ExportTransfere*.csv -Destination "<PATH TO FOLDER TO UPLOAD FILES TO>"

#Cleanup moved files 
Remove-Item -Path "<PATH TO DOWNLOADED FILES"\*.*
Remove-Item -Path "<PATH TO EXTRACED FILES"*.*

exit $winscpResult

