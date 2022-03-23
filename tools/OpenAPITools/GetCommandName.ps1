function Get-CommandMetadata {
    [CmdletBinding(DefaultParameterSetName = 'FromDirectory')]
    param (
        # ParameterSet - FromDirectory
        [Parameter(ParameterSetName = 'FromDirectory')]
        [ValidateNotNullOrEmpty()]
        [string]
        $OpenApiFilesPath = (Join-Path $PsScriptRoot '..\..\openApiDocs'),

        # ParameterSet - FromFile
        [Parameter(Mandatory = $true, ParameterSetName = 'FromFile')]
        [ValidateNotNullOrEmpty()]
        [string]
        $OpenApiFilePath,

        [Parameter(ParameterSetName = 'FromDirectory')]
        [Parameter(ParameterSetName = 'FromFile')]
        [ValidateNotNullOrEmpty()]
        [string]
        $OutputPath = (Join-Path $PsScriptRoot '..\..\openApiDocs\CommandNames')
    )

    # Install dependencies.
    if (!(Get-Module "powershell-yaml" -ListAvailable -ErrorAction SilentlyContinue)) {
        Install-Module "powershell-yaml" -AcceptLicense -Scope CurrentUser -Force
    }
    if (!(Get-Module "PowerShellHumanizer" -ListAvailable -ErrorAction SilentlyContinue)) {
        Install-Module "PowerShellHumanizer" -AcceptLicense -Scope CurrentUser -Force
    }
    Import-Module "PowerShellHumanizer"

    if (!(Test-Path -Path $OutputPath)) {
        New-Item -Path $OutputPath -ItemType Directory
    }

    if ($PSCmdlet.ParameterSetName -eq 'FromDirectory') {
        if (!(Test-Path -Path $OpenApiFilesPath)) {
            Write-Error "OpenApiFilesPath does not exist".
        }

        foreach ($api in (Get-ChildItem -Path $OpenApiFilesPath)) {
            Write-Debug "Parsing $($api.Name) openAPI files..."
            $OpenApiFiles = (Get-ChildItem -Path $api.FullName -Recurse -File -Include '*.yml')
            foreach ($openApiDoc in $openApiDocs) {
                # TODO: fill in.
            }
        }
    }
    else {
        if (!(Test-Path -Path $OpenApiFilePath)) {
            Write-Error "OpenApiFilePath does not exist".
        }

        $Commands = [System.Collections.SortedList]::new()
        $FileContent = Get-Content -Path $OpenApiFilePath | ConvertFrom-Yaml
        foreach ($path in $FileContent.paths.keys) {
            foreach ($operationName in $FileContent.paths.$path.keys) {
                $CommandMetadata = @{}
                $CommandMetadata.Path = $path
                $Operation = $FileContent.paths.$path.$operationName
                $CommandMetadata.Verb = Get-PSVerb -Verb $operationName
                $Tags = $Operation.tags.split(".")
                $CommandMetadata.TypeName = $Tags[$Tags.count - 1]
                foreach ($pathParameter in $Operation.parameters) {
                    if ($pathParameter.in -eq 'path') {
                        $CommandMetadata.PathParameters += @($pathParameter.name.Replace("-", ""))
                    }
                    elseif ($pathParameter.in -eq 'query') {
                        $CommandMetadata.QueryParameters += @($pathParameter.name.Replace("-", ""))
                    }
                    #TODO: Expand on other 'in' values.
                }
                $LastSegment = $CommandMetadata.TypeName
                $PathSegments = $CommandMetadata.Path.Trim("/").Split('/')
                if ($PathSegments.count -gt 0) {
                    $LastSegment = $PathSegments[$PathSegments.count - 1]
                    if ($LastSegment.StartsWith("{")) {
                        $LastSegment = $PathSegments[$PathSegments.count - 2]
                    }
                    elseif ($LastSegment.StartsWith("`$value")) {
                        if (($PathSegments[$PathSegments.count - 2]).StartsWith("{")) {
                            $LastSegment = "$($PathSegments[$PathSegments.count - 3])Value"
                        }
                        else {
                            $LastSegment = "$($PathSegments[$PathSegments.count - 2])Value"
                        }
                    }
                    elseif ($LastSegment.StartsWith("`$ref")) {
                        $LastSegment = "$($PathSegments[$PathSegments.count - 2])ByRef"
                    }
                }
                $PathParameterStr = ""
                $CommandMetadata.Name = $CommandMetadata.Verb + '-' + (Invoke-SingularizeNoun -Noun $LastSegment)
                if ($CommandMetadata.PathParameters) {
                    $CommandMetadata.PathParameters | ForEach-Object { $PathParameterStr += " -$_" }
                    $PathParameterStr = $PathParameterStr.Trim()
                }
                else {
                    $PathParameterStr = " "
                }
                $CommandKey = $CommandMetadata.Name
                if ($Commands.Contains($CommandKey)) {
                    if ($Commands[$CommandKey].ParameterSets.Contains($PathParameterStr)){
                        $Commands[$CommandKey].ParameterSets.$PathParameterStr += $CommandMetadata.Path
                    }
                    else{
                        $Commands[$CommandKey].ParameterSets.Add($PathParameterStr, @($CommandMetadata.Path))
                    }
                }
                else {
                    $Commands.Add($CommandKey, @{
                            ParameterSets = @{ $PathParameterStr = @($CommandMetadata.Path) }
                            TypeName      = $CommandMetadata.TypeName
                        })
                }
            }
        }
        Set-Content -Path (Join-Path $OutputPath "v1.0-mail.json") -Value ($Commands | ConvertTo-Json -Depth 3)
        Write-Host "Done: $($Commands.count)"
    }
}

function Get-PSVerb {
    param (
        [ValidateNotNullOrEmpty()]
        [string]
        $Verb
    )

    switch ($Verb.ToLower()) {
        "get" { return "Get" }
        "put" { return "Set" }
        "post" { return "New" }
        "delete" { return "Remove" }
        "patch" { return "Update" }
    }
}

function Invoke-SingularizeNoun{
    param (
        [ValidateNotNullOrEmpty()]
        [string]
        $Noun
    )
    $NameSegments = $Noun.Humanize().Split(" ")
    $SingularizedNoun = ""
    $NameSegments | ForEach-Object {
        $SingleName = $_ | ConvertTo-Singular
        if ($SingleName){
            $SingularizedNoun += $SingleName
        } else{
            $SingularizedNoun += $_
        }
    }
    return $SingularizedNoun
}

Get-CommandMetadata -OpenApiFilePath "D:\M\msgraph-sdk-powershell\openApiDocs\v1.0\mail.yml"