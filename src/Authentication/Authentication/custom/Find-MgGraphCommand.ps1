﻿# ------------------------------------------------------------------------------
#  Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.
# ------------------------------------------------------------------------------
Set-StrictMode -Version 2

<#
.Synopsis
Find Microsoft Graph PowerShell command meta-info by URI or command name.

.Description
The Find-MgGraphCommand command retrieves meta-info about Microsoft Graph PowerShell commands by URI or command name.

.PARAMETER Uri
The API path a command calls. e.g., /users.

.PARAMETER Method
The HTTP method a command makes.

.PARAMETER ApiVersion
The service API version.

.PARAMETER Command
The name of a command. e.g., Get-MgUser.

.Example
PS C:\> Find-MgGraphCommand -Uri "/users/{id}"

   APIVersion: v1.0

Command       Module Method URI              OutputType           Permissions
-------       ------ ------ ---              ----------           -----------
Get-MgUser    Users  GET    /users/{user-id} IMicrosoftGraphUser1 {DeviceManagementApps.Read.All DeviceManagementApps.Rea…
Remove-MgUser Users  DELETE /users/{user-id}                      {DeviceManagementApps.ReadWrite.All DeviceManagementMan…
Update-MgUser Users  PATCH  /users/{user-id}                      {DeviceManagementApps.ReadWrite.All DeviceManagementMan…

   APIVersion: beta

Command       Module Method URI              OutputType          Permissions
-------       ------ ------ ---              ----------          -----------
Get-MgUser    Users  GET    /users/{user-id} IMicrosoftGraphUser {DeviceManagementApps.Read.All DeviceManagementApps.Read…
Remove-MgUser Users  DELETE /users/{user-id}                     {DeviceManagementApps.ReadWrite.All DeviceManagementMana…
Update-MgUser Users  PATCH  /users/{user-id}                     {DeviceManagementApps.ReadWrite.All DeviceManagementMana…

This example finds all commands that call the provided Microsoft Graph URI.

.Example
PS C:\> Find-MgGraphCommand -Command Send-MgUserMessage -ApiVersion beta

   APIVersion: beta

Command            Module        Method URI                                                         OutputType Permissions
-------            ------        ------ ---                                                         ---------- -----------
Send-MgUserMessage Users.Actions POST   /users/{user-id}/messages/{message-id}/microsoft.graph.send            {Mail.Send}

This example looks up a command with the provided command name that calls the beta version of the API.

.Inputs
Pipeline input accepts API URIs as an array of strings.

.Outputs
Microsoft.Graph.PowerShell.Authentication.Models.IGraphCommand with the following properties:
    1. Command: Name of command.
    2. Module: Module in which a command is defined.
    3. Method: The HTTP method a command makes.
    4. Uri: The Microsoft Graph API URI a command calls.
    5. OutputType: The return type of a command.
    6. Permissions: Permissions needed to use a command. This field can be empty if the permissions are not yet available in Graph Explorer.
    7. Variants: The parameter sets of a command.

.LINK
https://learn.microsoft.com/powershell/microsoftgraph/find-mg-graph-command
#>
Function Find-MgGraphCommand {
    [CmdletBinding(DefaultParameterSetName = 'FindByCommandOrUri', PositionalBinding = $false)]
    [OutputType([Microsoft.Graph.PowerShell.Authentication.Models.IGraphCommand])]
    param (
        [Parameter(ParameterSetName = "FindByUri", Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string[]]$Uri,

        [Parameter(ParameterSetName = "FindByUri")]
        [ValidateSet("GET", "POST", "PUT", "PATCH", "DELETE")]
        [string]$Method,

        [Parameter(ParameterSetName = "FindByCommandOrUri")]
        [Parameter(ParameterSetName = "FindByUri")]
        [Parameter(ParameterSetName = "FindByCommand")]
        [ValidateSet("v1.0", "beta")]
        [string]$ApiVersion,

        [Parameter(ParameterSetName = "FindByCommand", Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [string[]]$Command,

        [Parameter(ParameterSetName = 'FindByCommandOrUri', Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [object[]]$InputObject
    )

    begin {
        # Import utility scripts.
        . "$PSScriptRoot/common/GraphCommand.ps1" | Out-Null
        . "$PSScriptRoot/common/GraphUri.ps1" | Out-Null

        # Read content of metadata file and cache in session object.
        if ($null -ne [Microsoft.Graph.PowerShell.Authentication.GraphSession]::Instance -and
            $null -ne [Microsoft.Graph.PowerShell.Authentication.GraphSession]::Instance.MgCommandMetadata) {
            Write-Debug "Reading MgCommandMetadata from session object."
        }
        else {
            [Microsoft.Graph.PowerShell.Authentication.GraphSession]::Instance.MgCommandMetadata = GraphCommand_ReadGraphCommandMetadata
        }

        function ResolveCommand {
            param(
                [Parameter(Mandatory = $true, Position = 0)]
                [string]$Command
            )

            Write-Debug "Received Command: $Command"

            # Read content of mapping file and cache in session object.
            if ($null -ne [Microsoft.Graph.PowerShell.Authentication.GraphSession]::Instance -and
                $null -ne [Microsoft.Graph.PowerShell.Authentication.GraphSession]::Instance.MgLegacyCommandMapping) {
                Write-Debug "Reading MgLegacyCommandMapping from session object."
            }
            else {
                [Microsoft.Graph.PowerShell.Authentication.GraphSession]::Instance.MgLegacyCommandMapping = GraphCommand_ReadLegacyGraphCommandMapping
            }

            # Resolve legacy commands.
            [array]$ResolvedCommands = [Microsoft.Graph.PowerShell.Authentication.GraphSession]::Instance.MgLegacyCommandMapping | Where-Object LegacyMapping -Contains $Command
            if ($ResolvedCommands) {
                $ResolvedCommands = $ResolvedCommands.Command
            }
            else {
                $ResolvedCommands = $Command
            }
            Write-Debug "Resolved Command: $ResolvedCommands"
            Write-Output $ResolvedCommands -NoEnumerate
        }

        function FindByCommand {
            param(
                [Parameter(Mandatory = $true, Position = 0)]
                [string[]]$Command
            )

            foreach ($c in $Command) {
                $Result = @()
                Write-Debug "Matching Command: $c"
                Write-Debug "Matching ApiVersion: $ApiVersion"
                [Microsoft.Graph.PowerShell.Authentication.GraphSession]::Instance.MgCommandMetadata | ForEach-Object {
                    if ($_.ApiVersion -match $ApiVersion -and
                        $_.Command -match "^$c$") {
                        $Result += [Microsoft.Graph.PowerShell.Authentication.Models.GraphCommand]$_
                    }
                }
                Write-Output $Result -NoEnumerate
            }
        }

        function ResolveUri {
            param(
                [Parameter(Mandatory = $true, Position = 0)]
                [string]$Uri
            )

            $Result = @()
            Write-Debug "Received URI: $Uri."
            $Uri = GraphUri_RemoveNamespaceFromActionFunction $Uri
            $GraphUri = GraphUri_ConvertStringToUri $Uri

            # Use API version in URI if -ApiVersion is not provided.
            if ([System.String]::IsNullOrWhiteSpace($ApiVersion) -and ($GraphUri.OriginalString -match "(v1.0|beta)\/")) {
                $ApiVersion = $Matches[1]
            }

            if (!$GraphUri.IsAbsoluteUri) {
                $GraphUri = GraphUri_ConvertRelativeUriToAbsoluteUri -Uri $GraphUri -ApiVersion $ApiVersion
            }
            Write-Debug "Resolved URI: $GraphUri."

            return $GraphUri
        }

        function FindByUri {
            param(
                [Parameter(Mandatory = $true, Position = 0)]
                [System.Uri]$Uri
            )

            $Result = @()
            $TokenizedUri = GraphUri_TokenizeIds $Uri
            Write-Debug "Tokenized URI: $TokenizedUri."

            $ResourceSegmentRegex = GraphUri_GetResourceSegmentRegex $TokenizedUri
            Write-Debug "Matching URI: $ResourceSegmentRegex"
            Write-Debug "Matching Method: $Method"
            Write-Debug "Matching ApiVersion: $ApiVersion"
            [Microsoft.Graph.PowerShell.Authentication.GraphSession]::Instance.MgCommandMetadata | ForEach-Object {
                if ($_.Method -match $Method -and
                    $_.ApiVersion -match $ApiVersion -and
                    $_.Uri -match $ResourceSegmentRegex) {
                    $Result += [Microsoft.Graph.PowerShell.Authentication.Models.GraphCommand]$_
                }
            }
            Write-Output $Result -NoEnumerate
        }
    }

    process {
        $Result = @()
        try {
            switch ($PSCmdlet.ParameterSetName) {
                "FindByCommandOrUri" {
                    foreach ($o in $InputObject) {
                        if ($o -is [System.Management.Automation.CommandInfo]) {
                            $InputString = $o.Name
                        }
                        else {
                            $InputString = $o
                        }

                        $ResolvedCommand = ResolveCommand $InputString
                        $Result = FindByCommand $ResolvedCommand
                        if ($Result.Count -lt 1) {
                            $GraphUri = ResolveUri $InputString
                            $Result = FindByUri $GraphUri
                        }
                        if ($Result.Count -lt 1) {
                            Write-Error "'$InputString' is not a valid Microsoft Graph PowerShell command. Please check the name and try again."
                            Write-Error "URI '$Method $GraphUri' in $ApiVersion is not valid or is not currently supported by the SDK. Ensure the URI is formatted correctly and try again."
                        }
                    }
                }
                "FindByUri" {
                    foreach ($u in $Uri) {
                        $GraphUri = ResolveUri $u
                        $Result = FindByUri $GraphUri
                        if ($Result.Count -lt 1) {
                            Write-Error "URI '$Method $GraphUri' in $ApiVersion is not valid or is not currently supported by the SDK. Ensure the URI is formatted correctly and try again."
                        }
                    }
                }
                "FindByCommand" {
                    foreach ($c in $Command) {
                        $ResolvedCommand = ResolveCommand $c
                        $Result = FindByCommand $ResolvedCommand
                        if ($Result.Count -lt 1) {
                            Write-Error "'$c' is not a valid Microsoft Graph PowerShell command. Please check the name and try again."
                        }
                    }
                }
            }
        }
        catch {
            Write-Error $_.Exception
        }

        return $Result | Sort-Object @{Expression = "APIVersion"; Descending = $True }, @{Expression = "Command"; Descending = $False }
    }
}
# SIG # Begin signature block
# MIInogYJKoZIhvcNAQcCoIInkzCCJ48CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBLy3X6A6OzBIsY
# CkU47+0vtXWiC/ihGcg+h4+RI6C6SKCCDYUwggYDMIID66ADAgECAhMzAAADTU6R
# phoosHiPAAAAAANNMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMjMwMzE2MTg0MzI4WhcNMjQwMzE0MTg0MzI4WjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQDUKPcKGVa6cboGQU03ONbUKyl4WpH6Q2Xo9cP3RhXTOa6C6THltd2RfnjlUQG+
# Mwoy93iGmGKEMF/jyO2XdiwMP427j90C/PMY/d5vY31sx+udtbif7GCJ7jJ1vLzd
# j28zV4r0FGG6yEv+tUNelTIsFmmSb0FUiJtU4r5sfCThvg8dI/F9Hh6xMZoVti+k
# bVla+hlG8bf4s00VTw4uAZhjGTFCYFRytKJ3/mteg2qnwvHDOgV7QSdV5dWdd0+x
# zcuG0qgd3oCCAjH8ZmjmowkHUe4dUmbcZfXsgWlOfc6DG7JS+DeJak1DvabamYqH
# g1AUeZ0+skpkwrKwXTFwBRltAgMBAAGjggGCMIIBfjAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQUId2Img2Sp05U6XI04jli2KohL+8w
# VAYDVR0RBE0wS6RJMEcxLTArBgNVBAsTJE1pY3Jvc29mdCBJcmVsYW5kIE9wZXJh
# dGlvbnMgTGltaXRlZDEWMBQGA1UEBRMNMjMwMDEyKzUwMDUxNzAfBgNVHSMEGDAW
# gBRIbmTlUAXTgqoXNzcitW2oynUClTBUBgNVHR8ETTBLMEmgR6BFhkNodHRwOi8v
# d3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NybC9NaWNDb2RTaWdQQ0EyMDExXzIw
# MTEtMDctMDguY3JsMGEGCCsGAQUFBwEBBFUwUzBRBggrBgEFBQcwAoZFaHR0cDov
# L3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9jZXJ0cy9NaWNDb2RTaWdQQ0EyMDEx
# XzIwMTEtMDctMDguY3J0MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQELBQADggIB
# ACMET8WuzLrDwexuTUZe9v2xrW8WGUPRQVmyJ1b/BzKYBZ5aU4Qvh5LzZe9jOExD
# YUlKb/Y73lqIIfUcEO/6W3b+7t1P9m9M1xPrZv5cfnSCguooPDq4rQe/iCdNDwHT
# 6XYW6yetxTJMOo4tUDbSS0YiZr7Mab2wkjgNFa0jRFheS9daTS1oJ/z5bNlGinxq
# 2v8azSP/GcH/t8eTrHQfcax3WbPELoGHIbryrSUaOCphsnCNUqUN5FbEMlat5MuY
# 94rGMJnq1IEd6S8ngK6C8E9SWpGEO3NDa0NlAViorpGfI0NYIbdynyOB846aWAjN
# fgThIcdzdWFvAl/6ktWXLETn8u/lYQyWGmul3yz+w06puIPD9p4KPiWBkCesKDHv
# XLrT3BbLZ8dKqSOV8DtzLFAfc9qAsNiG8EoathluJBsbyFbpebadKlErFidAX8KE
# usk8htHqiSkNxydamL/tKfx3V/vDAoQE59ysv4r3pE+zdyfMairvkFNNw7cPn1kH
# Gcww9dFSY2QwAxhMzmoM0G+M+YvBnBu5wjfxNrMRilRbxM6Cj9hKFh0YTwba6M7z
# ntHHpX3d+nabjFm/TnMRROOgIXJzYbzKKaO2g1kWeyG2QtvIR147zlrbQD4X10Ab
# rRg9CpwW7xYxywezj+iNAc+QmFzR94dzJkEPUSCJPsTFMIIHejCCBWKgAwIBAgIK
# YQ6Q0gAAAAAAAzANBgkqhkiG9w0BAQsFADCBiDELMAkGA1UEBhMCVVMxEzARBgNV
# BAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jv
# c29mdCBDb3Jwb3JhdGlvbjEyMDAGA1UEAxMpTWljcm9zb2Z0IFJvb3QgQ2VydGlm
# aWNhdGUgQXV0aG9yaXR5IDIwMTEwHhcNMTEwNzA4MjA1OTA5WhcNMjYwNzA4MjEw
# OTA5WjB+MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UE
# BxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSgwJgYD
# VQQDEx9NaWNyb3NvZnQgQ29kZSBTaWduaW5nIFBDQSAyMDExMIICIjANBgkqhkiG
# 9w0BAQEFAAOCAg8AMIICCgKCAgEAq/D6chAcLq3YbqqCEE00uvK2WCGfQhsqa+la
# UKq4BjgaBEm6f8MMHt03a8YS2AvwOMKZBrDIOdUBFDFC04kNeWSHfpRgJGyvnkmc
# 6Whe0t+bU7IKLMOv2akrrnoJr9eWWcpgGgXpZnboMlImEi/nqwhQz7NEt13YxC4D
# dato88tt8zpcoRb0RrrgOGSsbmQ1eKagYw8t00CT+OPeBw3VXHmlSSnnDb6gE3e+
# lD3v++MrWhAfTVYoonpy4BI6t0le2O3tQ5GD2Xuye4Yb2T6xjF3oiU+EGvKhL1nk
# kDstrjNYxbc+/jLTswM9sbKvkjh+0p2ALPVOVpEhNSXDOW5kf1O6nA+tGSOEy/S6
# A4aN91/w0FK/jJSHvMAhdCVfGCi2zCcoOCWYOUo2z3yxkq4cI6epZuxhH2rhKEmd
# X4jiJV3TIUs+UsS1Vz8kA/DRelsv1SPjcF0PUUZ3s/gA4bysAoJf28AVs70b1FVL
# 5zmhD+kjSbwYuER8ReTBw3J64HLnJN+/RpnF78IcV9uDjexNSTCnq47f7Fufr/zd
# sGbiwZeBe+3W7UvnSSmnEyimp31ngOaKYnhfsi+E11ecXL93KCjx7W3DKI8sj0A3
# T8HhhUSJxAlMxdSlQy90lfdu+HggWCwTXWCVmj5PM4TasIgX3p5O9JawvEagbJjS
# 4NaIjAsCAwEAAaOCAe0wggHpMBAGCSsGAQQBgjcVAQQDAgEAMB0GA1UdDgQWBBRI
# bmTlUAXTgqoXNzcitW2oynUClTAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTAL
# BgNVHQ8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBRyLToCMZBD
# uRQFTuHqp8cx0SOJNDBaBgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3JsLm1pY3Jv
# c29mdC5jb20vcGtpL2NybC9wcm9kdWN0cy9NaWNSb29DZXJBdXQyMDExXzIwMTFf
# MDNfMjIuY3JsMF4GCCsGAQUFBwEBBFIwUDBOBggrBgEFBQcwAoZCaHR0cDovL3d3
# dy5taWNyb3NvZnQuY29tL3BraS9jZXJ0cy9NaWNSb29DZXJBdXQyMDExXzIwMTFf
# MDNfMjIuY3J0MIGfBgNVHSAEgZcwgZQwgZEGCSsGAQQBgjcuAzCBgzA/BggrBgEF
# BQcCARYzaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9kb2NzL3ByaW1h
# cnljcHMuaHRtMEAGCCsGAQUFBwICMDQeMiAdAEwAZQBnAGEAbABfAHAAbwBsAGkA
# YwB5AF8AcwB0AGEAdABlAG0AZQBuAHQALiAdMA0GCSqGSIb3DQEBCwUAA4ICAQBn
# 8oalmOBUeRou09h0ZyKbC5YR4WOSmUKWfdJ5DJDBZV8uLD74w3LRbYP+vj/oCso7
# v0epo/Np22O/IjWll11lhJB9i0ZQVdgMknzSGksc8zxCi1LQsP1r4z4HLimb5j0b
# pdS1HXeUOeLpZMlEPXh6I/MTfaaQdION9MsmAkYqwooQu6SpBQyb7Wj6aC6VoCo/
# KmtYSWMfCWluWpiW5IP0wI/zRive/DvQvTXvbiWu5a8n7dDd8w6vmSiXmE0OPQvy
# CInWH8MyGOLwxS3OW560STkKxgrCxq2u5bLZ2xWIUUVYODJxJxp/sfQn+N4sOiBp
# mLJZiWhub6e3dMNABQamASooPoI/E01mC8CzTfXhj38cbxV9Rad25UAqZaPDXVJi
# hsMdYzaXht/a8/jyFqGaJ+HNpZfQ7l1jQeNbB5yHPgZ3BtEGsXUfFL5hYbXw3MYb
# BL7fQccOKO7eZS/sl/ahXJbYANahRr1Z85elCUtIEJmAH9AAKcWxm6U/RXceNcbS
# oqKfenoi+kiVH6v7RyOA9Z74v2u3S5fi63V4GuzqN5l5GEv/1rMjaHXmr/r8i+sL
# gOppO6/8MO0ETI7f33VtY5E90Z1WTk+/gFcioXgRMiF670EKsT/7qMykXcGhiJtX
# cVZOSEXAQsmbdlsKgEhr/Xmfwb1tbWrJUnMTDXpQzTGCGXMwghlvAgEBMIGVMH4x
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01p
# Y3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTECEzMAAANNTpGmGiiweI8AAAAA
# A00wDQYJYIZIAWUDBAIBBQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQw
# HAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIDVH
# 37apnueQVSuf2QFWMEUf6+vBRm/dlNsSiSwtgSVpMEIGCisGAQQBgjcCAQwxNDAy
# oBSAEgBNAGkAYwByAG8AcwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20wDQYJKoZIhvcNAQEBBQAEggEAE6tikuTXE42UTA4iNJg82aI/PF64iLKMxo54
# crqTwSySSwdb7ZqbxeySgO1vZGhQUMvnp0JKsDUEB8Re1j/rcT3siS/fjcu84ls9
# oRmxD6RYZb6h6zGHpgcimipBa4C7yhYr/KQIFSjBvjoxKzMwzAESVvmQUPtooQk5
# sdcTRGIentf63xnYCu8866AegJoxOV8cfC3AdePILGJRgYj1liLO0GNUN/Wfoloo
# a5Re7ENhPBdc2cKWWzSdrq+Zt//po87uTFIRUQ0KyQasKD77qKpsU2C3HgRs+tGp
# Dyn/ejQBVN8yXTM8mxa3kE4pBGOx4r967HLw6EGQoYEzhfVlLKGCFv0wghb5Bgor
# BgEEAYI3AwMBMYIW6TCCFuUGCSqGSIb3DQEHAqCCFtYwghbSAgEDMQ8wDQYJYIZI
# AWUDBAIBBQAwggFRBgsqhkiG9w0BCRABBKCCAUAEggE8MIIBOAIBAQYKKwYBBAGE
# WQoDATAxMA0GCWCGSAFlAwQCAQUABCA/Ms3PRh2HWf2ns3xgOruAwsr0m98NM5Sj
# X+UjhPWVMAIGZLA0cqwfGBMyMDIzMDcxODIzNTAxNS44MTdaMASAAgH0oIHQpIHN
# MIHKMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQL
# ExxNaWNyb3NvZnQgQW1lcmljYSBPcGVyYXRpb25zMSYwJAYDVQQLEx1UaGFsZXMg
# VFNTIEVTTjpFNUE2LUUyN0MtNTkyRTElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUt
# U3RhbXAgU2VydmljZaCCEVQwggcMMIIE9KADAgECAhMzAAABvvQgou6W1iDWAAEA
# AAG+MA0GCSqGSIb3DQEBCwUAMHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNo
# aW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29y
# cG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEw
# MB4XDTIyMTEwNDE5MDEyMloXDTI0MDIwMjE5MDEyMlowgcoxCzAJBgNVBAYTAlVT
# MRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQK
# ExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJTAjBgNVBAsTHE1pY3Jvc29mdCBBbWVy
# aWNhIE9wZXJhdGlvbnMxJjAkBgNVBAsTHVRoYWxlcyBUU1MgRVNOOkU1QTYtRTI3
# Qy01OTJFMSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNlMIIC
# IjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEApV/y2z7Da7nMu0tykLY8olh7
# Z03EqFNz3iFlMp9gOfVmZABmheCc87RuPdQ2P+OHUJiqCQAWNuNSoI/Q1ixEw9AA
# 657ldD8Z3/EktpmxKHHavOhwQSFPcpTGFVXIxKCwoO824giyHPG84dfhdi6WU7f7
# D+85LaPB0dOsPHKKMGlC9p66Lv9yQzvAhZGFmFhlusCy/egrz6JX/OHOT9qCwugh
# rL0IPf47ULe1pQSEEihy438JwS+rZU4AVyvQczlMC26XsTuDPgEQKlzx9ru7EvNV
# 99l/KCU9bbFf5SnkN1moUgKUq09NWlKxzLGEvhke2QNMopn86Jh1fl/PVevN/xrZ
# SpV23rM4lB7lh7XSsCPeFslTYojKN2ioOC6p3By7kEmvZCh6rAsPKsARJISdzKQC
# Mq+mqDuiP6mr/LvuWKinP+2ZGmK/C1/skvlTjtIehu50yoXNDlh1CN9B3QLglQY+
# UCBEqJog/BxAn3pWdR01o/66XIacgXI/d0wG2/x0OtbjEGAkacfQlmw0bDc02dhQ
# Fki/1Q9Vbwh4kC7VgAiJA8bC5zEIYWHNU7C+He69B4/2dZpRjgd5pEpHbF9OYiAf
# 7s5MnYEnHN/5o/bGO0ajAb7VI4f9av62sC6xvhKTB5R4lhxEMWF0z4v7BQ5CHyMN
# kL+oTnzJLqnLVdXnuM0CAwEAAaOCATYwggEyMB0GA1UdDgQWBBTrKiAWoYRBoPGt
# bwvbhhX6a2+iqjAfBgNVHSMEGDAWgBSfpxVdAF5iXYP05dJlpxtTNRnpcjBfBgNV
# HR8EWDBWMFSgUqBQhk5odHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2Ny
# bC9NaWNyb3NvZnQlMjBUaW1lLVN0YW1wJTIwUENBJTIwMjAxMCgxKS5jcmwwbAYI
# KwYBBQUHAQEEYDBeMFwGCCsGAQUFBzAChlBodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20vcGtpb3BzL2NlcnRzL01pY3Jvc29mdCUyMFRpbWUtU3RhbXAlMjBQQ0ElMjAy
# MDEwKDEpLmNydDAMBgNVHRMBAf8EAjAAMBMGA1UdJQQMMAoGCCsGAQUFBwMIMA0G
# CSqGSIb3DQEBCwUAA4ICAQDHlfu9c0ImhdBis1yj56bBvOSyGpC/rSSty+1F49Tf
# 6fmFEeqxhwTTHVHOeIRNd8gcDLSz0d79mXCqq8ynq6gJgy2u4LyyAr2LmwzFVuux
# oGVR8YuUnRtvsDH5J+unye/nMkwHiC+G82h3uQ8fcGj+2H0nKPmUpUtfQruMUXvz
# LjV5NyRjDiCL5c/f5ecmz01dnpnCvE6kIz/FTpkvOeVJk22I2akFZhPz24D6OT6K
# kTtwBRpSEHDYqCQ4cZ+7SXx7jzzd7b+0p9vDboqCy7SwWgKpGQG+wVbKrTm4hKkZ
# DzcdAEgYqehXz78G00mYILiDTyUikwQpoZ7am9pA6BdTPY+o1v6CRzcneIOnJYan
# HWz0R+KER/ZRFtLCyBMvLzSHEn0sR0+0kLklncKjGdA1YA42zOb611UeIGytZ9Vh
# Nwn4ws5GJ6n6PJmMPO+yPEkOy2f8OBiuhaqlipiWhzGtt5UsC0geG0sW9qwa4QAW
# 1sQWIrhSl24MOOVwNl/Am9/ZqvLRWr1x4nupeR8G7+DNyn4MTg28yFZRU1ktSvyB
# MUSvN2K99BO6p1gSx/wvSsR45dG33PDG5fKqHOgDxctjBU5bX49eJqjNL7S/UndL
# F7S0OWL9mdk/jPVHP2I6XtN0K4VjdRwvIgr3jNib3GZyGJnORp/ZMbY2Dv1mKcx7
# dTCCB3EwggVZoAMCAQICEzMAAAAVxedrngKbSZkAAAAAABUwDQYJKoZIhvcNAQEL
# BQAwgYgxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQH
# EwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xMjAwBgNV
# BAMTKU1pY3Jvc29mdCBSb290IENlcnRpZmljYXRlIEF1dGhvcml0eSAyMDEwMB4X
# DTIxMDkzMDE4MjIyNVoXDTMwMDkzMDE4MzIyNVowfDELMAkGA1UEBhMCVVMxEzAR
# BgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1p
# Y3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3Rh
# bXAgUENBIDIwMTAwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDk4aZM
# 57RyIQt5osvXJHm9DtWC0/3unAcH0qlsTnXIyjVX9gF/bErg4r25PhdgM/9cT8dm
# 95VTcVrifkpa/rg2Z4VGIwy1jRPPdzLAEBjoYH1qUoNEt6aORmsHFPPFdvWGUNzB
# RMhxXFExN6AKOG6N7dcP2CZTfDlhAnrEqv1yaa8dq6z2Nr41JmTamDu6GnszrYBb
# fowQHJ1S/rboYiXcag/PXfT+jlPP1uyFVk3v3byNpOORj7I5LFGc6XBpDco2LXCO
# Mcg1KL3jtIckw+DJj361VI/c+gVVmG1oO5pGve2krnopN6zL64NF50ZuyjLVwIYw
# XE8s4mKyzbnijYjklqwBSru+cakXW2dg3viSkR4dPf0gz3N9QZpGdc3EXzTdEonW
# /aUgfX782Z5F37ZyL9t9X4C626p+Nuw2TPYrbqgSUei/BQOj0XOmTTd0lBw0gg/w
# EPK3Rxjtp+iZfD9M269ewvPV2HM9Q07BMzlMjgK8QmguEOqEUUbi0b1qGFphAXPK
# Z6Je1yh2AuIzGHLXpyDwwvoSCtdjbwzJNmSLW6CmgyFdXzB0kZSU2LlQ+QuJYfM2
# BjUYhEfb3BvR/bLUHMVr9lxSUV0S2yW6r1AFemzFER1y7435UsSFF5PAPBXbGjfH
# CBUYP3irRbb1Hode2o+eFnJpxq57t7c+auIurQIDAQABo4IB3TCCAdkwEgYJKwYB
# BAGCNxUBBAUCAwEAATAjBgkrBgEEAYI3FQIEFgQUKqdS/mTEmr6CkTxGNSnPEP8v
# BO4wHQYDVR0OBBYEFJ+nFV0AXmJdg/Tl0mWnG1M1GelyMFwGA1UdIARVMFMwUQYM
# KwYBBAGCN0yDfQEBMEEwPwYIKwYBBQUHAgEWM2h0dHA6Ly93d3cubWljcm9zb2Z0
# LmNvbS9wa2lvcHMvRG9jcy9SZXBvc2l0b3J5Lmh0bTATBgNVHSUEDDAKBggrBgEF
# BQcDCDAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTALBgNVHQ8EBAMCAYYwDwYD
# VR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBTV9lbLj+iiXGJo0T2UkFvXzpoYxDBW
# BgNVHR8ETzBNMEugSaBHhkVodHRwOi8vY3JsLm1pY3Jvc29mdC5jb20vcGtpL2Ny
# bC9wcm9kdWN0cy9NaWNSb29DZXJBdXRfMjAxMC0wNi0yMy5jcmwwWgYIKwYBBQUH
# AQEETjBMMEoGCCsGAQUFBzAChj5odHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtp
# L2NlcnRzL01pY1Jvb0NlckF1dF8yMDEwLTA2LTIzLmNydDANBgkqhkiG9w0BAQsF
# AAOCAgEAnVV9/Cqt4SwfZwExJFvhnnJL/Klv6lwUtj5OR2R4sQaTlz0xM7U518Jx
# Nj/aZGx80HU5bbsPMeTCj/ts0aGUGCLu6WZnOlNN3Zi6th542DYunKmCVgADsAW+
# iehp4LoJ7nvfam++Kctu2D9IdQHZGN5tggz1bSNU5HhTdSRXud2f8449xvNo32X2
# pFaq95W2KFUn0CS9QKC/GbYSEhFdPSfgQJY4rPf5KYnDvBewVIVCs/wMnosZiefw
# C2qBwoEZQhlSdYo2wh3DYXMuLGt7bj8sCXgU6ZGyqVvfSaN0DLzskYDSPeZKPmY7
# T7uG+jIa2Zb0j/aRAfbOxnT99kxybxCrdTDFNLB62FD+CljdQDzHVG2dY3RILLFO
# Ry3BFARxv2T5JL5zbcqOCb2zAVdJVGTZc9d/HltEAY5aGZFrDZ+kKNxnGSgkujhL
# mm77IVRrakURR6nxt67I6IleT53S0Ex2tVdUCbFpAUR+fKFhbHP+CrvsQWY9af3L
# wUFJfn6Tvsv4O+S3Fb+0zj6lMVGEvL8CwYKiexcdFYmNcP7ntdAoGokLjzbaukz5
# m/8K6TT4JDVnK+ANuOaMmdbhIurwJ0I9JZTmdHRbatGePu1+oDEzfbzL6Xu/OHBE
# 0ZDxyKs6ijoIYn/ZcGNTTY3ugm2lBRDBcQZqELQdVTNYs6FwZvKhggLLMIICNAIB
# ATCB+KGB0KSBzTCByjELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24x
# EDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlv
# bjElMCMGA1UECxMcTWljcm9zb2Z0IEFtZXJpY2EgT3BlcmF0aW9uczEmMCQGA1UE
# CxMdVGhhbGVzIFRTUyBFU046RTVBNi1FMjdDLTU5MkUxJTAjBgNVBAMTHE1pY3Jv
# c29mdCBUaW1lLVN0YW1wIFNlcnZpY2WiIwoBATAHBgUrDgMCGgMVAGitWlL3vPu8
# ENOAe+i2+4wfTMB7oIGDMIGApH4wfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldh
# c2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBD
# b3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIw
# MTAwDQYJKoZIhvcNAQEFBQACBQDoYUoWMCIYDzIwMjMwNzE5MDEyNzUwWhgPMjAy
# MzA3MjAwMTI3NTBaMHQwOgYKKwYBBAGEWQoEATEsMCowCgIFAOhhShYCAQAwBwIB
# AAICDVAwBwIBAAICEdkwCgIFAOhim5YCAQAwNgYKKwYBBAGEWQoEAjEoMCYwDAYK
# KwYBBAGEWQoDAqAKMAgCAQACAwehIKEKMAgCAQACAwGGoDANBgkqhkiG9w0BAQUF
# AAOBgQBXPLD6t5NOMuvMjwbL3lKQ5GtX/k8FUf/W33uoIJWXq0ue1OXpOjHuqGpH
# ueuwSsFXb0bATnADN6g50RBAGnpCZ8iDDeG84nPlLkVogpSMNjgSevN0stVlEC8m
# MWzrnLm16AMSsjPDkQiRBaFbnRPVPxnenBqVz+sGy5kY9JT7bTGCBA0wggQJAgEB
# MIGTMHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQH
# EwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNV
# BAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwAhMzAAABvvQgou6W1iDW
# AAEAAAG+MA0GCWCGSAFlAwQCAQUAoIIBSjAaBgkqhkiG9w0BCQMxDQYLKoZIhvcN
# AQkQAQQwLwYJKoZIhvcNAQkEMSIEIJFM3/vjPDcemR9RrNY7bFR71eCN+Y46EhPO
# mboQRueiMIH6BgsqhkiG9w0BCRACLzGB6jCB5zCB5DCBvQQglO6Kr632/Oy9ZbXP
# rhEPidNAg/Fef7K3SZg+DxjhDC8wgZgwgYCkfjB8MQswCQYDVQQGEwJVUzETMBEG
# A1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWlj
# cm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFt
# cCBQQ0EgMjAxMAITMwAAAb70IKLultYg1gABAAABvjAiBCAKZyzAiZPs5daQwtUC
# NkrZpB6KWgFs8cBd7WU03cn9KTANBgkqhkiG9w0BAQsFAASCAgA/EiKl8hutg3O0
# 8rrVcpr+WimUbyvp9qA/WxW+HUBL2DRSVPb1VxV4TVQoR3JRRhE3HzIbAsTk8Ilo
# 29yweiha2fXPBY3vWwJn6iD/ozAHzz0uQJauEiS7T88ZbZ2Bp+xBbTqnKIUPr8kj
# h6qDPJA7fHps4Lk+/WFgm9sFnEhQnti804AG7BOq7xbwt+8lZ3TjFTscC1iUE9XB
# Gz9/aB369MV8b6Gkqf8AjJJFc19bDDJTdkQ1HB+11x2OKXFsB4JSQTx0nMey1OAc
# pm/sXw7Lu/1ggUfjz/SrOF9jLs2yaOkqNTPtfXQalI0uRRve1C+LYPGvmKhdK02v
# fauVbgiXvisNi3b4gzU/7qqQ69SYTRK9caQnaPy/iU+b4xJrI/xx3yac8jo6nsUF
# B3wJAFcT5+aeLhXOALTPpAsZMizXxkJOeiuDqZSo4pWDrX4WjRoqrcJBG4+O7vxb
# e2kHr7hWLBxR3WAHWbdQA8dpJKBgNrN16y0ceB5an9OX6E14ufhB5vF7G846rqkP
# VLnBhX/UC/0dvKKt/L9ZOnxDopn8moD9+urCGCXhqJCLkK7NgPlc3yAXQt7FCR9m
# D1ZBj2EX46mT8Qk7kJILeWgFSKvpcKJly4mcQSoVQWiiX9CkAH2xKev7rpm1o2BW
# a+OT6Yhup8JXZgJ0Up+DOl8cPN4jYw==
# SIG # End signature block
