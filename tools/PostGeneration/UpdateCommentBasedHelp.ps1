# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

Param(
    $Modules = @(),
    [string] $ModuleMappingConfigPath = (Join-Path $PSScriptRoot "..\..\config\ModulesMapping.jsonc")
)

if ($Modules.Count -eq 0) {
    if (-not (Test-Path $ModuleMappingConfigPath)) {
        Write-Error "Module mapping file not be found: $ModuleMappingConfigPath."
    }

    [HashTable] $ModuleMapping = Get-Content $ModuleMappingConfigPath | ConvertFrom-Json -AsHashTable
    $Modules = $ModuleMapping.Keys
}

$RegexPattern = "(?s)(?<=\.Notes)(.+?)(?=\.Link)"
$Modules | ForEach-Object {
    $ModuleExportsDir = Join-Path $PSScriptRoot "..\..\src\" "$_\$_\exports"

    Get-ChildItem -Path $ModuleExportsDir -Filter "ProxyCmdletDefinitions.ps1" -Recurse | ForEach-Object {
        $ProxyCmdletContent = Get-Content -Path $_ -Raw
        $NewProxyCmdletContent = $ProxyCmdletContent -Replace $RegexPattern, "`nPlease use Get-Help -Online.`n"
        Set-Content -Path $_ -Value $NewProxyCmdletContent
    }
}