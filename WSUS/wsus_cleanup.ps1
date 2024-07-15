## Powershell script to cleanup old and obsolete updates, files, and computer records

## Define the WSUS server and port
$WSUSSERVER='WSUSSERVER'
$PORT='8530'

## Perform the clean up process
foreach ($SERVER in $WSUSSERVER.Split(' '))
{
    Write-Host "Cleaning up host: $SERVER"
    Write-Host "Cleaning Obsolete Computers"
    Get-WsusServer -name $SERVER -PortNumber $PORT | Invoke-WsusServerCleanup -CleanupObsoleteComputers
    Write-Host "Cleaning Obsolete Updates"
    Get-WsusServer -name $SERVER -PortNumber $PORT | Invoke-WsusServerCleanup -CleanupObsoleteUpdates
    Write-Host "Cleaning Unneeded Files"
    Get-WsusServer -name $SERVER -PortNumber $PORT | Invoke-WsusServerCleanup -CleanupUnneededContentFiles
}