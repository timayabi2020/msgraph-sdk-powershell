class MetaDataFields
{
    [string] $Command
    [string] $Uri
}

class Root
{
   [System.Collections.Generic.List[MetaDataFields]] $MetaData
}



[System.Collections.Generic.HashSet [string]]$SDKList= @()
[System.Collections.Generic.HashSet [string]]$MissingList= @()



function ReviewCoverage{
$BetaOpenAPIPath = "C:\Projects\msgraph-metadata\openapi\beta\openapi.yaml";
$SupportedFileTypes = ".md"
#$BetaOpenAPIPath = (Join-Path $PSScriptRoot "../openApiDocs/beta/Applications.yml")
$MetaDataJsonFile = (Join-Path $PSScriptRoot "../src/Authentication/Authentication/custom/common/MgCommandMetadata.json") 
#$content = ([System.Web.Script.Serialization.JavaScriptSerializer]::new()).Deserialize($MetaDataJsonFile, [Root])
$JsonContent = Get-Content -Path $MetaDataJsonFile
$DeserializedContent = $JsonContent | ConvertFrom-Json
foreach($Data in $DeserializedContent)
{
    if($Data.ApiVersion -eq "beta")
    {
        #Write-Host $Data.Command
        $a = $SDKList.Add($Data.Uri)
    }
    
}

if (Test-Path $BetaOpenAPIPath) {
    $YamlContent = Get-Content -Path $BetaOpenAPIPath
    $OpenApiContent = ($YamlContent | ConvertFrom-Yaml)
    Extract-UriPath -OpenApiContent $OpenApiContent 
}
Write-Host $MissingList.Count " SDK " $SDKList.Count
}
function Extract-UriPath{
    param (
        [Hashtable] $OpenApiContent
    )
    Write-Host "Here doing what it does"
    if ($OpenApiContent.openapi -and $OpenApiContent.info.version) {
        foreach ($Path in $OpenApiContent.paths) {
           foreach($key in $Path.Keys){
            $key = $key.Replace("microsoft.graph.","")
            $key = $key.Replace("()","")
            if(-not ($SDKList.Contains($key))){
                $b = $MissingList.Add($key)
            }
            
           }
        }
    }
}

if (!(Get-Module "powershell-yaml" -ListAvailable -ErrorAction SilentlyContinue)) {
    Write-Host "Here installing powershell yaml"
    Install-Module "powershell-yaml" -AcceptLicense -Scope CurrentUser -Force
}
ReviewCoverage