# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.
Param(
    $ModulesToGenerate = @(),
    [string] $ModuleMappingConfigPath = ("..\..\powershell_copy\msgraph-sdk-powershell\config\ModulesMapping.jsonc"),
	[string] $SDKDocsPath = ("..\..\powershell_copy\msgraph-sdk-powershell\src"),
	[string] $WorkLoadDocsPath = ("..\src"),
    [string] $Folder = "docs"
)
function Get-GraphMapping {
    $graphMapping = @{}
    #$graphMapping.Add("v1.0", "v1.0")
    $graphMapping.Add("v1.0-beta", "v1.0-beta")
    return $graphMapping
}

function Start-Copy {
    Param(
        $ModulesToGenerate = @()
    )
    
    $GraphMapping = Get-GraphMapping 
    $GraphMapping.Keys | ForEach-Object {
        $graphProfile = $_
        Get-FilesByProfile -GraphProfile $graphProfile -ModulesToGenerate $ModulesToGenerate 
    }
}
function Get-FilesByProfile{
    Param(
    [ValidateSet("v1.0-beta", "v1.0")]
    [string] $GraphProfile = "v1.0",
    [ValidateNotNullOrEmpty()]
    $ModulesToGenerate = @()
    )

    $ModulesToGenerate | ForEach-Object {
        $ModuleName = $_
        $docs = Join-Path $SDKDocsPath $ModuleName $ModuleName $Folder $GraphProfile
		Copy-Files -DocPath $docs -GraphProfile $GraphProfile -Module $ModuleName
    }
}
function Copy-Files{
    param(
        [ValidateSet("v1.0-beta", "v1.0")]
        [string] $GraphProfile = "v1.0",
        [ValidateNotNullOrEmpty()]
        [string] $Module = "Users",
		[ValidateNotNullOrEmpty()]
        [string] $DocPath = "..\..\src\Users\Users\$Folder\v1.0"
    )

     $destination = Join-Path $WorkLoadDocsPath $ModuleName $ModuleName $Folder $GraphProfile
	 $source = Join-Path $DocPath "\*" 
	if ((Test-Path $DocPath)) {
		 Write-Host -ForegroundColor DarkYellow "Copying markdown files from " $source " to " $destination
         Copy-Item $source -Destination $destination
	}
      
}
if (-not (Test-Path $ModuleMappingConfigPath)) {
    Write-Error "Module mapping file not be found: $ModuleMappingConfigPath."
}
if ($ModulesToGenerate.Count -eq 0) {
    [HashTable] $ModuleMapping = Get-Content $ModuleMappingConfigPath | ConvertFrom-Json -AsHashTable
    $ModulesToGenerate = $ModuleMapping.Keys
}
Write-Host -ForegroundColor Green "-------------Fetching docs and examples from dev-------------"
Start-Copy -ModulesToGenerate $ModulesToGenerate
Write-Host -ForegroundColor Green "-------------Done-------------"