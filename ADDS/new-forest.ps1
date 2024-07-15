[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True)]
    [string]$DomainName

    [Parameter(Mandatory=$True)]
    [string]$DomainNetBIOSName
)

Install-ADDSForest `
    -DomainName $DomainName `
    -DomainNetBIOSName $DomainNetBIOSName `
    -ForestMode "7" `
    -DomainMode "7" `
    -InstallDNS:$true `
    -NoRebootOnCompletion:$true
    -Force:$true