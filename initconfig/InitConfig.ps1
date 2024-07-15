## Configuration tool
## Ping an IP address range to test if it is available for use to be assigned
## Replace with the appropriate octets range.
## 
## Sets 
##      IP Address, netmask, gateway and DNS
##      Hostname
##      Timezone, in this case specifically to Eastern Australian Standard Time
##      Enables remote desktops
##      Enables ping (ICMP)


## Require that the command be run with a provided name
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True)]
    [string]$ComputerName
)

$NETADDR='192.168.0.'
$GW='192.168.0.1'
$NETMASK='255.255.255.0'
$PREFIXLENGTH='24'
$DNS='192.168.0.1'

## Foreach loop
200..254 | ForEach-Object {
    $IPADDR="$NETADDR$_"
    Write-Host "Testing if $IPADDR already is in use ..."
    $result = Test-Connection $IPADDR -Count 1 -Quiet

    if ($result -eq $false)
    {
        Write-Host "$IPADDR is Available"
        Write-Host "Setting IP Address to $IPADDR with Netmask $NETMASK using the default Gateway of $GW"
        New-NetIPAddress $IPADDR -InterfaceAlias "Ethernet" -PrefixLength $PREFIXLENGTH -DefaultGateway $GW
        
        Write-Host "Setting DNS Server to use $DNS"
        Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddress $DNS
        Write-Host "Setting computer name to $ComputerName"
        Rename-Computer $ComputerName

        Write-Host "Setting timezone data to E. Australia Standard Time"
        tzutil /s "E. Australia Standard Time"

        Write-Host "Enabling Remote Desktop and setting firewall rules"
        Set-ItemProperty "HKLM:SYSTEM\CurrentControlSet\Control\Terminal Server" -name "fDenyTSConnections" -Value 1
        Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
        Write-Host "Enabling the use of Ping"
        Set-NetFirewallRule -DisplayName "File and Printer Sharing (Echo Request - ICMPv4-In)" -Enable True

        ## Break out of the loop, we are done.
        Break
    }    
}
