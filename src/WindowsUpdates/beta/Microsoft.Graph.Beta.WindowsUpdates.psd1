#
# Module manifest for module 'Microsoft.Graph.Beta.WindowsUpdates'
#
# Generated by: Microsoft Corporation
#
# Generated on: 7/18/2023
#

@{

# Script module or binary module file associated with this manifest.
RootModule = './Microsoft.Graph.Beta.WindowsUpdates.psm1'

# Version number of this module.
ModuleVersion = '2.2.0'

# Supported PSEditions
CompatiblePSEditions = 'Core', 'Desktop'

# ID used to uniquely identify this module
GUID = '25f27404-c493-44fc-9523-af74c27aaf0c'

# Author of this module
Author = 'Microsoft Corporation'

# Company or vendor of this module
CompanyName = 'Microsoft Corporation'

# Copyright statement for this module
Copyright = 'Microsoft Corporation. All rights reserved.'

# Description of the functionality provided by this module
Description = 'Microsoft Graph PowerShell Cmdlets'

# Minimum version of the PowerShell engine required by this module
PowerShellVersion = '5.1'

# Name of the PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
DotNetFrameworkVersion = '4.7.2'

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# ClrVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
RequiredModules = @(@{ModuleName = 'Microsoft.Graph.Authentication'; RequiredVersion = '2.2.0'; })

# Assemblies that must be loaded prior to importing this module
RequiredAssemblies = './bin/Microsoft.Graph.Beta.WindowsUpdates.private.dll'

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
FormatsToProcess = './Microsoft.Graph.Beta.WindowsUpdates.format.ps1xml'

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = 'Add-MgBetaWindowsUpdatesDeploymentAudienceExclusionMemberById', 
               'Add-MgBetaWindowsUpdatesDeploymentAudienceMember', 
               'Add-MgBetaWindowsUpdatesDeploymentAudienceMemberById', 
               'Add-MgBetaWindowsUpdatesPolicyAudienceExclusionMember', 
               'Add-MgBetaWindowsUpdatesPolicyAudienceExclusionMemberById', 
               'Add-MgBetaWindowsUpdatesPolicyAudienceMember', 
               'Add-MgBetaWindowsUpdatesPolicyAudienceMemberById', 
               'Add-MgBetaWindowsUpdatesUpdatableAssetMember', 
               'Add-MgBetaWindowsUpdatesUpdatableAssetMemberById', 
               'Get-MgBetaWindowsUpdatesCatalogEntry', 
               'Get-MgBetaWindowsUpdatesCatalogEntryCount', 
               'Get-MgBetaWindowsUpdatesDeployment', 
               'Get-MgBetaWindowsUpdatesDeploymentAudienceExclusion', 
               'Get-MgBetaWindowsUpdatesDeploymentAudienceExclusionCount', 
               'Get-MgBetaWindowsUpdatesDeploymentAudienceMember', 
               'Get-MgBetaWindowsUpdatesDeploymentAudienceMemberCount', 
               'Get-MgBetaWindowsUpdatesDeploymentCount', 
               'Get-MgBetaWindowsUpdatesPolicy', 
               'Get-MgBetaWindowsUpdatesPolicyAudience', 
               'Get-MgBetaWindowsUpdatesPolicyAudienceExclusion', 
               'Get-MgBetaWindowsUpdatesPolicyAudienceExclusionCount', 
               'Get-MgBetaWindowsUpdatesPolicyAudienceMember', 
               'Get-MgBetaWindowsUpdatesPolicyAudienceMemberCount', 
               'Get-MgBetaWindowsUpdatesPolicyComplianceChange', 
               'Get-MgBetaWindowsUpdatesPolicyComplianceChangeCount', 
               'Get-MgBetaWindowsUpdatesPolicyComplianceChangeUpdatePolicy', 
               'Get-MgBetaWindowsUpdatesPolicyCount', 
               'Get-MgBetaWindowsUpdatesResourceConnection', 
               'Get-MgBetaWindowsUpdatesResourceConnectionCount', 
               'Get-MgBetaWindowsUpdatesUpdatableAsset', 
               'Get-MgBetaWindowsUpdatesUpdatableAssetCount', 
               'Invoke-MgBetaEnrollWindowsUpdatesDeploymentAudienceExclusionAssetById', 
               'Invoke-MgBetaEnrollWindowsUpdatesDeploymentAudienceMemberAssetById', 
               'Invoke-MgBetaEnrollWindowsUpdatesPolicyAudienceExclusionAsset', 
               'Invoke-MgBetaEnrollWindowsUpdatesPolicyAudienceExclusionAssetById', 
               'Invoke-MgBetaEnrollWindowsUpdatesPolicyAudienceMemberAsset', 
               'Invoke-MgBetaEnrollWindowsUpdatesPolicyAudienceMemberAssetById', 
               'Invoke-MgBetaEnrollWindowsUpdatesUpdatableAsset', 
               'Invoke-MgBetaEnrollWindowsUpdatesUpdatableAssetById', 
               'Invoke-MgBetaGraphWindowsUpdatesDeploymentAudienceExclusion', 
               'Invoke-MgBetaGraphWindowsUpdatesDeploymentAudienceMember', 
               'Invoke-MgBetaGraphWindowsUpdatesPolicyAudienceExclusion', 
               'Invoke-MgBetaGraphWindowsUpdatesPolicyAudienceMember', 
               'Invoke-MgBetaGraphWindowsUpdatesUpdatableAsset', 
               'Invoke-MgBetaUnenrollWindowsUpdatesPolicyAudienceExclusionAsset', 
               'Invoke-MgBetaUnenrollWindowsUpdatesPolicyAudienceMemberAsset', 
               'Invoke-MgBetaUnenrollWindowsUpdatesUpdatableAsset', 
               'New-MgBetaWindowsUpdatesDeployment', 
               'New-MgBetaWindowsUpdatesPolicy', 
               'New-MgBetaWindowsUpdatesPolicyAudienceExclusion', 
               'New-MgBetaWindowsUpdatesPolicyAudienceMember', 
               'New-MgBetaWindowsUpdatesPolicyComplianceChange', 
               'New-MgBetaWindowsUpdatesResourceConnection', 
               'New-MgBetaWindowsUpdatesUpdatableAsset', 
               'Remove-MgBetaWindowsUpdatesDeployment', 
               'Remove-MgBetaWindowsUpdatesDeploymentAudienceExclusionMemberById', 
               'Remove-MgBetaWindowsUpdatesDeploymentAudienceMemberById', 
               'Remove-MgBetaWindowsUpdatesPolicy', 
               'Remove-MgBetaWindowsUpdatesPolicyAudience', 
               'Remove-MgBetaWindowsUpdatesPolicyAudienceExclusion', 
               'Remove-MgBetaWindowsUpdatesPolicyAudienceExclusionMember', 
               'Remove-MgBetaWindowsUpdatesPolicyAudienceExclusionMemberById', 
               'Remove-MgBetaWindowsUpdatesPolicyAudienceMember', 
               'Remove-MgBetaWindowsUpdatesPolicyAudienceMemberById', 
               'Remove-MgBetaWindowsUpdatesPolicyComplianceChange', 
               'Remove-MgBetaWindowsUpdatesResourceConnection', 
               'Remove-MgBetaWindowsUpdatesUpdatableAsset', 
               'Remove-MgBetaWindowsUpdatesUpdatableAssetMember', 
               'Remove-MgBetaWindowsUpdatesUpdatableAssetMemberById', 
               'Update-MgBetaWindowsUpdatesDeployment', 
               'Update-MgBetaWindowsUpdatesDeploymentAudience', 
               'Update-MgBetaWindowsUpdatesDeploymentAudienceById', 
               'Update-MgBetaWindowsUpdatesPolicy', 
               'Update-MgBetaWindowsUpdatesPolicyAudience', 
               'Update-MgBetaWindowsUpdatesPolicyAudienceById', 
               'Update-MgBetaWindowsUpdatesPolicyAudienceExclusion', 
               'Update-MgBetaWindowsUpdatesPolicyAudienceMember', 
               'Update-MgBetaWindowsUpdatesPolicyComplianceChange', 
               'Update-MgBetaWindowsUpdatesResourceConnection', 
               'Update-MgBetaWindowsUpdatesUpdatableAsset'

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
# VariablesToExport = @()

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = 'Add-MgBetaWuDeploymentAudienceExclusionMemberGraphBPreId', 
               'Add-MgBetaWuDeploymentAudienceMember', 
               'Add-MgBetaWuDeploymentAudienceMemberGraphBPreId', 
               'Add-MgBetaWuPolicyAudienceExclusionMember', 
               'Add-MgBetaWuPolicyAudienceExclusionMemberGraphBPreId', 
               'Add-MgBetaWuPolicyAudienceMember', 
               'Add-MgBetaWuPolicyAudienceMemberGraphBPreId', 
               'Add-MgBetaWuUpdatableAssetMember', 
               'Add-MgBetaWuUpdatableAssetMemberGraphBPreId', 
               'Get-MgBetaWuCatalogEntry', 'Get-MgBetaWuCatalogEntryCount', 
               'Get-MgBetaWuDeployment', 'Get-MgBetaWuDeploymentAudienceExclusion', 
               'Get-MgBetaWuDeploymentAudienceExclusionCount', 
               'Get-MgBetaWuDeploymentAudienceMember', 
               'Get-MgBetaWuDeploymentAudienceMemberCount', 
               'Get-MgBetaWuDeploymentCount', 'Get-MgBetaWuPolicy', 
               'Get-MgBetaWuPolicyAudience', 'Get-MgBetaWuPolicyAudienceExclusion', 
               'Get-MgBetaWuPolicyAudienceExclusionCount', 
               'Get-MgBetaWuPolicyAudienceMember', 
               'Get-MgBetaWuPolicyAudienceMemberCount', 
               'Get-MgBetaWuPolicyComplianceChange', 
               'Get-MgBetaWuPolicyComplianceChangeCount', 
               'Get-MgBetaWuPolicyComplianceChangeUpdatePolicy', 
               'Get-MgBetaWuPolicyCount', 'Get-MgBetaWuResourceConnection', 
               'Get-MgBetaWuResourceConnectionCount', 'Get-MgBetaWuUpdatableAsset', 
               'Get-MgBetaWuUpdatableAssetCount', 
               'Invoke-MgBetaEnrollWuDeploymentAudienceExclusionAssetGraphBPreId', 
               'Invoke-MgBetaEnrollWuDeploymentAudienceMemberAssetGraphBPreId', 
               'Invoke-MgBetaEnrollWuPolicyAudienceExclusionAsset', 
               'Invoke-MgBetaEnrollWuPolicyAudienceExclusionAssetGraphBPreId', 
               'Invoke-MgBetaEnrollWuPolicyAudienceMemberAsset', 
               'Invoke-MgBetaEnrollWuPolicyAudienceMemberAssetGraphBPreId', 
               'Invoke-MgBetaEnrollWuUpdatableAsset', 
               'Invoke-MgBetaEnrollWuUpdatableAssetGraphBPreId', 
               'Invoke-MgBetaGraphWuDeploymentAudienceExclusion', 
               'Invoke-MgBetaGraphWuDeploymentAudienceMember', 
               'Invoke-MgBetaGraphWuPolicyAudienceExclusion', 
               'Invoke-MgBetaGraphWuPolicyAudienceMember', 
               'Invoke-MgBetaGraphWuUpdatableAsset', 
               'Invoke-MgBetaUnenrollWuPolicyAudienceExclusionAsset', 
               'Invoke-MgBetaUnenrollWuPolicyAudienceMemberAsset', 
               'Invoke-MgBetaUnenrollWuUpdatableAsset', 'New-MgBetaWuDeployment', 
               'New-MgBetaWuPolicy', 'New-MgBetaWuPolicyAudienceExclusion', 
               'New-MgBetaWuPolicyAudienceMember', 
               'New-MgBetaWuPolicyComplianceChange', 
               'New-MgBetaWuResourceConnection', 'New-MgBetaWuUpdatableAsset', 
               'Remove-MgBetaWuDeployment', 
               'Remove-MgBetaWuDeploymentAudienceExclusionMemberGraphBPreId', 
               'Remove-MgBetaWuDeploymentAudienceMemberGraphBPreId', 
               'Remove-MgBetaWuPolicy', 'Remove-MgBetaWuPolicyAudience', 
               'Remove-MgBetaWuPolicyAudienceExclusion', 
               'Remove-MgBetaWuPolicyAudienceExclusionMember', 
               'Remove-MgBetaWuPolicyAudienceExclusionMemberGraphBPreId', 
               'Remove-MgBetaWuPolicyAudienceMember', 
               'Remove-MgBetaWuPolicyAudienceMemberGraphBPreId', 
               'Remove-MgBetaWuPolicyComplianceChange', 
               'Remove-MgBetaWuResourceConnection', 
               'Remove-MgBetaWuUpdatableAsset', 
               'Remove-MgBetaWuUpdatableAssetMember', 
               'Remove-MgBetaWuUpdatableAssetMemberGraphBPreId', 
               'Update-MgBetaWuDeployment', 'Update-MgBetaWuDeploymentAudience', 
               'Update-MgBetaWuDeploymentAudienceGraphBPreId', 
               'Update-MgBetaWuPolicy', 'Update-MgBetaWuPolicyAudience', 
               'Update-MgBetaWuPolicyAudienceGraphBPreId', 
               'Update-MgBetaWuPolicyAudienceExclusion', 
               'Update-MgBetaWuPolicyAudienceMember', 
               'Update-MgBetaWuPolicyComplianceChange', 
               'Update-MgBetaWuResourceConnection', 
               'Update-MgBetaWuUpdatableAsset'

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = 'Microsoft','Office365','Graph','PowerShell','PSModule','PSIncludes_Cmdlet'

        # A URL to the license for this module.
        LicenseUri = 'https://aka.ms/devservicesagreement'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/microsoftgraph/msgraph-sdk-powershell'

        # A URL to an icon representing this module.
        IconUri = 'https://raw.githubusercontent.com/microsoftgraph/msgraph-sdk-powershell/features/2.0/docs/images/graph_color256.png'

        # ReleaseNotes of this module
        ReleaseNotes = 'See https://aka.ms/GraphPowerShell-Release.'

        # Prerelease string of this module
        # Prerelease = ''

        # Flag to indicate whether the module requires explicit user acceptance for install/update/save
        # RequireLicenseAcceptance = $false

        # External dependent modules of this module
        # ExternalModuleDependencies = @()

    } # End of PSData hashtable

 } # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}


# SIG # Begin signature block
# MIInpQYJKoZIhvcNAQcCoIInljCCJ5ICAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCDGk6NRA4tX56Wq
# fxm9eaOJ+EM/yI1gDfQ7YkhJDkeKiqCCDYUwggYDMIID66ADAgECAhMzAAADTU6R
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
# cVZOSEXAQsmbdlsKgEhr/Xmfwb1tbWrJUnMTDXpQzTGCGXYwghlyAgEBMIGVMH4x
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01p
# Y3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTECEzMAAANNTpGmGiiweI8AAAAA
# A00wDQYJYIZIAWUDBAIBBQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQw
# HAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEII4c
# UylO1W6CXxwuudPbNtRqQnHRwZ9nGms6gjAjVWxiMEIGCisGAQQBgjcCAQwxNDAy
# oBSAEgBNAGkAYwByAG8AcwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20wDQYJKoZIhvcNAQEBBQAEggEAVQL0PIN0zvaqDzgCMZs2cUznWg+hWQymjH2Z
# f1VNanxluukB0MZIMq2R2k/2E4qrXeJKlJ+23+cpgAmlIHvDAQrR65ks3QFZs9fs
# l/JqNHcFaMWtz+AEcK8EA/WRRnIHiFaCit0RDYb61WgYcaGOII83c8IgSdda/sY4
# pU0oDyveddC3VWBtHUkT0xx0nQbrOHF5FwnHqYpc8TEAE77UiPHCe0X2EKZ793pt
# 0oGwekivXR3kC2iN8fIBVWDvEaK6zHk/H80klTQvQTFjAP2QsD7RHo9EmN65e4qF
# GfqgNDK+HUOq/IlZDvaL6fDAYGonQ1MZ1jFpGQpN4kiUkaLEmaGCFwAwghb8Bgor
# BgEEAYI3AwMBMYIW7DCCFugGCSqGSIb3DQEHAqCCFtkwghbVAgEDMQ8wDQYJYIZI
# AWUDBAIBBQAwggFRBgsqhkiG9w0BCRABBKCCAUAEggE8MIIBOAIBAQYKKwYBBAGE
# WQoDATAxMA0GCWCGSAFlAwQCAQUABCDtEULaQh+x2GKE1JyGvk5DtGuqYbT9HzAa
# EVUNeRwr+AIGZLAc1GI1GBMyMDIzMDcxOTAzNDc0Mi40MjRaMASAAgH0oIHQpIHN
# MIHKMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQL
# ExxNaWNyb3NvZnQgQW1lcmljYSBPcGVyYXRpb25zMSYwJAYDVQQLEx1UaGFsZXMg
# VFNTIEVTTjoxMkJDLUUzQUUtNzRFQjElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUt
# U3RhbXAgU2VydmljZaCCEVcwggcMMIIE9KADAgECAhMzAAAByk/Cs+0DDRhsAAEA
# AAHKMA0GCSqGSIb3DQEBCwUAMHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNo
# aW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29y
# cG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEw
# MB4XDTIyMTEwNDE5MDE0MFoXDTI0MDIwMjE5MDE0MFowgcoxCzAJBgNVBAYTAlVT
# MRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQK
# ExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJTAjBgNVBAsTHE1pY3Jvc29mdCBBbWVy
# aWNhIE9wZXJhdGlvbnMxJjAkBgNVBAsTHVRoYWxlcyBUU1MgRVNOOjEyQkMtRTNB
# RS03NEVCMSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNlMIIC
# IjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAwwGcq9j50rWEkcLSlGZLweUV
# fxXRaUjiPsyaNVxPdMRs3CVe58siu/EkaVt7t7PNTPko/s8lNtusAeLEnzki44yx
# k2c9ekm8E1SQ2YV9b8/LOxfKapZ8tVlPyxw6DmFzNFQjifVm8EiZ7lFRoY448vpc
# bBD18qjYNF/2Z3SQchcsdV1N9Y6V2WGl55VmLqFRX5+dptdjreBXzi3WW9TsoCEW
# cYCBK5wYgS9tT2SSSTzae3jmdw40g+LOIyrVPF2DozkStv6JBDPvwahXWpKGpO7r
# HrKF+o7ECN/ViQFMZyp/vxePiUABDNqzEUI8s7klYmeHXvjeQOq/CM3C/Y8bj3fJ
# ObnZH7eAXvRDnxT8R6W/uD1mGUJvv9M9BMu3nhKpKmSxzzO5LtcMEh2tMXxhMGGN
# MUP3DOEK3X+2/LD1Z03usJTk5pHNoH/gDIvbp787Cw40tsApiAvtrHYwub0TqIv8
# Zy62l8n8s/Mv/P764CTqrxcXzalBHh+Xy4XPjmadnPkZJycp3Kczbkg9QbvJp0H/
# 0FswHS+efFofpDNJwLh1hs/aMi1K/ozEv7/WLIPsDgK16fU/axybqMKk0NOxgelU
# jAYKl4wU0Y6Q4q9N/9PwAS0csifQhY1ooQfAI0iDCCSEATslD8bTO0tRtqdcIdav
# OReqzoPdvAv3Dr1XXQ8CAwEAAaOCATYwggEyMB0GA1UdDgQWBBT6x/6lS4ESQ8KZ
# hd0RgU7RYXM8fzAfBgNVHSMEGDAWgBSfpxVdAF5iXYP05dJlpxtTNRnpcjBfBgNV
# HR8EWDBWMFSgUqBQhk5odHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2Ny
# bC9NaWNyb3NvZnQlMjBUaW1lLVN0YW1wJTIwUENBJTIwMjAxMCgxKS5jcmwwbAYI
# KwYBBQUHAQEEYDBeMFwGCCsGAQUFBzAChlBodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20vcGtpb3BzL2NlcnRzL01pY3Jvc29mdCUyMFRpbWUtU3RhbXAlMjBQQ0ElMjAy
# MDEwKDEpLmNydDAMBgNVHRMBAf8EAjAAMBMGA1UdJQQMMAoGCCsGAQUFBwMIMA0G
# CSqGSIb3DQEBCwUAA4ICAQDY0HkqCS3KuKefFX8/rm/dtD9066dKEleNqriwZqsM
# 4Ym8Ew4QiqOqO7mWoYYY4K5y8eXSOHKNXOfpO6RbaYj8jCOcJAB5tqLl5hiMgaMb
# AVLrl1hlix9sloO45LON0JphKva3D6AVKA7P78mA9iRHZYUVrRiyfvQjWxmUnxhi
# s8fom92+/RHcEZ1Dh5+p4gzeeL84Yl00Wyq9EcgBKKfgq0lCjWNSq1AUG1sELlgX
# OSvKZ4/lXXH+MfhcHe91WLIaZkS/Hu9wdTT6I14BC97yhDsZWXAl0IJ801I6UtEF
# pCsTeOyZBJ7CF0rf5lxJ8tE9ojNsyqXJKuwVn0ewCMkZqz/cEwv9FEx8QmsZ0ZNo
# dTtsl+V9dZm+eUrMKZk6PKsKArtQ+jHkfVsHgKODloelpOmHqgX7UbO0NVnIlpP5
# 5gQTqV76vU7wRXpUfz7KhE3BZXNgwG05dRnCXDwrhhYz+Itbzs1K1R8I4YMDJjW9
# 0ASCg9Jf+xygRKZGKHjo2Bs2XyaKuN1P6FFCIVXN7KgHl/bZiakGq7k5TQ4OXK5x
# khCHhjdgHuxj3hK5AaOy+GXxO/jbyqGRqeSxf+TTPuWhDWurIo33RMDGe5DbImjc
# bcj6dVhQevqHClR1OHSfr+8m1hWRJGlC1atcOWKajArwOURqJSVlThwVgIyzGNmj
# zjCCB3EwggVZoAMCAQICEzMAAAAVxedrngKbSZkAAAAAABUwDQYJKoZIhvcNAQEL
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
# 0ZDxyKs6ijoIYn/ZcGNTTY3ugm2lBRDBcQZqELQdVTNYs6FwZvKhggLOMIICNwIB
# ATCB+KGB0KSBzTCByjELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24x
# EDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlv
# bjElMCMGA1UECxMcTWljcm9zb2Z0IEFtZXJpY2EgT3BlcmF0aW9uczEmMCQGA1UE
# CxMdVGhhbGVzIFRTUyBFU046MTJCQy1FM0FFLTc0RUIxJTAjBgNVBAMTHE1pY3Jv
# c29mdCBUaW1lLVN0YW1wIFNlcnZpY2WiIwoBATAHBgUrDgMCGgMVAKOO55cMT4sy
# PP6nClg2IWfajMqkoIGDMIGApH4wfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldh
# c2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBD
# b3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIw
# MTAwDQYJKoZIhvcNAQEFBQACBQDoYds0MCIYDzIwMjMwNzE5MTE0NzAwWhgPMjAy
# MzA3MjAxMTQ3MDBaMHcwPQYKKwYBBAGEWQoEATEvMC0wCgIFAOhh2zQCAQAwCgIB
# AAICZS4CAf8wBwIBAAICEcEwCgIFAOhjLLQCAQAwNgYKKwYBBAGEWQoEAjEoMCYw
# DAYKKwYBBAGEWQoDAqAKMAgCAQACAwehIKEKMAgCAQACAwGGoDANBgkqhkiG9w0B
# AQUFAAOBgQBXiTX7p7knBtU94gmXLL9kLRkpqqB+tJPQPxedVYjRQqHy3Gptovqw
# HZZBuYA4Eb/ZTMO2JwyuOYBq07W8PV4HZgZ68Dkw9HRawLNvK4SOT0yfnlUickdW
# cSZ8cc6USufEQ51/Iwe5uD8Ztsrm7lOCfdvfJYlN8x1aSSQVbI7/qDGCBA0wggQJ
# AgEBMIGTMHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYD
# VQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAk
# BgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwAhMzAAAByk/Cs+0D
# DRhsAAEAAAHKMA0GCWCGSAFlAwQCAQUAoIIBSjAaBgkqhkiG9w0BCQMxDQYLKoZI
# hvcNAQkQAQQwLwYJKoZIhvcNAQkEMSIEIIy1hbt+qsmo4zZS0atYWKXxj2D9RKrz
# R+LconidWlZoMIH6BgsqhkiG9w0BCRACLzGB6jCB5zCB5DCBvQQgEz0b85vrVU2s
# lZAk4jt1SDEk6IzZAwVCoWwF3KzcGuAwgZgwgYCkfjB8MQswCQYDVQQGEwJVUzET
# MBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMV
# TWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1T
# dGFtcCBQQ0EgMjAxMAITMwAAAcpPwrPtAw0YbAABAAAByjAiBCBPj3cTe+W1/vZt
# qo2hMEOC++X7BeJqNh2LEBIZTBuYSTANBgkqhkiG9w0BAQsFAASCAgCjIi4mISzq
# gbXudZNxIjnvD2qn6jwDma0d6mi3hu+5oitMOmpeIfRTvWReeBoKRljcEpgukrwU
# li4x/VvUE3Y6843B0bjs/HGixqhJQ4pa9SDfy4VUP+ryjIvhLn6vPtWwFw5Z9imt
# KBh+FF80XjkB1eihmlegGUIdgF5WQKf8f3dPC/tvX/sHDoO9h9NHwKaFFd8L49UE
# 9zC7Ko2AExXx8mJHxVsp3xz+8En0QY4qW/UjEEU8dpZbyRn3zVst7gl2NNZzEx7d
# Jm9HdyF5RdHrSFHxebkZiIE7r5cEhrETRl4v/u1S2aoh+5EuCOevLfDjMKnFXqmS
# iNjEo3tJ+kOnMNkR9d6iX5IDA5PQ3nSM2ia550NK0IaTW4ZJa/jzYGctXWVe3cvK
# PvCap/gJBFJWFd2MbS6q8fspB3JbDdPhOgUkpgjRrhWHM5skcWlYn/sDPtpu6ovZ
# Mtt9aRKDbf7ButZ+ZF/QYv7zP5xzU+H3KDjL4yIOwydS230nS+vCQx4Bkl35KnR/
# XgzrG3qoMpQuuXeOUxgyMIhhTNqIKhL+bdHyet984k5J11jYBKVd6ChbzsMbrhc7
# WtqsH5Ot6Ro0kZZizAqlLdFLWQYyTYulIimon48gcfDJmtYVJjzYyAhum78PGFWC
# K1worEEVjST9Icv7FNVXXdNbhR2ZpLZOkQ==
# SIG # End signature block
