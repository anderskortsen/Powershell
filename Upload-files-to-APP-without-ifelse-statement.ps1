######################################################
# Anders Høgedal Kortsen, netIP a/s
# 16/06/2021
# Connects to SFTP, uploads files, moves uploaded files, closes session
######################################################


#Copy files from WeDo share to Exported-Files folder
Robocopy "<PATH TO COPY FILES FROM>"*.csv "<PATH TO DOWNLOAD FILES TO>"  /r:1 /w:2 /log:"<PATH TO LOG>"

#Changes encoding to UTF8 and renames files
$Files = Get-ChildItem "<PATH TO FILES>"\*.csv
ForEach ($File in $Files) {
  Get-Content $File.FullName | Set-Content -Encoding utf8 "<PATH TO EXPORTED FILES>$($File.Basename + ("_utf8") + $File.Extension)"
}

#Zips files with password
<PATH TO 7ZIP ALONE>\7za.exe a -t7z -mx6 -p"<PASSWORD>" "<PATH TO ZIPPED FILES>"\PSF.7z "<PATH TO FILES TO BE ZIPPED>"


# Connects to FTP server and uploads .7z file to dest folder
& "C:\Program Files (x86)\WinSCP\WinSCP.com" `
  /log="<PATH TO LOG>" /ini=nul `
  /command `
    "open ftps://<USERNAME>:<PASSWORD>@<SERVERNAME>/" `
    "put -latest <PATH TO ZIPPED FILE>\PSF.7z" `
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


#Cleans up files after upload
Remove-Item -Path C:\netIP\Exported-Files\*.*

exit $winscpResult

