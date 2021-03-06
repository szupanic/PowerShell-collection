﻿function Get-LocalIpAddresses
{
   <#
         .SYNOPSIS
         Print a string with all IP addresses
	
         .DESCRIPTION
         Print a string with all IP addresses. Supports IPv4 and IPv6.
         It filters IPv6 Link Local only addresses by default.
	
         .PARAMETER TargetName
         Specifies the computers to test. Type the computer names or type IP addresses in IPv4 or IPv6 format. Wildcard characters are not permitted. The defaul is localhost.
	
         .PARAMETER IPv6LinkLocal
         Retuns IPv6 Link Local only addresses? Off by default.
	
         .EXAMPLE
         PS C:\> Get-LocalIpAddresses
         Print a string with all local IP addresses

         .EXAMPLE
         PS C:\> Get-LocalIpAddresses -TargetName 'mycomputer'
         Print a string with all IP addresses for the computer 'mycomputer'
	
         .NOTES
         TODO: Remove the -TargetName in the next release! Makes no sense (only IPv4 is returned)
   #>
	
   [CmdletBinding(ConfirmImpact = 'None')]
   [OutputType([string])]
   param
   (
      [Parameter(ValueFromPipeline,
            ValueFromPipelineByPropertyName,
      Position = 1)]
      [ValidateNotNullOrEmpty()]
      [string]
      $TargetName = $env:COMPUTERNAME,
      [Parameter(ValueFromPipeline,
            ValueFromPipelineByPropertyName,
      Position = 2)]
      [Alias('IsIPv6LinkLocal')]
      [switch]
      $IPv6LinkLocal
   )
	
   begin
   {
      $IpInfo = $null
   }
	
   process
   {
      $IpInfo = ($TargetName | ForEach-Object -Process {
            (([Net.DNS]::GetHostAddresses([Net.Dns]::GetHostByName($_).HostName) | Where-Object -FilterScript {
                     $_.IsIPv6LinkLocal -eq $IPv6LinkLocal
            }).IPAddressToString)
      })
   }
	
   end
   {
      # Dump to the Console
      $IpInfo
   }
}
     