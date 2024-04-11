# ------------------------------------------------------------------------------
#  Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.
# ------------------------------------------------------------------------------

Set-StrictMode -Version 2

function GraphCommand_ReadGraphCommandMetadata {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string]$Path = (Join-Path $PSScriptRoot "MgCommandMetadata.json")
    )
    if (!(Test-Path $Path)) {
        throw "MgCommandMetadata file not found at $Path."
    }

    $Result = @{}
    try {
        Write-Debug "Reading MgCommandMetadata from file path - $Path."
        $FileProvider = [Microsoft.Graph.PowerShell.Authentication.Common.ProtectedFileProvider]::CreateFileProvider($Path, [Microsoft.Graph.PowerShell.Authentication.Common.FileProtection]::SharedRead)
        if ($PSEdition -eq "Core") {
            $Result = $FileProvider.CreateReader().ReadToEnd() | ConvertFrom-Json -AsHashtable
        }
        else {
            $DeserializationError = $null
            $Result = [Microsoft.Graph.PowerShell.Authentication.Helpers.StringUtil]::ConvertFromJson($FileProvider.CreateReader().ReadToEnd(), $true, 4, [ref] $DeserializationError)
            if ($null -ne $DeserializationError) { throw $DeserializationError }
        }
    }
    finally {
        $FileProvider.Dispose()
    }
    return $Result
}

function GraphCommand_ReadLegacyGraphCommandMapping {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string]$Path = (Join-Path $PSScriptRoot "MgLegacyCommandMapping.json")    )
    if (!(Test-Path $Path)) {
        throw "MgLegacyCommandMapping file not found at $Path."
    }

    ## The following command will produce new json content for "MgLegacyCommandMapping.json" containing the latest cmdlet mappings from documentation.
    # Invoke-WebRequest 'https://learn.microsoft.com/en-us/powershell/microsoftgraph/azuread-msoline-cmdlet-map?view=graph-powershell-1.0' | Select-Object -ExpandProperty Content | Select-String -Pattern '<td>([a-z0-9-]+).*?</td>\s?<td><a href=.*?>([a-z0-9-]+).*?</a>(?:.*?<a href=.*?>([a-z0-9-]+).*?</a>)?(?:.*?<a href=.*?>([a-z0-9-]+).*?</a>)?' -AllMatches | Select-Object -ExpandProperty Matches | ForEach-Object { for ($i = 2; $i -lt $_.Groups.Count; $i++) { if ($_.Groups[$i].Index) { @{ LegacyMapping = $_.Groups[1].Value; Command = $_.Groups[$i].Value } } } } | Group-Object Command | ForEach-Object { [pscustomobject][ordered]@{ Command = $_.Name; LegacyMapping = [string[]]$_.Group.LegacyMapping } } | ConvertTo-Json
    ## The following command will produce new json content for "MgLegacyCommandMapping.json" containing the latest cmdlet mappings from documentation markdown.
    # Invoke-WebRequest 'https://github.com/MicrosoftDocs/microsoftgraph-docs-powershell/raw/main/microsoftgraph/docs-conceptual/azuread-msoline-cmdlet-map.md' | Select-Object -ExpandProperty Content | Select-String -Pattern '[|]([a-z0-9][a-z0-9-]+).*?\|\[([a-z0-9-]+)(?:.*?\[([a-z0-9-]+))?(?:.*?\[([a-z0-9-]+))?' -AllMatches | Select-Object -ExpandProperty Matches | ForEach-Object { for ($i = 2; $i -lt $_.Groups.Count; $i++) { if ($_.Groups[$i].Index) { @{ LegacyMapping = $_.Groups[1].Value; Command = $_.Groups[$i].Value } } } } | Group-Object Command | ForEach-Object { [pscustomobject][ordered]@{ Command = $_.Name; LegacyMapping = [string[]]$_.Group.LegacyMapping } } | ConvertTo-Json
    
    $Result = @{}
    try {
        Write-Debug "Reading MgLegacyCommandMapping from file path - $Path."
        $FileProvider = [Microsoft.Graph.PowerShell.Authentication.Common.ProtectedFileProvider]::CreateFileProvider($Path, [Microsoft.Graph.PowerShell.Authentication.Common.FileProtection]::SharedRead)
        if ($PSEdition -eq "Core") {
            $Result = $FileProvider.CreateReader().ReadToEnd() | ConvertFrom-Json -AsHashtable
        }
        else {
            $DeserializationError = $null
            $Result = [Microsoft.Graph.PowerShell.Authentication.Helpers.StringUtil]::ConvertFromJson($FileProvider.CreateReader().ReadToEnd(), $true, 4, [ref] $DeserializationError)
            if ($null -ne $DeserializationError) { throw $DeserializationError }
        }
    }
    finally {
        $FileProvider.Dispose()
    }
    return $Result
}
# SIG # Begin signature block
# MIIoOwYJKoZIhvcNAQcCoIIoLDCCKCgCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCB/LLlIv1DBRxZd
# uW4XT2SVo3wjVI1DgcnPLEcaqn8euKCCDYUwggYDMIID66ADAgECAhMzAAADri01
# UchTj1UdAAAAAAOuMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMjMxMTE2MTkwODU5WhcNMjQxMTE0MTkwODU5WjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQD0IPymNjfDEKg+YyE6SjDvJwKW1+pieqTjAY0CnOHZ1Nj5irGjNZPMlQ4HfxXG
# yAVCZcEWE4x2sZgam872R1s0+TAelOtbqFmoW4suJHAYoTHhkznNVKpscm5fZ899
# QnReZv5WtWwbD8HAFXbPPStW2JKCqPcZ54Y6wbuWV9bKtKPImqbkMcTejTgEAj82
# 6GQc6/Th66Koka8cUIvz59e/IP04DGrh9wkq2jIFvQ8EDegw1B4KyJTIs76+hmpV
# M5SwBZjRs3liOQrierkNVo11WuujB3kBf2CbPoP9MlOyyezqkMIbTRj4OHeKlamd
# WaSFhwHLJRIQpfc8sLwOSIBBAgMBAAGjggGCMIIBfjAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQUhx/vdKmXhwc4WiWXbsf0I53h8T8w
# VAYDVR0RBE0wS6RJMEcxLTArBgNVBAsTJE1pY3Jvc29mdCBJcmVsYW5kIE9wZXJh
# dGlvbnMgTGltaXRlZDEWMBQGA1UEBRMNMjMwMDEyKzUwMTgzNjAfBgNVHSMEGDAW
# gBRIbmTlUAXTgqoXNzcitW2oynUClTBUBgNVHR8ETTBLMEmgR6BFhkNodHRwOi8v
# d3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NybC9NaWNDb2RTaWdQQ0EyMDExXzIw
# MTEtMDctMDguY3JsMGEGCCsGAQUFBwEBBFUwUzBRBggrBgEFBQcwAoZFaHR0cDov
# L3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9jZXJ0cy9NaWNDb2RTaWdQQ0EyMDEx
# XzIwMTEtMDctMDguY3J0MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQELBQADggIB
# AGrJYDUS7s8o0yNprGXRXuAnRcHKxSjFmW4wclcUTYsQZkhnbMwthWM6cAYb/h2W
# 5GNKtlmj/y/CThe3y/o0EH2h+jwfU/9eJ0fK1ZO/2WD0xi777qU+a7l8KjMPdwjY
# 0tk9bYEGEZfYPRHy1AGPQVuZlG4i5ymJDsMrcIcqV8pxzsw/yk/O4y/nlOjHz4oV
# APU0br5t9tgD8E08GSDi3I6H57Ftod9w26h0MlQiOr10Xqhr5iPLS7SlQwj8HW37
# ybqsmjQpKhmWul6xiXSNGGm36GarHy4Q1egYlxhlUnk3ZKSr3QtWIo1GGL03hT57
# xzjL25fKiZQX/q+II8nuG5M0Qmjvl6Egltr4hZ3e3FQRzRHfLoNPq3ELpxbWdH8t
# Nuj0j/x9Crnfwbki8n57mJKI5JVWRWTSLmbTcDDLkTZlJLg9V1BIJwXGY3i2kR9i
# 5HsADL8YlW0gMWVSlKB1eiSlK6LmFi0rVH16dde+j5T/EaQtFz6qngN7d1lvO7uk
# 6rtX+MLKG4LDRsQgBTi6sIYiKntMjoYFHMPvI/OMUip5ljtLitVbkFGfagSqmbxK
# 7rJMhC8wiTzHanBg1Rrbff1niBbnFbbV4UDmYumjs1FIpFCazk6AADXxoKCo5TsO
# zSHqr9gHgGYQC2hMyX9MGLIpowYCURx3L7kUiGbOiMwaMIIHejCCBWKgAwIBAgIK
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
# cVZOSEXAQsmbdlsKgEhr/Xmfwb1tbWrJUnMTDXpQzTGCGgwwghoIAgEBMIGVMH4x
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01p
# Y3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTECEzMAAAOuLTVRyFOPVR0AAAAA
# A64wDQYJYIZIAWUDBAIBBQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQw
# HAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIP8K
# j7xS+swCMgofQu9cNDoeZS1dHor8dDFD5CMUZTDIMEIGCisGAQQBgjcCAQwxNDAy
# oBSAEgBNAGkAYwByAG8AcwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20wDQYJKoZIhvcNAQEBBQAEggEAF4U4dvwk+GqyXMctfAPzVPUc5fOlJT9RXQtz
# WMtUh4AdI4ExIrK6F59ceZG+khEx3dOiHDpC4220lenU1xjOfmA5A+PeWrKg5QQv
# g+1ASOB7JWwlGDu80U1zfKaLOBWdGwbV5TRjZvbDQh5Yr1taQoEZbGeNDBDjSqTB
# 2ANqm6qz6X4VNhG7JnutgBCBYJFi9x2+3msekmxOMFTTDvcscPJdE7+jIOpRWt/R
# SEa1PG8/2nChybQGVHFhLDvkTciXd3BISIqJwl7hLY9bUbs/vjWll6u/QyTrsTdX
# 8CuMAkqtBtF09Bx4jJ3BhK7rGi+NRQrXZizjss7UyJbNBFamq6GCF5YwgheSBgor
# BgEEAYI3AwMBMYIXgjCCF34GCSqGSIb3DQEHAqCCF28wghdrAgEDMQ8wDQYJYIZI
# AWUDBAIBBQAwggFRBgsqhkiG9w0BCRABBKCCAUAEggE8MIIBOAIBAQYKKwYBBAGE
# WQoDATAxMA0GCWCGSAFlAwQCAQUABCA4dkpCWD7lsuwuEpU4SixM/6gCN7oTB6um
# g7TXclFnJwIGZfL3P5ddGBIyMDI0MDQxMTEwMzMxNS4zNlowBIACAfSggdGkgc4w
# gcsxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdS
# ZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJTAjBgNVBAsT
# HE1pY3Jvc29mdCBBbWVyaWNhIE9wZXJhdGlvbnMxJzAlBgNVBAsTHm5TaGllbGQg
# VFNTIEVTTjo4RDAwLTA1RTAtRDk0NzElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUt
# U3RhbXAgU2VydmljZaCCEe0wggcgMIIFCKADAgECAhMzAAAB88UKQ64DzB0xAAEA
# AAHzMA0GCSqGSIb3DQEBCwUAMHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNo
# aW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29y
# cG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEw
# MB4XDTIzMTIwNjE4NDYwMloXDTI1MDMwNTE4NDYwMlowgcsxCzAJBgNVBAYTAlVT
# MRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQK
# ExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJTAjBgNVBAsTHE1pY3Jvc29mdCBBbWVy
# aWNhIE9wZXJhdGlvbnMxJzAlBgNVBAsTHm5TaGllbGQgVFNTIEVTTjo4RDAwLTA1
# RTAtRDk0NzElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgU2VydmljZTCC
# AiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAP6fptrhK4H2JI7lYyFueCpg
# Bv7Pch/M2lkhZL+yB9eGUtiYaexS2sZfc5VyD7ySsl2LG41Qw7tkA6oJmxdSM7Pz
# NyfVpQPkPavY+HNUqMe2K9YaAaPjHnCpZ7VCi/e8zPxYewqx9p0iVaN8EydUpWiY
# 7JtDv7aNzhp/OPZclBBKYT2NBGgGiAPCaplqR5icjHQSY665w+vrvhPr9hpM+Ihi
# UZ/5dXa7qhAcCQwbnrFg9CKSK1COM1YcAN8GpsERqqmlqy3GlE1ziJ3ZLXFVDFxA
# ZeOcCB55Vts9sCgQuFvD7PdV61HC4QUlHNPqFtYSC/P0sxg9JuKgcvzD5mJajfG7
# DdHt8myp7umqyePC+eI/ux8TW61+LuTQ1Bkym+I6z//bf0fp4Dog5W0XzDrqKkTv
# URitxI2s4aVObm6qr6zI7W51k54ozTFjvbw1wYMWqeO4U9sQSbr561kp+1T2PEsJ
# LOpc5U7N2oDw7ldrcTjWPezsyVMXhDsFitCZunGqFO9+4iVjAjYDN47c6K9x7MnA
# GPYVCBOJUdpy8xAOBIDsTm/K1qTT4wsGbQBxbgg96vwDiA4YP2hKmubIC7UnrAWQ
# Gt/ZKOf6J42roXHS1aPwimDe5C9y6DfuNJp0XqrWtQRqg8hqNkIZWT6jnCfqu35z
# B0nf1ERTjdpYLCfQL5fHAgMBAAGjggFJMIIBRTAdBgNVHQ4EFgQUw2QV9qURUQyM
# DcCmhTH2oOsNCiQwHwYDVR0jBBgwFoAUn6cVXQBeYl2D9OXSZacbUzUZ6XIwXwYD
# VR0fBFgwVjBUoFKgUIZOaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9j
# cmwvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUyMDIwMTAoMSkuY3JsMGwG
# CCsGAQUFBwEBBGAwXjBcBggrBgEFBQcwAoZQaHR0cDovL3d3dy5taWNyb3NvZnQu
# Y29tL3BraW9wcy9jZXJ0cy9NaWNyb3NvZnQlMjBUaW1lLVN0YW1wJTIwUENBJTIw
# MjAxMCgxKS5jcnQwDAYDVR0TAQH/BAIwADAWBgNVHSUBAf8EDDAKBggrBgEFBQcD
# CDAOBgNVHQ8BAf8EBAMCB4AwDQYJKoZIhvcNAQELBQADggIBAN/EHI/80f7v29ze
# WI7hzudcz9QoVwCbnDrUXFHE/EJdFeWI2NnuwOo0/QPNRMFT21LkOqSpFKIhXXmP
# urx7p6WDz9wPdu/Sxbgaj0AwviWEDkwGDfDMp2KF8nQT8cipwdfXWbC1ulOILayA
# BSHv45mdv1PAkTulsQE8lBTHG4KJLn+vSzZBWKkGaL/wwRbZ4iLiYn68cjkMJoAa
# ihPgDXn/ug2P3PLNEAFNQgI02tLX0p+vIQ3l2HmSo4bhCBxr3DovsIv5K65NmLRJ
# nxmrrmIraFDwgwA5XF7AKkPiVkvo0OxU1LAE1c5SWzE4A7cbTA1P5wG6D8cPjcHs
# Tah1V+zofYRgJnFRLWuBF4Z3a6pDGBDbCsy5NvnKQ76p37ieFp//1I3eB62ia1Cf
# kjOF8KStpPUqdkXxMjfJ7Vnemd6vQKf+nXkfvA3AOQECJn7aLP01QR5gt8wab28S
# sNUENEyMawT8eqpjtBNJO0O9Tv7NnBE8aOJhhQVdP5WCR90eIWkrDjZeybQx8vlo
# 5rfUXIIzXv+k9MgpNGIqwMXfvRLAjBkCNXOIP/1CEQUG72miMVQs5m/O4vmJIQkh
# yqilUDB1s12uhmLYc3yd8OPMlrwIxORB5J9CxCkqvzc6EGYTcwXazPyCp7eWhzTk
# Nbwk29nfbwmmzcskIAu3StA8lic7MIIHcTCCBVmgAwIBAgITMwAAABXF52ueAptJ
# mQAAAAAAFTANBgkqhkiG9w0BAQsFADCBiDELMAkGA1UEBhMCVVMxEzARBgNVBAgT
# Cldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29m
# dCBDb3Jwb3JhdGlvbjEyMDAGA1UEAxMpTWljcm9zb2Z0IFJvb3QgQ2VydGlmaWNh
# dGUgQXV0aG9yaXR5IDIwMTAwHhcNMjEwOTMwMTgyMjI1WhcNMzAwOTMwMTgzMjI1
# WjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQD
# Ex1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDCCAiIwDQYJKoZIhvcNAQEB
# BQADggIPADCCAgoCggIBAOThpkzntHIhC3miy9ckeb0O1YLT/e6cBwfSqWxOdcjK
# NVf2AX9sSuDivbk+F2Az/1xPx2b3lVNxWuJ+Slr+uDZnhUYjDLWNE893MsAQGOhg
# fWpSg0S3po5GawcU88V29YZQ3MFEyHFcUTE3oAo4bo3t1w/YJlN8OWECesSq/XJp
# rx2rrPY2vjUmZNqYO7oaezOtgFt+jBAcnVL+tuhiJdxqD89d9P6OU8/W7IVWTe/d
# vI2k45GPsjksUZzpcGkNyjYtcI4xyDUoveO0hyTD4MmPfrVUj9z6BVWYbWg7mka9
# 7aSueik3rMvrg0XnRm7KMtXAhjBcTyziYrLNueKNiOSWrAFKu75xqRdbZ2De+JKR
# Hh09/SDPc31BmkZ1zcRfNN0Sidb9pSB9fvzZnkXftnIv231fgLrbqn427DZM9itu
# qBJR6L8FA6PRc6ZNN3SUHDSCD/AQ8rdHGO2n6Jl8P0zbr17C89XYcz1DTsEzOUyO
# ArxCaC4Q6oRRRuLRvWoYWmEBc8pnol7XKHYC4jMYctenIPDC+hIK12NvDMk2ZItb
# oKaDIV1fMHSRlJTYuVD5C4lh8zYGNRiER9vcG9H9stQcxWv2XFJRXRLbJbqvUAV6
# bMURHXLvjflSxIUXk8A8FdsaN8cIFRg/eKtFtvUeh17aj54WcmnGrnu3tz5q4i6t
# AgMBAAGjggHdMIIB2TASBgkrBgEEAYI3FQEEBQIDAQABMCMGCSsGAQQBgjcVAgQW
# BBQqp1L+ZMSavoKRPEY1Kc8Q/y8E7jAdBgNVHQ4EFgQUn6cVXQBeYl2D9OXSZacb
# UzUZ6XIwXAYDVR0gBFUwUzBRBgwrBgEEAYI3TIN9AQEwQTA/BggrBgEFBQcCARYz
# aHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9Eb2NzL1JlcG9zaXRvcnku
# aHRtMBMGA1UdJQQMMAoGCCsGAQUFBwMIMBkGCSsGAQQBgjcUAgQMHgoAUwB1AGIA
# QwBBMAsGA1UdDwQEAwIBhjAPBgNVHRMBAf8EBTADAQH/MB8GA1UdIwQYMBaAFNX2
# VsuP6KJcYmjRPZSQW9fOmhjEMFYGA1UdHwRPME0wS6BJoEeGRWh0dHA6Ly9jcmwu
# bWljcm9zb2Z0LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL01pY1Jvb0NlckF1dF8yMDEw
# LTA2LTIzLmNybDBaBggrBgEFBQcBAQROMEwwSgYIKwYBBQUHMAKGPmh0dHA6Ly93
# d3cubWljcm9zb2Z0LmNvbS9wa2kvY2VydHMvTWljUm9vQ2VyQXV0XzIwMTAtMDYt
# MjMuY3J0MA0GCSqGSIb3DQEBCwUAA4ICAQCdVX38Kq3hLB9nATEkW+Geckv8qW/q
# XBS2Pk5HZHixBpOXPTEztTnXwnE2P9pkbHzQdTltuw8x5MKP+2zRoZQYIu7pZmc6
# U03dmLq2HnjYNi6cqYJWAAOwBb6J6Gngugnue99qb74py27YP0h1AdkY3m2CDPVt
# I1TkeFN1JFe53Z/zjj3G82jfZfakVqr3lbYoVSfQJL1AoL8ZthISEV09J+BAljis
# 9/kpicO8F7BUhUKz/AyeixmJ5/ALaoHCgRlCGVJ1ijbCHcNhcy4sa3tuPywJeBTp
# kbKpW99Jo3QMvOyRgNI95ko+ZjtPu4b6MhrZlvSP9pEB9s7GdP32THJvEKt1MMU0
# sHrYUP4KWN1APMdUbZ1jdEgssU5HLcEUBHG/ZPkkvnNtyo4JvbMBV0lUZNlz138e
# W0QBjloZkWsNn6Qo3GcZKCS6OEuabvshVGtqRRFHqfG3rsjoiV5PndLQTHa1V1QJ
# sWkBRH58oWFsc/4Ku+xBZj1p/cvBQUl+fpO+y/g75LcVv7TOPqUxUYS8vwLBgqJ7
# Fx0ViY1w/ue10CgaiQuPNtq6TPmb/wrpNPgkNWcr4A245oyZ1uEi6vAnQj0llOZ0
# dFtq0Z4+7X6gMTN9vMvpe784cETRkPHIqzqKOghif9lwY1NNje6CbaUFEMFxBmoQ
# tB1VM1izoXBm8qGCA1AwggI4AgEBMIH5oYHRpIHOMIHLMQswCQYDVQQGEwJVUzET
# MBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMV
# TWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1lcmlj
# YSBPcGVyYXRpb25zMScwJQYDVQQLEx5uU2hpZWxkIFRTUyBFU046OEQwMC0wNUUw
# LUQ5NDcxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2WiIwoB
# ATAHBgUrDgMCGgMVAG76BizYtGFrmkU7v2DcuR/ApGcooIGDMIGApH4wfDELMAkG
# A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQx
# HjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9z
# b2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAwDQYJKoZIhvcNAQELBQACBQDpwbS4MCIY
# DzIwMjQwNDExMDEwMDQwWhgPMjAyNDA0MTIwMTAwNDBaMHcwPQYKKwYBBAGEWQoE
# ATEvMC0wCgIFAOnBtLgCAQAwCgIBAAICFhsCAf8wBwIBAAICE80wCgIFAOnDBjgC
# AQAwNgYKKwYBBAGEWQoEAjEoMCYwDAYKKwYBBAGEWQoDAqAKMAgCAQACAwehIKEK
# MAgCAQACAwGGoDANBgkqhkiG9w0BAQsFAAOCAQEABLBFINm7GyjNXhNYuEeVbHBf
# 3F4Sz/I3J3JiYFcmw65RbrQAl5Y5IMk7Hg/6p413uYKftQ1uz6cGetEvbKI9187M
# yXAxjcSEKhLTHFJKw4mN1h4mbV8MSfqWWX0X/yoDqxEfcJSt7RAVl2HPYHbnSqNN
# h6j/p0UIzklTqOa57h8odx8ZXxPir4iwr1AJMgdIpWXue/Vyjm2XHBGRpGQxOxsj
# ESFgl/lMFC3qDTxD01hBjBAKQJViMeOq+Phy2fkYBs4SWIDDJZ2siCtavQjfzNhT
# 2ppKV2tRxFdVk/gEvj9uULoT1RYpVKMRfoWp1kSNi2o4FL56+m79tskqq0MKMTGC
# BA0wggQJAgEBMIGTMHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9u
# MRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRp
# b24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwAhMzAAAB
# 88UKQ64DzB0xAAEAAAHzMA0GCWCGSAFlAwQCAQUAoIIBSjAaBgkqhkiG9w0BCQMx
# DQYLKoZIhvcNAQkQAQQwLwYJKoZIhvcNAQkEMSIEIJ6oPEGQAvYnuhHoN9jPGsnB
# JZ8LeryMrNBSgl3gMzAmMIH6BgsqhkiG9w0BCRACLzGB6jCB5zCB5DCBvQQgGLzZ
# NIu24bhWSnzAGYmT9P5ECHzjWwb9oM7DGDo7YugwgZgwgYCkfjB8MQswCQYDVQQG
# EwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwG
# A1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQg
# VGltZS1TdGFtcCBQQ0EgMjAxMAITMwAAAfPFCkOuA8wdMQABAAAB8zAiBCAqkOrm
# FlnKd+UjArjDDVGzZyXvY0At30aEf90akAUYsTANBgkqhkiG9w0BAQsFAASCAgDX
# RXutDRbT1h9lGb7ZSHo270enxH1W2PyfvhU6z2kowGb8mkuRrU4rfeZoTq0E0oNt
# cxCHBYXMha6ytwBNx995Ki9jspjdDNilAOLsyY5VBZ6WNOzTvfXpY7Ece/w9+GdX
# MIrWgKuM6Pxoh3feHE2kxpbhSMUKydGsv4RA+EtCDjzUEyAIwfGW0MVvfvoKjflN
# RXBWKQ1umFAZ/hq6rO6mow083YWim5xapx1QJC69E1zwVYjRvkrc1rNRLaUE2dOv
# r+BHTQPzvdAhFFnwYbWl27fyvPE04UyQCEy8lNnJEmTIDo1p98AoOAF3TtJR/cSy
# PM5MwZktmT8VFvR+a61I68idhYyYK+gbjtp5jLQmPHhpDSAr0LYzB7nE55Tsloof
# dBa/84vj9OVyFY8JZB4XSlDbq5EpiGvdlNK7hbdJ1pIgOyKm4SBKLsY85l5ikBAJ
# GLRBQQ9O1WmOSM9JM/a7005MC98ky1lef0zJ9lIP84IQxqcA4dxHGq8eUNwNC3MT
# HQ5vbiCddtmoSNT2iuNC5oYmnc0xcPXoTu5a/2WAx4Mp3Ed+fC5BXsAPEcm5g7lJ
# /CGAmobTACk9NFZ5psHZ3zPg8gG/uu/zDNmcGV0kCIpbLs+uPdWwtnz4Z72KXc++
# sLPjYGH/NH7hrkiWM1PZffOI1N+mIpQTnguorxleJw==
# SIG # End signature block
