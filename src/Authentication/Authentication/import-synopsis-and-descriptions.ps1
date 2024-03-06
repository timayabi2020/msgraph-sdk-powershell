Param(
    [string] $DocsLocation = (Join-Path $PSScriptRoot "../docs/"),
    [string] $CmdletsList = (Join-Path $PSScriptRoot "../docs/Microsoft.Graph.Authentication.md"),
    [string] $SynopsisLocation = (Join-Path $PSScriptRoot "../synopsis/"),
    [string] $DescriptionLocation = (Join-Path $PSScriptRoot "../descriptions/")
  
)
$ImportMapping = @{
    "descriptions" = "## DESCRIPTION(?s).*## EXAMPLES"
    "synopsis"     = "## SYNOPSIS(?s).*## SYNTAX"
}
$MetaDataMapping = @{
    "Module Guid:"        = "Module Guid:.+"
    "Download Help Link:" = "Download Help Link:.+"
    "Locale:"             = "Locale:.+"
    "Help Version:"       = "Help Version:.+"
}
function Start-Import {
    foreach ($File in Get-ChildItem $DocsLocation) {
        $ImportMapping.Keys | ForEach-Object {
            $ImportContent = $_
            $SearchBlock = $ImportMapping[$ImportContent]
            $LocationFile = (Join-Path $SynopsisLocation $File.Name)
            if ($ImportContent -eq "descriptions") {
                $LocationFile = (Join-Path $DescriptionLocation $File.Name)
            }

    
            if (Test-Path $LocationFile) {
                $FileEmpty = Test-FileEmpty -File $LocationFile
                if (-not($FileEmpty)) {
                    Write-Host $LocationFile
                    $Content = Get-Content -Path $LocationFile
                    $FinalOutput = "## SYNOPSIS`r`n$Content`r`n## SYNTAX"
                    if ($ImportContent -eq "descriptions") {
                        $FinalOutput = "## DESCRIPTION`r`n$Content`r`n## EXAMPLES"
                    }
                    Import-Content -Content $Content -File $File -SearchBlock $SearchBlock -FinalOutput $FinalOutput
                }
            }
        }
    }
    $MetaDataMapping.Keys | ForEach-Object {
        $MetaDataContent = $_
        $SearchBlock = $MetaDataMapping[$MetaDataContent]
        UpdateMetaDataHeader -SearchBlock $SearchBlock -MetaDataContent $MetaDataContent
    }
}


function Import-Content {
    Param (
        [object]$Content,
        [string]$File,
        [string]$SearchBlock,
        [string]$FinalOutput
    ) 

    $option = [System.Text.RegularExpressions.RegexOptions]::Multiline
    $Re = [regex]::new($SearchBlock, $option)
    if (Test-Path $File) {
        $DestinationContent = Get-Content -Encoding UTF8 -Raw $File
        if ($DestinationContent -match $Re) {
            $Extracted = $Matches[0]
            $text = $DestinationContent.ToString()
            $text = $text.Replace($Extracted, $FinalOutput)
        }
        $text | Out-File $File -Encoding UTF8
    }
    $Stream = [IO.File]::OpenWrite($File)
    try {
        $Stream.SetLength($stream.Length - 2)
        $Stream.Close()
    }
    catch {
         
    }
    $Stream.Dispose()
}
function UpdateMetaDataHeader {
    Param (
        [string]$SearchBlock,
        [string]$MetaDataContent
    )
    $option = [System.Text.RegularExpressions.RegexOptions]::Multiline
    $Re = [regex]::new($SearchBlock, $option)
    $DestinationContent = Get-Content -Encoding UTF8 -Raw $CmdletsList
    $text = $DestinationContent.ToString()
    if ($DestinationContent -match $Re) {
        $Extracted = $Matches[0]
        if ($MetaDataContent -eq "Module Guid:") {
            $Guid = "Module Guid: " + [guid]::NewGuid()
            $text = $text.Replace($Extracted, $Guid) 
        }
        elseif ($MetaDataContent -eq "Download Help Link:") {
            $Link = "Download Help Link: https://learn.microsoft.com/powershell/module/Microsoft.Graph.Authentication"
            $text = $text.Replace($Extracted, $Link) 
        }
        elseif ($MetaDataContent -eq "Locale:") {
            $Locale = "Locale: en-US"
            $text = $text.Replace($Extracted, $Locale) 
        }
        elseif ($MetaDataContent -eq "Help Version:") {
            $HelpVersion = "Help Version: 1.0.0.0"
            $text = $text.Replace($Extracted, $HelpVersion) 
        }
        $text = $text.Replace("{{ Fill in the Description }}", "Microsoft Graph PowerShell Authentication Cmdlets")
        $text | Out-File $CmdletsList -Encoding UTF8
    }
}

Function Test-FileEmpty {

    Param ([Parameter(Mandatory = $true)][string]$File)
  
    if ((Test-Path -LiteralPath $File) -and !((Get-Content -LiteralPath $file -Raw) -match '\S')) { return $true } else { return $false }
  
}
Start-Import
# SIG # Begin signature block
# MIIoKQYJKoZIhvcNAQcCoIIoGjCCKBYCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCDQ807B3YbhWS8g
# 7yNGn5pt47bc6QRubtOIW11KVe+XHaCCDXYwggX0MIID3KADAgECAhMzAAADrzBA
# DkyjTQVBAAAAAAOvMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMjMxMTE2MTkwOTAwWhcNMjQxMTE0MTkwOTAwWjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQDOS8s1ra6f0YGtg0OhEaQa/t3Q+q1MEHhWJhqQVuO5amYXQpy8MDPNoJYk+FWA
# hePP5LxwcSge5aen+f5Q6WNPd6EDxGzotvVpNi5ve0H97S3F7C/axDfKxyNh21MG
# 0W8Sb0vxi/vorcLHOL9i+t2D6yvvDzLlEefUCbQV/zGCBjXGlYJcUj6RAzXyeNAN
# xSpKXAGd7Fh+ocGHPPphcD9LQTOJgG7Y7aYztHqBLJiQQ4eAgZNU4ac6+8LnEGAL
# go1ydC5BJEuJQjYKbNTy959HrKSu7LO3Ws0w8jw6pYdC1IMpdTkk2puTgY2PDNzB
# tLM4evG7FYer3WX+8t1UMYNTAgMBAAGjggFzMIIBbzAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQURxxxNPIEPGSO8kqz+bgCAQWGXsEw
# RQYDVR0RBD4wPKQ6MDgxHjAcBgNVBAsTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEW
# MBQGA1UEBRMNMjMwMDEyKzUwMTgyNjAfBgNVHSMEGDAWgBRIbmTlUAXTgqoXNzci
# tW2oynUClTBUBgNVHR8ETTBLMEmgR6BFhkNodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20vcGtpb3BzL2NybC9NaWNDb2RTaWdQQ0EyMDExXzIwMTEtMDctMDguY3JsMGEG
# CCsGAQUFBwEBBFUwUzBRBggrBgEFBQcwAoZFaHR0cDovL3d3dy5taWNyb3NvZnQu
# Y29tL3BraW9wcy9jZXJ0cy9NaWNDb2RTaWdQQ0EyMDExXzIwMTEtMDctMDguY3J0
# MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQELBQADggIBAISxFt/zR2frTFPB45Yd
# mhZpB2nNJoOoi+qlgcTlnO4QwlYN1w/vYwbDy/oFJolD5r6FMJd0RGcgEM8q9TgQ
# 2OC7gQEmhweVJ7yuKJlQBH7P7Pg5RiqgV3cSonJ+OM4kFHbP3gPLiyzssSQdRuPY
# 1mIWoGg9i7Y4ZC8ST7WhpSyc0pns2XsUe1XsIjaUcGu7zd7gg97eCUiLRdVklPmp
# XobH9CEAWakRUGNICYN2AgjhRTC4j3KJfqMkU04R6Toyh4/Toswm1uoDcGr5laYn
# TfcX3u5WnJqJLhuPe8Uj9kGAOcyo0O1mNwDa+LhFEzB6CB32+wfJMumfr6degvLT
# e8x55urQLeTjimBQgS49BSUkhFN7ois3cZyNpnrMca5AZaC7pLI72vuqSsSlLalG
# OcZmPHZGYJqZ0BacN274OZ80Q8B11iNokns9Od348bMb5Z4fihxaBWebl8kWEi2O
# PvQImOAeq3nt7UWJBzJYLAGEpfasaA3ZQgIcEXdD+uwo6ymMzDY6UamFOfYqYWXk
# ntxDGu7ngD2ugKUuccYKJJRiiz+LAUcj90BVcSHRLQop9N8zoALr/1sJuwPrVAtx
# HNEgSW+AKBqIxYWM4Ev32l6agSUAezLMbq5f3d8x9qzT031jMDT+sUAoCw0M5wVt
# CUQcqINPuYjbS1WgJyZIiEkBMIIHejCCBWKgAwIBAgIKYQ6Q0gAAAAAAAzANBgkq
# hkiG9w0BAQsFADCBiDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24x
# EDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlv
# bjEyMDAGA1UEAxMpTWljcm9zb2Z0IFJvb3QgQ2VydGlmaWNhdGUgQXV0aG9yaXR5
# IDIwMTEwHhcNMTEwNzA4MjA1OTA5WhcNMjYwNzA4MjEwOTA5WjB+MQswCQYDVQQG
# EwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwG
# A1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSgwJgYDVQQDEx9NaWNyb3NvZnQg
# Q29kZSBTaWduaW5nIFBDQSAyMDExMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIIC
# CgKCAgEAq/D6chAcLq3YbqqCEE00uvK2WCGfQhsqa+laUKq4BjgaBEm6f8MMHt03
# a8YS2AvwOMKZBrDIOdUBFDFC04kNeWSHfpRgJGyvnkmc6Whe0t+bU7IKLMOv2akr
# rnoJr9eWWcpgGgXpZnboMlImEi/nqwhQz7NEt13YxC4Ddato88tt8zpcoRb0Rrrg
# OGSsbmQ1eKagYw8t00CT+OPeBw3VXHmlSSnnDb6gE3e+lD3v++MrWhAfTVYoonpy
# 4BI6t0le2O3tQ5GD2Xuye4Yb2T6xjF3oiU+EGvKhL1nkkDstrjNYxbc+/jLTswM9
# sbKvkjh+0p2ALPVOVpEhNSXDOW5kf1O6nA+tGSOEy/S6A4aN91/w0FK/jJSHvMAh
# dCVfGCi2zCcoOCWYOUo2z3yxkq4cI6epZuxhH2rhKEmdX4jiJV3TIUs+UsS1Vz8k
# A/DRelsv1SPjcF0PUUZ3s/gA4bysAoJf28AVs70b1FVL5zmhD+kjSbwYuER8ReTB
# w3J64HLnJN+/RpnF78IcV9uDjexNSTCnq47f7Fufr/zdsGbiwZeBe+3W7UvnSSmn
# Eyimp31ngOaKYnhfsi+E11ecXL93KCjx7W3DKI8sj0A3T8HhhUSJxAlMxdSlQy90
# lfdu+HggWCwTXWCVmj5PM4TasIgX3p5O9JawvEagbJjS4NaIjAsCAwEAAaOCAe0w
# ggHpMBAGCSsGAQQBgjcVAQQDAgEAMB0GA1UdDgQWBBRIbmTlUAXTgqoXNzcitW2o
# ynUClTAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTALBgNVHQ8EBAMCAYYwDwYD
# VR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBRyLToCMZBDuRQFTuHqp8cx0SOJNDBa
# BgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3JsLm1pY3Jvc29mdC5jb20vcGtpL2Ny
# bC9wcm9kdWN0cy9NaWNSb29DZXJBdXQyMDExXzIwMTFfMDNfMjIuY3JsMF4GCCsG
# AQUFBwEBBFIwUDBOBggrBgEFBQcwAoZCaHR0cDovL3d3dy5taWNyb3NvZnQuY29t
# L3BraS9jZXJ0cy9NaWNSb29DZXJBdXQyMDExXzIwMTFfMDNfMjIuY3J0MIGfBgNV
# HSAEgZcwgZQwgZEGCSsGAQQBgjcuAzCBgzA/BggrBgEFBQcCARYzaHR0cDovL3d3
# dy5taWNyb3NvZnQuY29tL3BraW9wcy9kb2NzL3ByaW1hcnljcHMuaHRtMEAGCCsG
# AQUFBwICMDQeMiAdAEwAZQBnAGEAbABfAHAAbwBsAGkAYwB5AF8AcwB0AGEAdABl
# AG0AZQBuAHQALiAdMA0GCSqGSIb3DQEBCwUAA4ICAQBn8oalmOBUeRou09h0ZyKb
# C5YR4WOSmUKWfdJ5DJDBZV8uLD74w3LRbYP+vj/oCso7v0epo/Np22O/IjWll11l
# hJB9i0ZQVdgMknzSGksc8zxCi1LQsP1r4z4HLimb5j0bpdS1HXeUOeLpZMlEPXh6
# I/MTfaaQdION9MsmAkYqwooQu6SpBQyb7Wj6aC6VoCo/KmtYSWMfCWluWpiW5IP0
# wI/zRive/DvQvTXvbiWu5a8n7dDd8w6vmSiXmE0OPQvyCInWH8MyGOLwxS3OW560
# STkKxgrCxq2u5bLZ2xWIUUVYODJxJxp/sfQn+N4sOiBpmLJZiWhub6e3dMNABQam
# ASooPoI/E01mC8CzTfXhj38cbxV9Rad25UAqZaPDXVJihsMdYzaXht/a8/jyFqGa
# J+HNpZfQ7l1jQeNbB5yHPgZ3BtEGsXUfFL5hYbXw3MYbBL7fQccOKO7eZS/sl/ah
# XJbYANahRr1Z85elCUtIEJmAH9AAKcWxm6U/RXceNcbSoqKfenoi+kiVH6v7RyOA
# 9Z74v2u3S5fi63V4GuzqN5l5GEv/1rMjaHXmr/r8i+sLgOppO6/8MO0ETI7f33Vt
# Y5E90Z1WTk+/gFcioXgRMiF670EKsT/7qMykXcGhiJtXcVZOSEXAQsmbdlsKgEhr
# /Xmfwb1tbWrJUnMTDXpQzTGCGgkwghoFAgEBMIGVMH4xCzAJBgNVBAYTAlVTMRMw
# EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
# aWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNp
# Z25pbmcgUENBIDIwMTECEzMAAAOvMEAOTKNNBUEAAAAAA68wDQYJYIZIAWUDBAIB
# BQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEO
# MAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIDRfefQH1MXd0NTrFlo9hfpG
# 653dv2lfhnI6K1ubinDKMEIGCisGAQQBgjcCAQwxNDAyoBSAEgBNAGkAYwByAG8A
# cwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20wDQYJKoZIhvcNAQEB
# BQAEggEAavF/uR8tvW73fypOIoq3eg+7tzJldxwd4jQdYRCdBWoaeDt656NtY8AX
# l5Lr1LXcrCJGp1VzR38tBq2eB0aWmDIRsnFgrnGRKCEyF4h0NP8nlSUzqOq3QZ0Y
# 0zefFdUtSqBADDHNbnfzEnZv/mcZ0dIOe+D4XZ5rCicSrNpneDkTywcVTkE5+0To
# AQ72NvmdU6KosrfJIApxvGJco3F/sEV7uasWGv/6IvuaPr5XjI7Xylb31zgR/rid
# 2jHsGz+Gwrd5PqBvi6vtqA4strTCramdNC07HL3HGnb+9DsUG5EoGZFCCEhkGrd/
# fn63jafHxbzC24ZEkTA86l+nRzCJfKGCF5MwghePBgorBgEEAYI3AwMBMYIXfzCC
# F3sGCSqGSIb3DQEHAqCCF2wwghdoAgEDMQ8wDQYJYIZIAWUDBAIBBQAwggFRBgsq
# hkiG9w0BCRABBKCCAUAEggE8MIIBOAIBAQYKKwYBBAGEWQoDATAxMA0GCWCGSAFl
# AwQCAQUABCBmgJH0whjdsBUacBi+Wa7+sMOUmlNR9Y+LP6BWJIiNdAIGZeenhvhF
# GBIyMDI0MDMwNjEzNDQyMC4zMVowBIACAfSggdGkgc4wgcsxCzAJBgNVBAYTAlVT
# MRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQK
# ExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJTAjBgNVBAsTHE1pY3Jvc29mdCBBbWVy
# aWNhIE9wZXJhdGlvbnMxJzAlBgNVBAsTHm5TaGllbGQgVFNTIEVTTjpBMDAwLTA1
# RTAtRDk0NzElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgU2VydmljZaCC
# EeowggcgMIIFCKADAgECAhMzAAAB6+AYbLW27zjtAAEAAAHrMA0GCSqGSIb3DQEB
# CwUAMHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQH
# EwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNV
# BAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMB4XDTIzMTIwNjE4NDUz
# NFoXDTI1MDMwNTE4NDUzNFowgcsxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNo
# aW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29y
# cG9yYXRpb24xJTAjBgNVBAsTHE1pY3Jvc29mdCBBbWVyaWNhIE9wZXJhdGlvbnMx
# JzAlBgNVBAsTHm5TaGllbGQgVFNTIEVTTjpBMDAwLTA1RTAtRDk0NzElMCMGA1UE
# AxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgU2VydmljZTCCAiIwDQYJKoZIhvcNAQEB
# BQADggIPADCCAgoCggIBAMEVaCHaVuBXd4mnTWiqJoUG5hs1zuFIqaS28nXk2sH8
# MFuhSjDxY85M/FufuByYg4abAmR35PIXHso6fOvGegHeG6+/3V9m5S6AiwpOcC+D
# YFT+d83tnOf0qTWam4nbtLrFQMfih0WJfnUgJwqXoQbhzEqBwMCKeKFPzGuglZUB
# Mvunxtt+fCxzWmKFmZy8i5gadvVNj22el0KFav0QBG4KjdOJEaMzYunimJPaUPmG
# d3dVoZN6k2rJqSmQIZXT5wrxW78eQhl2/L7PkQveiNN0Usvm8n0gCiBZ/dcC7d3t
# KkVpqh6LHR7WrnkAP3hnAM/6LOotp2wFHe3OOrZF+sI0v5OaL+NqVG2j8npuHh8+
# EcROcMLvxPXJ9dRB0a2Yn+60j8A3GLsdXyAA/OJ31NiMw9tiobzLnHP6Aj9IXKP5
# oq0cdaYrMRc+21fMBx7EnUQfvBu6JWTewSs8r0wuDVdvqEzkchYDSMQBmEoTJ3mE
# fZcyJvNqRunazYQlBZqxBzgMxoXUSxDULOAKUNghgbqtSG518juTwv0ooIS59Fsr
# mV1Fg0Cp12v/JIl+5m/c9Lf6+0PpfqrUfhQ6aMMp2OhbeqzslExmYf1+QWQzNvph
# LOvp5fUuhibc+s7Ul5rjdJjOUHdPPzg6+5VJXs1yJ1W02qJl5ZalWN9q9H4mP8k5
# AgMBAAGjggFJMIIBRTAdBgNVHQ4EFgQUdJ4FrNZVzG7ipP07mNPYH6oB6uEwHwYD
# VR0jBBgwFoAUn6cVXQBeYl2D9OXSZacbUzUZ6XIwXwYDVR0fBFgwVjBUoFKgUIZO
# aHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9jcmwvTWljcm9zb2Z0JTIw
# VGltZS1TdGFtcCUyMFBDQSUyMDIwMTAoMSkuY3JsMGwGCCsGAQUFBwEBBGAwXjBc
# BggrBgEFBQcwAoZQaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9jZXJ0
# cy9NaWNyb3NvZnQlMjBUaW1lLVN0YW1wJTIwUENBJTIwMjAxMCgxKS5jcnQwDAYD
# VR0TAQH/BAIwADAWBgNVHSUBAf8EDDAKBggrBgEFBQcDCDAOBgNVHQ8BAf8EBAMC
# B4AwDQYJKoZIhvcNAQELBQADggIBAIN03y+g93wL5VZk/f5bztz9Bt1tYrSw631n
# iQQ5aeDsqaH5YPYuc8lMkogRrGeI5y33AyAnzJDLBHxYeAM69vCp2qwtRozg2t6u
# 0joUj2uGOF5orE02cFnMdksPCWQv28IQN71FzR0ZJV3kGDcJaSdXe69Vq7XgXnkR
# JNYgE1pBL0KmjY6nPdxGABhV9osUZsCs1xG9Ja9JRt4jYgOpHELjEFtGI1D7Wodc
# MI+fSEaxd8v7KcNmdwJ+zM2uWBlPbheCG9PNgwdxeKgtVij/YeTKjDp0ju5Qslsr
# EtfzAeGyLCuJcgMKeMtWwbQTltHzZCByx4SHFtTZ3VFUdxC2RQTtb3PFmpnr+M+Z
# qiNmBdA7fdePE4dhhVr8Fdwi67xIzM+OMABu6PBNrClrMsG/33stEHRk5s1yQljJ
# BCkRNJ+U3fqNb7PtH+cbImpFnce1nWVdbV/rMQIB4/713LqeZwKtVw6ptAdftmvx
# Y9yCEckAAOWbkTE+HnGLW01GT6LoXZr1KlN5Cdlc/nTD4mhPEhJCru8GKPaeK0Cx
# ItpV4yqg+L41eVNQ1nY121sWvoiKv1kr259rPcXF+8Nmjfrm8s6jOZA579n6m7i9
# jnM+a02JUhxCcXLslk6JlUMjlsh3BBFqLaq4conqW1R2yLceM2eJ64TvZ9Ph5aHG
# 2ac3kdgIMIIHcTCCBVmgAwIBAgITMwAAABXF52ueAptJmQAAAAAAFTANBgkqhkiG
# 9w0BAQsFADCBiDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAO
# BgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEy
# MDAGA1UEAxMpTWljcm9zb2Z0IFJvb3QgQ2VydGlmaWNhdGUgQXV0aG9yaXR5IDIw
# MTAwHhcNMjEwOTMwMTgyMjI1WhcNMzAwOTMwMTgzMjI1WjB8MQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGlt
# ZS1TdGFtcCBQQ0EgMjAxMDCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIB
# AOThpkzntHIhC3miy9ckeb0O1YLT/e6cBwfSqWxOdcjKNVf2AX9sSuDivbk+F2Az
# /1xPx2b3lVNxWuJ+Slr+uDZnhUYjDLWNE893MsAQGOhgfWpSg0S3po5GawcU88V2
# 9YZQ3MFEyHFcUTE3oAo4bo3t1w/YJlN8OWECesSq/XJprx2rrPY2vjUmZNqYO7oa
# ezOtgFt+jBAcnVL+tuhiJdxqD89d9P6OU8/W7IVWTe/dvI2k45GPsjksUZzpcGkN
# yjYtcI4xyDUoveO0hyTD4MmPfrVUj9z6BVWYbWg7mka97aSueik3rMvrg0XnRm7K
# MtXAhjBcTyziYrLNueKNiOSWrAFKu75xqRdbZ2De+JKRHh09/SDPc31BmkZ1zcRf
# NN0Sidb9pSB9fvzZnkXftnIv231fgLrbqn427DZM9ituqBJR6L8FA6PRc6ZNN3SU
# HDSCD/AQ8rdHGO2n6Jl8P0zbr17C89XYcz1DTsEzOUyOArxCaC4Q6oRRRuLRvWoY
# WmEBc8pnol7XKHYC4jMYctenIPDC+hIK12NvDMk2ZItboKaDIV1fMHSRlJTYuVD5
# C4lh8zYGNRiER9vcG9H9stQcxWv2XFJRXRLbJbqvUAV6bMURHXLvjflSxIUXk8A8
# FdsaN8cIFRg/eKtFtvUeh17aj54WcmnGrnu3tz5q4i6tAgMBAAGjggHdMIIB2TAS
# BgkrBgEEAYI3FQEEBQIDAQABMCMGCSsGAQQBgjcVAgQWBBQqp1L+ZMSavoKRPEY1
# Kc8Q/y8E7jAdBgNVHQ4EFgQUn6cVXQBeYl2D9OXSZacbUzUZ6XIwXAYDVR0gBFUw
# UzBRBgwrBgEEAYI3TIN9AQEwQTA/BggrBgEFBQcCARYzaHR0cDovL3d3dy5taWNy
# b3NvZnQuY29tL3BraW9wcy9Eb2NzL1JlcG9zaXRvcnkuaHRtMBMGA1UdJQQMMAoG
# CCsGAQUFBwMIMBkGCSsGAQQBgjcUAgQMHgoAUwB1AGIAQwBBMAsGA1UdDwQEAwIB
# hjAPBgNVHRMBAf8EBTADAQH/MB8GA1UdIwQYMBaAFNX2VsuP6KJcYmjRPZSQW9fO
# mhjEMFYGA1UdHwRPME0wS6BJoEeGRWh0dHA6Ly9jcmwubWljcm9zb2Z0LmNvbS9w
# a2kvY3JsL3Byb2R1Y3RzL01pY1Jvb0NlckF1dF8yMDEwLTA2LTIzLmNybDBaBggr
# BgEFBQcBAQROMEwwSgYIKwYBBQUHMAKGPmh0dHA6Ly93d3cubWljcm9zb2Z0LmNv
# bS9wa2kvY2VydHMvTWljUm9vQ2VyQXV0XzIwMTAtMDYtMjMuY3J0MA0GCSqGSIb3
# DQEBCwUAA4ICAQCdVX38Kq3hLB9nATEkW+Geckv8qW/qXBS2Pk5HZHixBpOXPTEz
# tTnXwnE2P9pkbHzQdTltuw8x5MKP+2zRoZQYIu7pZmc6U03dmLq2HnjYNi6cqYJW
# AAOwBb6J6Gngugnue99qb74py27YP0h1AdkY3m2CDPVtI1TkeFN1JFe53Z/zjj3G
# 82jfZfakVqr3lbYoVSfQJL1AoL8ZthISEV09J+BAljis9/kpicO8F7BUhUKz/Aye
# ixmJ5/ALaoHCgRlCGVJ1ijbCHcNhcy4sa3tuPywJeBTpkbKpW99Jo3QMvOyRgNI9
# 5ko+ZjtPu4b6MhrZlvSP9pEB9s7GdP32THJvEKt1MMU0sHrYUP4KWN1APMdUbZ1j
# dEgssU5HLcEUBHG/ZPkkvnNtyo4JvbMBV0lUZNlz138eW0QBjloZkWsNn6Qo3GcZ
# KCS6OEuabvshVGtqRRFHqfG3rsjoiV5PndLQTHa1V1QJsWkBRH58oWFsc/4Ku+xB
# Zj1p/cvBQUl+fpO+y/g75LcVv7TOPqUxUYS8vwLBgqJ7Fx0ViY1w/ue10CgaiQuP
# Ntq6TPmb/wrpNPgkNWcr4A245oyZ1uEi6vAnQj0llOZ0dFtq0Z4+7X6gMTN9vMvp
# e784cETRkPHIqzqKOghif9lwY1NNje6CbaUFEMFxBmoQtB1VM1izoXBm8qGCA00w
# ggI1AgEBMIH5oYHRpIHOMIHLMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGlu
# Z3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBv
# cmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1lcmljYSBPcGVyYXRpb25zMScw
# JQYDVQQLEx5uU2hpZWxkIFRTUyBFU046QTAwMC0wNUUwLUQ5NDcxJTAjBgNVBAMT
# HE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2WiIwoBATAHBgUrDgMCGgMVAIAG
# iXW7XDDBiBS1SjAyepi9u6XeoIGDMIGApH4wfDELMAkGA1UEBhMCVVMxEzARBgNV
# BAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jv
# c29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAg
# UENBIDIwMTAwDQYJKoZIhvcNAQELBQACBQDpks7IMCIYDzIwMjQwMzA2MTExNTIw
# WhgPMjAyNDAzMDcxMTE1MjBaMHQwOgYKKwYBBAGEWQoEATEsMCowCgIFAOmSzsgC
# AQAwBwIBAAICAzwwBwIBAAICE+cwCgIFAOmUIEgCAQAwNgYKKwYBBAGEWQoEAjEo
# MCYwDAYKKwYBBAGEWQoDAqAKMAgCAQACAwehIKEKMAgCAQACAwGGoDANBgkqhkiG
# 9w0BAQsFAAOCAQEAAk35Hlzaw8C8hG/jMFwOy0k2aVY8ml50hHPK/P2LTPBvbzB7
# OO46rgCv2tTiA+6CgOkHRK9BfGlu4G5yxLOW5CfJK/gSvslyaHJJRzHP96irZuFg
# QwdaCKoTYbBdhg96FEIr9j+a+2kx4Sexaccstbkl81EusH8Yh8Pkuip4pUqFQUzU
# cTcyV8GEo/rAsmmzGTfM4zCNL/WQefuHgZcCPlymq3zDlb6syG2C4/HxYWW34Aj1
# El41JVuJ14+X60tMTVKC4isRg4ayhq6PXjF6WRlsTVVW5DUBh4WNKXP5gFyGgNQE
# WeVdESp4hkhA3eAsp6WamPU0nOjZyxCk0ex02TGCBA0wggQJAgEBMIGTMHwxCzAJ
# BgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25k
# MR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jv
# c29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwAhMzAAAB6+AYbLW27zjtAAEAAAHrMA0G
# CWCGSAFlAwQCAQUAoIIBSjAaBgkqhkiG9w0BCQMxDQYLKoZIhvcNAQkQAQQwLwYJ
# KoZIhvcNAQkEMSIEIBEPJKJW4Aw9lwaZrj7jMIFzU98NFu7PsRcA3r0CvJjEMIH6
# BgsqhkiG9w0BCRACLzGB6jCB5zCB5DCBvQQgzrdrvl9pA+F/xIENO2TYNJSAht2L
# NezPvqHUl2EsLPgwgZgwgYCkfjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2Fz
# aGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENv
# cnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAx
# MAITMwAAAevgGGy1tu847QABAAAB6zAiBCA/cTFT3erGb6vZ1HyI4ouIEC8KjE0y
# LCRfMuci80JnjDANBgkqhkiG9w0BAQsFAASCAgAsoiffvNGZEbqFobvmiT9d5Seu
# ZHAlc1y6kY7pKhPUhzIEsUEyzCWmT3DMedE5EdIuJSHxFC2ljVeYXTJbXKomv532
# K4B94mQ2n4v2/0w/i6tNdEu9ocSuuxrsanFlGiw3aGedmvxjF4khEz8PEqJbmHUh
# aejT2d6VzSQ7lYl3Z26c3y/rsBC2Q9PWbrjhkK/bNKqvVX/3v4ob4IVqAKiFyMCi
# 4+rrhl+3oUQUhn5KpWCBtpNk6YzKNB/pzg/A6ozZB+4fBOY+oV/BacXlk5u4eORP
# grzCORRJLkRxUxpmF6chPOP+XwUW6Af3NfwiMZz+C1zmQPBEfCiNnE8KDRdL8Vgf
# LWaksFPaSsFX3jhvTlHnqVBHm4ZFLPoZK/WgEP6hPwHspuMxwGEQkul6t/nOJVwR
# G5XLt8bu5+Ece85akv/P0EFDI6b7LLl2R4eCUCasFuzzhf5IFUCr18rg04x1rb3S
# EDDSoHC6MthUguMufc0195blmrVZPF57eP1NIP8Oa7rFQGJPR32NakvA+keEdSL1
# N9eitgUrsKLB2O4x2KYPm9FjSknHcmWjMN9pMEsGrNuoQ+vVMq0kAlBeV8M8WvDs
# Lrv80GGtbEo6NCpJk/TSCr6DDZ8SHMUdbnDhXy1XQladPn08NsKLBPgYsuLviol3
# BsDcxN1JNOf4F6mH5w==
# SIG # End signature block
