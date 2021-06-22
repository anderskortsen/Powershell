######################################################
# Anders Høgedal Kortsen, netIP a/s
# 16/06/2021
# Connects to SFTP, uploads files, moves uploaded files, closes session
######################################################


#Copy files from WeDo share to Exported-Files folder
Robocopy \\192.168.0.9\u\export\upload_til_apps\ *.csv C:\netIP\Exported-Files  /r:1 /w:2 /log:C:\netIP\ExportStatus\ExportlogRobocopy.txt

#Changes encoding to UTF8 and renames files
$Files = Get-ChildItem C:\netIP\Exported-Files\*.csv
ForEach ($File in $Files) {
  Get-Content $File.FullName | Set-Content -Encoding utf8 "C:\netIP\Exported-Files\$($File.Basename + ("_utf8") + $File.Extension)"
}

#Zips files with password
C:\netIP\7zip-alone\7za.exe a -t7z -mx6 -p4LTeaDprdYYf C:\netIP\Exported-Files\PSF.7z C:\netIP\Exported-Files\*_utf8.csv

# Connects to FTP server and uploads .7z file to dest folder
& "C:\Program Files (x86)\WinSCP\WinSCP.com" `
  /log="C:\netIP\WinSCP.log" /ini=nul `
  /command `
    "open ftps://PolitietsSprogforbun:Psf6ewkdj3gksnhf@medlemsinfo.politiets-sprogforbund.dk/" `
    "put -latest C:\netIP\Exported-Files\PSF.7z" `
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

