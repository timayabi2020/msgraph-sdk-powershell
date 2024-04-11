# ------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
# ------------------------------------------------------------------------------

Describe "The Find-MgGraphPermission Command" {

    BeforeAll {
        . (join-path $PSScriptRoot  ..\custom\Find-MgGraphPermission.ps1)
        . (Join-Path $PSScriptRoot  .\Find-MgGraphPermissionTestfile.ps1)
    }

    Context "When executing the command with empty service principal results from MS Graph" {
        BeforeAll {

            Mock Invoke-MgGraphRequest {
                [PSCustomObject] @{
                    Value = [PSCustomObject] @{
                        oauth2PermissionScopes = @()
                        appRoles               = @()
                    }
                }
            }
        }

        It 'Executes successfully with the All parameter' {
            { Find-MgGraphPermission -All | Out-Null } | Should -Not -Throw
            (_Permissions_State).isFromInvokeMgGraphRequest | Should -Be $true
            Assert-MockCalled Invoke-MgGraphRequest
            { Find-MgGraphPermission -All -Online | Out-Null } | Should -Not -Throw
        }
    }

    Context "When executing the command using a constrained set of permissions returned by MS Graph and there is a connection" {
        BeforeEach {
            _Permissions_Initialize
            Mock Invoke-MgGraphRequest { $permissionData }
        }

        It 'Executes successfully with the All parameter' {
            { Find-MgGraphPermission -All | Out-Null } | Should -Not -Throw
            Assert-MockCalled Invoke-MgGraphRequest
            (_Permissions_State).msGraphServicePrincipal | Should -Not -Be $null
            (_Permissions_State).isFromInvokeMgGraphRequest | Should -Be $true
            { Find-MgGraphPermission -Online | Out-Null } | Should -Not -Throw
        }

        It 'Executes successfully when the Any parameter is specified for some search criteria' {
            $result = Find-MgGraphPermission ReadWrite -PermissionType Any

            $result.length | Should -Be 4
        }

        It 'Should accept input from the pipeline as the SearchString parameter and find matches for each element in the pipeline' -Tag testing {
            { 'People.Read.All' | Find-MgGraphPermission -ErrorAction Stop } | Should -Not -Throw

            $pipelineMatches = 'People.Read.All', 'User.Read.Basic' | Find-MgGraphPermission

            $pipelineMatches.length | Should -Be 2
            $pipelineMatches[0].Name | Should -Be 'People.Read.All'
            $pipelineMatches[1].Name | Should -Be 'User.Read.Basic'
        }

        It 'Only calls Invoke-MgGraphRequest for the first invocation of Find-MgGraphPermission and is not called for subsequent invocations' {
            { Find-MgGraphPermission 'ReadWrite' | Out-Null } | Should -Not -Throw
            Assert-MockCalled Invoke-MgGraphRequest -Exactly 1
            { Find-MgGraphPermission 'Email' | Out-Null }
            Assert-MockCalled Invoke-MgGraphRequest -Exactly 1
        }

        It 'Calls Invoke-MgGraphRequest for the first request and then only if the Online parameter is specified' {
            Find-MgGraphPermission 'role' | Should -Not -Be $null
            Assert-MockCalled Invoke-MgGraphRequest -Exactly 1
            Find-MgGraphPermission 'user' | Should -Not -Be $null
            Assert-MockCalled Invoke-MgGraphRequest -Exactly 1
            Find-MgGraphPermission 'user' -Online | Should -Not -Be $null
            Assert-MockCalled Invoke-MgGraphRequest -Exactly 2
        }

        It "Retrieves the expected set of delegated and app-only permissions when a search string is specified" {
            { Find-MgGraphPermission 'ReadWrite' | Out-Null } | Should -Not -Throw
            Assert-MockCalled Invoke-MgGraphRequest
            $test = Find-MgGraphPermission 'ReadWrite'
            $test.GetType() | Should -Be 'System.Object[]'
            $test.length | Should -Be 4
            $test.PermissionType[0] | Should -Be 'Delegated'
            (_Permissions_State).msGraphServicePrincipal | Should -Not -Be $null
            (_Permissions_State).isFromInvokeMgGraphRequest | Should -Be $true
            { Find-MgGraphPermission 'ReadWrite' -Online | Out-Null } | Should -Not -Throw
            $testOnline = Find-MgGraphPermission 'ReadWrite' -Online
            $testOnline.length | Should -Be 4
        }

        It "Retrieves only delegated permissions even the PermissionType parameter is specified as Delegated when application permissions would also match the search string" {
            $allMatches = Find-MgGraphPermission ReadWrite

            $index = 0

            $delegatedPermissions = , 'RoleAssignmentSchedule.ReadWrite.Directory'
            $applicationPermissions = 'Directory.ReadWrite.All', 'Group.ReadWrite.All', 'WorkforceIntegration.ReadWrite.All'

            $allPermissions = @()
            $allPermissions += $delegatedPermissions
            $allPermissions += $applicationPermissions

            $allPermissions | ForEach-Object {
                $allMatches[$index++].Name | Should -Be $_
            }

            $delegatedMatches = Find-MgGraphPermission ReadWrite -PermissionType Delegated

            $delegatedIndex = 0

            $delegatedPermissions | ForEach-Object {
                $delegatedMatches[$delegatedIndex++].Name | Should -Be $_
            }
        }

        It "Should return null and not throw an exception if ExactMatch is specified and there is no match" {
            $ErrorActionPreference = 'continue'
            { Find-MgGraphPermission -ExactMatch IDontExist 2>&1 | out-null } | Should -Not -Throw

            Find-MgGraphPermission -ExactMatch IDontExistuser -ErrorAction Ignore | Should -Be $null
        }

        It "Should throw an exception if ExactMatch is specified and the specified SearchString cannot be found even when there is a partial match and the ErrorAction is stop" {
            $result = Find-MgGraphPermission Group

            $result.length | Should -Be 2

            $result | ForEach-Object {
                $_.Name | Should -BeLike '*group*'
            }

            { Find-MgGraphPermission -ExactMatch user -ErrorAction Stop 2>&1 | out-null } | Should -Throw

        }

        It "Should return exactly the permission specified" {
            Find-MgGraphPermission Group.read.basic |
            Select-Object -ExpandProperty Name |
            Should -Be 'Group.Read.Basic'
        }

        It "It allows the PermissionType to be specified when the All parameter is specified and returns the filtered results" {

            $delegatedPermissions = 'Group.Read.Basic', 'RoleAssignmentSchedule.ReadWrite.Directory', 'User.Read.Basic'

            $applicationPermissions = 'Directory.ReadWrite.All', 'Group.ReadWrite.All', 'People.Read.All', 'WorkforceIntegration.ReadWrite.All'

            $allPermissions = @()
            $allPermissions += $delegatedPermissions
            $allPermissions += $applicationPermissions

            $delegatedCount = $delegatedPermissions.Length
            $applicationCount = $applicationPermissions.Length

            $totalCount = $delegatedCount + $applicationCount

            $allMatches = Find-MgGraphPermission -All

            $allMatchesFromAny = Find-MgGraphPermission -All -PermissionType Any

            $delegatedMatches = Find-MgGraphPermission -All -PermissionType Delegated

            $applicationMatches = Find-MgGraphPermission -All -PermissionType Application

            $allMatches.Length | Should -Be $totalCount
            $allMatchesFromAny.Length | Should -Be $totalCount

            $index = 0

            $allPermissions | ForEach-Object {
                $allMatches[$index].Name | Should -Be $_
                $allMatchesFromAny[$index++].Name | Should -Be $_
            }

            $delegatedIndex = 0

            $delegatedPermissions | ForEach-Object {
                $delegatedMatches[$delegatedIndex++].Name | Should -Be $_
            }

            $applicationIndex = 0

            $applicationPermissions | ForEach-Object {
                $applicationMatches[$applicationIndex++].Name | Should -Be $_
            }
        }

        It "Retrieves only application  permissions even the PermissionType parameter is specified as Application when delegated permissions would also match the search string" {
            $allMatches = Find-MgGraphPermission ReadWrite

            $index = 0

            $delegatedPermissions = , 'RoleAssignmentSchedule.ReadWrite.Directory'
            $applicationPermissions = 'Directory.ReadWrite.All', 'Group.ReadWrite.All', 'WorkforceIntegration.ReadWrite.All'

            $allPermissions = @()
            $allPermissions += $delegatedPermissions
            $allPermissions += $applicationPermissions

            $allPermissions | ForEach-Object {
                $allMatches[$index++].Name | Should -Be $_
            }

            $applicationMatches = Find-MgGraphPermission ReadWrite -PermissionType Application

            $applicationIndex = 0

            $applicationPermissions | ForEach-Object {
                $applicationMatches[$applicationIndex++].Name | Should -Be $_
            }
        }

        It "Returns nothing and throws no exception if a search string is specified and there is no match" {
            { Find-MgGraphPermission 'Nigeria has the best jollof' | Out-Null } | Should -Not -Throw
            Assert-MockCalled Invoke-MgGraphRequest
            $test = Find-MgGraphPermission 'Nigeria has the best jollof'
            $test | Should -Be $null
            (_Permissions_State).msGraphServicePrincipal | Should -Not -Be $null
            (_Permissions_State).isFromInvokeMgGraphRequest | Should -Be $true
            { Find-MgGraphPermission 'Nigeria has the best jollof' -Online | Out-Null } | Should -Not -Throw
        }
    }

    Context "When executing the command without a connection to MS Graph" {
        BeforeEach {
            _Permissions_Initialize
            Mock Invoke-MgGraphRequest {
                Throw [Microsoft.Graph.PowerShell.AuthenticationException]::new('mock connection error message')
            }
        }

        It 'Executes successfully with the All parameter' {
            { Find-MgGraphPermission -All | Out-Null } | Should -Not -Throw
            Assert-MockCalled Invoke-MgGraphRequest
            (_Permissions_State).msGraphServicePrincipal | Should -Not -Be $null
            (_Permissions_State).isFromInvokeMgGraphRequest | Should -Be $false
            { Find-MgGraphPermission -Online | Out-Null } | Should -Throw 'mock connection error message'
        }

        It "Retrieves the expected set of delegated and app-only permissions when a search string is specified" {
            { Find-MgGraphPermission 'ReadWrite' | Out-Null } | Should -Not -Throw
            Assert-MockCalled Invoke-MgGraphRequest
            $test = Find-MgGraphPermission 'mail'
            $test | Should -Not -Be $null
            $test.length | Should -Be 17
            $test.Consent[0] | Should -Be 'User'
            $test.PermissionType[-1] | Should -Be 'Application'
            $test.Id.GetType() | Should -Be 'System.Object[]'
            (_Permissions_State).msGraphServicePrincipal | Should -Not -Be $null
            (_Permissions_State).isFromInvokeMgGraphRequest | Should -Be $false
            { Find-MgGraphPermission 'ReadWrite' -Online | Out-Null } | Should -Throw 'mock connection error message'
        }

        It "Returns nothing and throws no exception if a search string is specified and there is no match" {
            { Find-MgGraphPermission 'Nigeria has the best jollof' | Out-Null } | Should -Not -Throw
            Assert-MockCalled Invoke-MgGraphRequest
            $test = Find-MgGraphPermission 'Nigeria has the best jollof'
            $test | Should -Be $null
            (_Permissions_State).msGraphServicePrincipal | Should -Not -Be $null
            (_Permissions_State).isFromInvokeMgGraphRequest | Should -Be $false
            { Find-MgGraphPermission 'Nigeria has the best jollof' -Online | Out-Null } | Should -Throw 'mock connection error message'
        }
    }

    Context "When executing the command after initially not having a connection to MS Graph but getting it later" {
        BeforeEach {
            _Permissions_Initialize
            Mock Invoke-MgGraphRequest {
                Throw [System.Management.Automation.ValidationMetadataException]::new('mock connection error message')
            }
        }

        It 'Executes successfully with the All parameter' {
            { Find-MgGraphPermission -All | Out-Null } | Should -Not -Throw
            Assert-MockCalled Invoke-MgGraphRequest
            (_Permissions_State).msGraphServicePrincipal | Should -Not -Be $null
            (_Permissions_State).isFromInvokeMgGraphRequest | Should -Be $false
            { Find-MgGraphPermission -Online | Out-Null } | Should -Throw 'mock connection error message'

            # Restoring the connection that was set to fail in the BeforeEach
            Mock Invoke-MgGraphRequest {
                $permissionData
            }

            { Find-MgGraphPermission -All | Out-Null } | Should -Not -Throw
            Assert-MockCalled Invoke-MgGraphRequest
            (_Permissions_State).msGraphServicePrincipal | Should -Not -Be $null
            (_Permissions_State).isFromInvokeMgGraphRequest | Should -Be $true
            { Find-MgGraphPermission -Online | Out-Null } | Should -Not -Throw

        }

        It "Retrieves the expected set of delegated and app-only permissions when a search string is specified" {
            { Find-MgGraphPermission mail | Out-Null } | Should -Not -Throw
            Assert-MockCalled Invoke-MgGraphRequest
            $test = Find-MgGraphPermission 'ReadWrite'
            $test | Should -Not -Be $null
            $test.length | Should -Be 225
            (_Permissions_State).msGraphServicePrincipal | Should -Not -Be $null
            (_Permissions_State).isFromInvokeMgGraphRequest | Should -Be $false
            { Find-MgGraphPermission 'ReadWrite' -Online | Out-Null } | Should -Throw 'mock connection error message'

            # Restoring the connection that was set to fail in the BeforeEach
            Mock Invoke-MgGraphRequest {
                $permissionData
            }

            { Find-MgGraphPermission mail | Out-Null } | Should -Not -Throw
            $test = Find-MgGraphPermission 'ReadWrite'
            $test | Should -Not -Be $null
            $test.length | Should -Be 4
            (_Permissions_State).msGraphServicePrincipal | Should -Not -Be $null
            (_Permissions_State).isFromInvokeMgGraphRequest | Should -Be $true
            { Find-MgGraphPermission 'Readwrite' -Online | Out-Null } | Should -Not -Throw
        }

        It "Returns nothing and throws no exception if a search string is specified and there is no match" {
            { Find-MgGraphPermission 'Nigeria has the best jollof' | Out-Null } | Should -Not -Throw
            Assert-MockCalled Invoke-MgGraphRequest
            $test = Find-MgGraphPermission 'Nigeria has the best jollof' | Should -Be $null
            (_Permissions_State).msGraphServicePrincipal | Should -Not -Be $null
            (_Permissions_State).isFromInvokeMgGraphRequest | Should -Be $false
            { Find-MgGraphPermission 'Nigeria has the best jollof' -Online | Out-Null } | Should -Throw 'mock connection error message'

            # Restoring the connection that was set to fail in the BeforeEach
            Mock Invoke-MgGraphRequest {
                $permissionData
            }

            { Find-MgGraphPermission 'Nigeria has the best jollof' | Out-Null } | Should -Not -Throw
            Assert-MockCalled Invoke-MgGraphRequest
            $test = Find-MgGraphPermission 'Nigeria has the best jollof'
            $test | Should -Be $null
            (_Permissions_State).msGraphServicePrincipal | Should -Not -Be $null
            (_Permissions_State).isFromInvokeMgGraphRequest | Should -Be $true
            { Find-MgGraphPermission 'Nigeria has the best jollof' -Online | Out-Null } | Should -Not -Throw
        }
    }

    Context "When executing the command when initially not having access to read the service prinicpal but later having access" {
        BeforeEach {
            _Permissions_Initialize
            Mock Invoke-MgGraphRequest {
                Throw [System.Net.Http.HttpRequestException]::new('mock authentication error message')
            }
        }

        It 'Executes successfully with the All parameter' {
            { Find-MgGraphPermission -All | Out-Null } | Should -Not -Throw
            Assert-MockCalled Invoke-MgGraphRequest
            (_Permissions_State).msGraphServicePrincipal | Should -Not -Be $null
            (_Permissions_State).isFromInvokeMgGraphRequest | Should -Be $false
            { Find-MgGraphPermission -All -Online | Out-Null } | Should -Throw 'mock authentication error message'

            # Restoring the connection that was set to fail in the BeforeEach
            Mock Invoke-MgGraphRequest {
                $permissionData
            }

            { Find-MgGraphPermission -All | Out-Null } | Should -Not -Throw
            Assert-MockCalled Invoke-MgGraphRequest
            (_Permissions_State).msGraphServicePrincipal | Should -Not -Be $null
            (_Permissions_State).isFromInvokeMgGraphRequest | Should -Be $true
            { Find-MgGraphPermission -All -Online | Out-Null } | Should -Not -Throw

        }

        It "Retrieves the expected set of delegated and app-only permissions when a search string is specified" {
            { Find-MgGraphPermission mail | Out-Null } | Should -Not -Throw
            Assert-MockCalled Invoke-MgGraphRequest
            $test = Find-MgGraphPermission 'ReadWrite'
            $test | Should -Not -Be $null
            $test.length | Should -Be 225
            (_Permissions_State).msGraphServicePrincipal | Should -Not -Be $null
            (_Permissions_State).isFromInvokeMgGraphRequest | Should -Be $false
            { Find-MgGraphPermission 'ReadWrite' -Online | Out-Null } | Should -Throw 'mock authentication error message'

            # Restoring the connection that was set to fail in the BeforeEach
            Mock Invoke-MgGraphRequest {
                $permissionData
            }

            { Find-MgGraphPermission mail | Out-Null } | Should -Not -Throw
            Assert-MockCalled Invoke-MgGraphRequest
            $test = Find-MgGraphPermission 'ReadWrite'
            $test | Should -Not -Be $null
            $test.length | Should -Be 4
            (_Permissions_State).msGraphServicePrincipal | Should -Not -Be $null
            (_Permissions_State).isFromInvokeMgGraphRequest | Should -Be $true
            { Find-MgGraphPermission 'ReadWrite' -Online | Out-Null } | Should -Not -Throw
        }

        It "Returns nothing and throws no exception if a search string is specified and there is no match" {
            { Find-MgGraphPermission 'Nigeria has the best jollof' | Out-Null } | Should -Not -Throw
            Assert-MockCalled Invoke-MgGraphRequest
            $test = Find-MgGraphPermission 'Nigeria has the best jollof' | Should -Be $null
            (_Permissions_State).msGraphServicePrincipal | Should -Not -Be $null
            (_Permissions_State).isFromInvokeMgGraphRequest | Should -Be $false
            { Find-MgGraphPermission 'Nigeria has the best jollof' -Online | Out-Null } | Should -Throw 'mock authentication error message'

            # Restoring the connection that was set to fail in the BeforeEach
            Mock Invoke-MgGraphRequest {
                $permissionData
            }

            { Find-MgGraphPermission 'Nigeria has the best jollof' | Out-Null } | Should -Not -Throw
            Assert-MockCalled Invoke-MgGraphRequest
            $test = Find-MgGraphPermission 'Nigeria has the best jollof'
            $test | Should -Be $null
            (_Permissions_State).msGraphServicePrincipal | Should -Not -Be $null
            (_Permissions_State).isFromInvokeMgGraphRequest | Should -Be $true
            { Find-MgGraphPermission 'Nigeria has the best jollof' -Online | Out-Null } | Should -Not -Throw
        }
    }
}

# SIG # Begin signature block
# MIInzgYJKoZIhvcNAQcCoIInvzCCJ7sCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCAwhUBqrgqma/bN
# MwOU6DtY2UodNr14VBryNruB7IRDi6CCDYUwggYDMIID66ADAgECAhMzAAADri01
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
# cVZOSEXAQsmbdlsKgEhr/Xmfwb1tbWrJUnMTDXpQzTGCGZ8wghmbAgEBMIGVMH4x
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01p
# Y3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTECEzMAAAOuLTVRyFOPVR0AAAAA
# A64wDQYJYIZIAWUDBAIBBQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQw
# HAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIF6k
# 90aWVvtSN41hmyBQ1rI3PQvntBRNsEdWp+DzXkCuMEIGCisGAQQBgjcCAQwxNDAy
# oBSAEgBNAGkAYwByAG8AcwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20wDQYJKoZIhvcNAQEBBQAEggEA3aIjDCAdadb8McP1xOETrchdaC4bLfMgGFLT
# 1VCeus+bC05gRhzRhWR/5KJSUIgDnSAm2hPNiLWJrauJBpyk5EAXptzKN1CBCyO1
# emzFrDz/w4dUA/oZ2L0SxOUfZyJ4mWd4qETwK5di7l4L7KAI8g6fkLhpfPwr3TsY
# heKoVS8DT3QePzAKgdzuqgwqpEXGcC1VJWAcY6FZsfr7ZyisXCH+qH0UiiLN1xYK
# jCRzUsjVRJVgsEb5FFPNIGsHnmZ/JfxYuuw5Bb66ybjaeVZU4+uGFhvqAXCOfY+Y
# fJoCxJp2EP/v8Llc0SAoEcJVUMiM/Ly8IAda9FKPOfhwsmc3BaGCFykwghclBgor
# BgEEAYI3AwMBMYIXFTCCFxEGCSqGSIb3DQEHAqCCFwIwghb+AgEDMQ8wDQYJYIZI
# AWUDBAIBBQAwggFZBgsqhkiG9w0BCRABBKCCAUgEggFEMIIBQAIBAQYKKwYBBAGE
# WQoDATAxMA0GCWCGSAFlAwQCAQUABCBpxNWWJtLfegmfAv8Dr9Vu+NL0HjeLUl9d
# AY8WR+48LQIGZfyo6aO+GBMyMDI0MDQxMTE0MjgyOC4yNjRaMASAAgH0oIHYpIHV
# MIHSMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMS0wKwYDVQQL
# EyRNaWNyb3NvZnQgSXJlbGFuZCBPcGVyYXRpb25zIExpbWl0ZWQxJjAkBgNVBAsT
# HVRoYWxlcyBUU1MgRVNOOkQwODItNEJGRC1FRUJBMSUwIwYDVQQDExxNaWNyb3Nv
# ZnQgVGltZS1TdGFtcCBTZXJ2aWNloIIReDCCBycwggUPoAMCAQICEzMAAAHcweCM
# wl9YXo4AAQAAAdwwDQYJKoZIhvcNAQELBQAwfDELMAkGA1UEBhMCVVMxEzARBgNV
# BAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jv
# c29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAg
# UENBIDIwMTAwHhcNMjMxMDEyMTkwNzA2WhcNMjUwMTEwMTkwNzA2WjCB0jELMAkG
# A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQx
# HjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEtMCsGA1UECxMkTWljcm9z
# b2Z0IElyZWxhbmQgT3BlcmF0aW9ucyBMaW1pdGVkMSYwJAYDVQQLEx1UaGFsZXMg
# VFNTIEVTTjpEMDgyLTRCRkQtRUVCQTElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUt
# U3RhbXAgU2VydmljZTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAIvI
# syA1sjg9kSKJzelrUWF5ShqYWL83amn3SE5JyIVPUC7F6qTcLphhHZ9idf21f0Ra
# GrU8EHydF8NxPMR2KVNiAtCGPJa8kV1CGvn3beGB2m2ltmqJanG71mAywrkKATYn
# iwKLPQLJ00EkXw5TSwfmJXbdgQLFlHyfA5Kg+pUsJXzqumkIvEr0DXPvptAGqkdF
# LKwo4BTlEgnvzeTfXukzX8vQtTALfVJuTUgRU7zoP/RFWt3WagahZ6UloI0FC8Xl
# BQDVDX5JeMEsx7jgJDdEnK44Y8gHuEWRDq+SG9Xo0GIOjiuTWD5uv3vlEmIAyR/7
# rSFvcLnwAqMdqcy/iqQPMlDOcd0AbniP8ia1BQEUnfZT3UxyK9rLB/SRiKPyHDlg
# 8oWwXyiv3+bGB6dmdM61ur6nUtfDf51lPcKhK4Vo83pOE1/niWlVnEHQV9NJ5/Db
# USqW2RqTUa2O2KuvsyRGMEgjGJA12/SqrRqlvE2fiN5ZmZVtqSPWaIasx7a0GB+f
# dTw+geRn6Mo2S6+/bZEwS/0IJ5gcKGinNbfyQ1xrvWXPtXzKOfjkh75iRuXourGV
# PRqkmz5UYz+R5ybMJWj+mfcGqz2hXV8iZnCZDBrrnZivnErCMh5Flfg8496pT0ph
# jUTH2GChHIvE4SDSk2hwWP/uHB9gEs8p/9Pe/mt9AgMBAAGjggFJMIIBRTAdBgNV
# HQ4EFgQU6HPSBd0OfEX3uNWsdkSraUGe3dswHwYDVR0jBBgwFoAUn6cVXQBeYl2D
# 9OXSZacbUzUZ6XIwXwYDVR0fBFgwVjBUoFKgUIZOaHR0cDovL3d3dy5taWNyb3Nv
# ZnQuY29tL3BraW9wcy9jcmwvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUy
# MDIwMTAoMSkuY3JsMGwGCCsGAQUFBwEBBGAwXjBcBggrBgEFBQcwAoZQaHR0cDov
# L3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9jZXJ0cy9NaWNyb3NvZnQlMjBUaW1l
# LVN0YW1wJTIwUENBJTIwMjAxMCgxKS5jcnQwDAYDVR0TAQH/BAIwADAWBgNVHSUB
# Af8EDDAKBggrBgEFBQcDCDAOBgNVHQ8BAf8EBAMCB4AwDQYJKoZIhvcNAQELBQAD
# ggIBANnrb8Ewr8eX/H1sKt3rnwTDx4AqgHbkMNQo+kUGwCINXS3y1GUcdqsK/R1g
# 6Tf7tNx1q0NpKk1JTupUJfHdExKtkuhHA+82lT7yISp/Y74dqJ03RCT4Q+8ooQXT
# MzxiewfErVLt8WefebncST0i6ypKv87pCYkxM24bbqbM/V+M5VBppCUs7R+cETiz
# /zEA1AbZL/viXtHmryA0CGd+Pt9c+adsYfm7qe5UMnS0f/YJmEEMkEqGXCzyLK+d
# h+UsFi0d4lkdcE+Zq5JNjIHesX1wztGVAtvX0DYDZdN2WZ1kk+hOMblUV/L8n1YW
# zhP/5XQnYl03AfXErn+1Eatylifzd3ChJ1xuGG76YbWgiRXnDvCiwDqvUJevVRY1
# qy4y4vlVKaShtbdfgPyGeeJ/YcSBONOc0DNTWbjMbL50qeIEC0lHSpL2rRYNVu3h
# sHzG8n5u5CQajPwx9PzpsZIeFTNHyVF6kujI4Vo9NvO/zF8Ot44IMj4M7UX9Za4Q
# wGf5B71x57OjaX53gxT4vzoHvEBXF9qCmHRgXBLbRomJfDn60alzv7dpCVQIuQ06
# 2nyIZKnsXxzuKFb0TjXWw6OFpG1bsjXpOo5DMHkysribxHor4Yz5dZjVyHANyKo0
# bSrAlVeihcaG5F74SZT8FtyHAW6IgLc5w/3D+R1obDhKZ21WMIIHcTCCBVmgAwIB
# AgITMwAAABXF52ueAptJmQAAAAAAFTANBgkqhkiG9w0BAQsFADCBiDELMAkGA1UE
# BhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAc
# BgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEyMDAGA1UEAxMpTWljcm9zb2Z0
# IFJvb3QgQ2VydGlmaWNhdGUgQXV0aG9yaXR5IDIwMTAwHhcNMjEwOTMwMTgyMjI1
# WhcNMzAwOTMwMTgzMjI1WjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGlu
# Z3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBv
# cmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDCC
# AiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAOThpkzntHIhC3miy9ckeb0O
# 1YLT/e6cBwfSqWxOdcjKNVf2AX9sSuDivbk+F2Az/1xPx2b3lVNxWuJ+Slr+uDZn
# hUYjDLWNE893MsAQGOhgfWpSg0S3po5GawcU88V29YZQ3MFEyHFcUTE3oAo4bo3t
# 1w/YJlN8OWECesSq/XJprx2rrPY2vjUmZNqYO7oaezOtgFt+jBAcnVL+tuhiJdxq
# D89d9P6OU8/W7IVWTe/dvI2k45GPsjksUZzpcGkNyjYtcI4xyDUoveO0hyTD4MmP
# frVUj9z6BVWYbWg7mka97aSueik3rMvrg0XnRm7KMtXAhjBcTyziYrLNueKNiOSW
# rAFKu75xqRdbZ2De+JKRHh09/SDPc31BmkZ1zcRfNN0Sidb9pSB9fvzZnkXftnIv
# 231fgLrbqn427DZM9ituqBJR6L8FA6PRc6ZNN3SUHDSCD/AQ8rdHGO2n6Jl8P0zb
# r17C89XYcz1DTsEzOUyOArxCaC4Q6oRRRuLRvWoYWmEBc8pnol7XKHYC4jMYcten
# IPDC+hIK12NvDMk2ZItboKaDIV1fMHSRlJTYuVD5C4lh8zYGNRiER9vcG9H9stQc
# xWv2XFJRXRLbJbqvUAV6bMURHXLvjflSxIUXk8A8FdsaN8cIFRg/eKtFtvUeh17a
# j54WcmnGrnu3tz5q4i6tAgMBAAGjggHdMIIB2TASBgkrBgEEAYI3FQEEBQIDAQAB
# MCMGCSsGAQQBgjcVAgQWBBQqp1L+ZMSavoKRPEY1Kc8Q/y8E7jAdBgNVHQ4EFgQU
# n6cVXQBeYl2D9OXSZacbUzUZ6XIwXAYDVR0gBFUwUzBRBgwrBgEEAYI3TIN9AQEw
# QTA/BggrBgEFBQcCARYzaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9E
# b2NzL1JlcG9zaXRvcnkuaHRtMBMGA1UdJQQMMAoGCCsGAQUFBwMIMBkGCSsGAQQB
# gjcUAgQMHgoAUwB1AGIAQwBBMAsGA1UdDwQEAwIBhjAPBgNVHRMBAf8EBTADAQH/
# MB8GA1UdIwQYMBaAFNX2VsuP6KJcYmjRPZSQW9fOmhjEMFYGA1UdHwRPME0wS6BJ
# oEeGRWh0dHA6Ly9jcmwubWljcm9zb2Z0LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL01p
# Y1Jvb0NlckF1dF8yMDEwLTA2LTIzLmNybDBaBggrBgEFBQcBAQROMEwwSgYIKwYB
# BQUHMAKGPmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2kvY2VydHMvTWljUm9v
# Q2VyQXV0XzIwMTAtMDYtMjMuY3J0MA0GCSqGSIb3DQEBCwUAA4ICAQCdVX38Kq3h
# LB9nATEkW+Geckv8qW/qXBS2Pk5HZHixBpOXPTEztTnXwnE2P9pkbHzQdTltuw8x
# 5MKP+2zRoZQYIu7pZmc6U03dmLq2HnjYNi6cqYJWAAOwBb6J6Gngugnue99qb74p
# y27YP0h1AdkY3m2CDPVtI1TkeFN1JFe53Z/zjj3G82jfZfakVqr3lbYoVSfQJL1A
# oL8ZthISEV09J+BAljis9/kpicO8F7BUhUKz/AyeixmJ5/ALaoHCgRlCGVJ1ijbC
# HcNhcy4sa3tuPywJeBTpkbKpW99Jo3QMvOyRgNI95ko+ZjtPu4b6MhrZlvSP9pEB
# 9s7GdP32THJvEKt1MMU0sHrYUP4KWN1APMdUbZ1jdEgssU5HLcEUBHG/ZPkkvnNt
# yo4JvbMBV0lUZNlz138eW0QBjloZkWsNn6Qo3GcZKCS6OEuabvshVGtqRRFHqfG3
# rsjoiV5PndLQTHa1V1QJsWkBRH58oWFsc/4Ku+xBZj1p/cvBQUl+fpO+y/g75LcV
# v7TOPqUxUYS8vwLBgqJ7Fx0ViY1w/ue10CgaiQuPNtq6TPmb/wrpNPgkNWcr4A24
# 5oyZ1uEi6vAnQj0llOZ0dFtq0Z4+7X6gMTN9vMvpe784cETRkPHIqzqKOghif9lw
# Y1NNje6CbaUFEMFxBmoQtB1VM1izoXBm8qGCAtQwggI9AgEBMIIBAKGB2KSB1TCB
# 0jELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1Jl
# ZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEtMCsGA1UECxMk
# TWljcm9zb2Z0IElyZWxhbmQgT3BlcmF0aW9ucyBMaW1pdGVkMSYwJAYDVQQLEx1U
# aGFsZXMgVFNTIEVTTjpEMDgyLTRCRkQtRUVCQTElMCMGA1UEAxMcTWljcm9zb2Z0
# IFRpbWUtU3RhbXAgU2VydmljZaIjCgEBMAcGBSsOAwIaAxUAHDn/cz+3yRkIUCJf
# SbL3djnQEqaggYMwgYCkfjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGlu
# Z3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBv
# cmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDAN
# BgkqhkiG9w0BAQUFAAIFAOnCLHIwIhgPMjAyNDA0MTExNzMxMzBaGA8yMDI0MDQx
# MjE3MzEzMFowdDA6BgorBgEEAYRZCgQBMSwwKjAKAgUA6cIscgIBADAHAgEAAgIW
# wTAHAgEAAgISPzAKAgUA6cN98gIBADA2BgorBgEEAYRZCgQCMSgwJjAMBgorBgEE
# AYRZCgMCoAowCAIBAAIDB6EgoQowCAIBAAIDAYagMA0GCSqGSIb3DQEBBQUAA4GB
# AKu5HUKZ12xzaW4sOmviwwZmuMfifZ31HpaAy5x/86javjlyKVBDSsdi5Ie8M3he
# mw3RsuGxe1MDXn5wU3kTiBbmXKmG/fFMSI2TjfzC8ZUBwmzuIEg+aYN4VWb8rCTd
# X44D8uhcCZUNfnxrm+uuJ+sAqPx3GjbY13uyTfCIvKxnMYIEDTCCBAkCAQEwgZMw
# fDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1Jl
# ZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMd
# TWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTACEzMAAAHcweCMwl9YXo4AAQAA
# AdwwDQYJYIZIAWUDBAIBBQCgggFKMBoGCSqGSIb3DQEJAzENBgsqhkiG9w0BCRAB
# BDAvBgkqhkiG9w0BCQQxIgQgrcGS6UEfJJPWiQApZ1flNCljvSsiEw/qdDFVa9bm
# a58wgfoGCyqGSIb3DQEJEAIvMYHqMIHnMIHkMIG9BCBTpxeKatlEP4y8qZzjuWL0
# Ou0IqxELDhX2TLylxIINNzCBmDCBgKR+MHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQI
# EwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3Nv
# ZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBD
# QSAyMDEwAhMzAAAB3MHgjMJfWF6OAAEAAAHcMCIEICGDIUP4lU2DE0qYvW1ZwH3x
# IMCH5pg5yToUEgnAGY+aMA0GCSqGSIb3DQEBCwUABIICAGmAJkHhJMnpDK90rorq
# YMwSxz0c0sY4ISSgZXb7WKYhUnOHBkXtdRqy65FeffboHhympPjv/Iw0UbGBxm3O
# myAzn7J+e7t0CKwxfGOKgLuMd1CyK2Tk6gCAaK8pZIrc+LLVFZMQ5rvgeRkqe5cz
# LF5cVQ9UNsOyUtZp4W2Ea1ONFU5m8DgoFlOPWUYU9Udk+/ceokZoZkpd8zfHZYvL
# 4yAhXr9xywIU4W9FXy5j+U/tA/Nvk7SUWP+SaKzJgHRt3K31yHJNYIjiJaS1yI+U
# K6ASFJw2HwIpCrBKn8TfGzWE2ehWIJZEnISG9gl5tsWYLeL5l3OJYKDWlOCvt7YT
# 3/++/Uv2W04m1oUPksqbIgiLOOPGurqbXyd7rw+BnLXnNoz8dNn4/udVsUsqCVBw
# c7sWiiZbIXeTpjLbxmoZECq6k0lbBMJF9RIW1uKhdYhN8bjxHr6gsnlTYMzmldxO
# NxHV+j6iPvFCcoi7yBQ8O65SjpFKA+j+jxYujgmUXGXBlnkvwNblp9bqx1lBnEH6
# kc+V0Dk9edqZQYx6LmPq3/+G2+NW9RMz0cV+M18bHHAf83cRufS/EhW1WIbwytZ8
# qIAdMsQa/76CedHjnV5+Pu8otJLGU4c+wHpwd4UNV7tj8H6kaxwzOphaGQ4TOPWQ
# X4LyUnGBue18DagCdbSYtAG7
# SIG # End signature block
