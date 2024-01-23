---
external help file:
Module Name: Microsoft.Graph.Beta.Identity.SignIns
online version: https://learn.microsoft.com/powershell/module/microsoft.graph.beta.identity.signins/get-mgbetaidentitycontinuouaccessevaluationpolicy
schema: 2.0.0
---

# Get-MgBetaIdentityContinuouAccessEvaluationPolicy

## SYNOPSIS
Read the properties and relationships of a continuousAccessEvaluationPolicy object.

## SYNTAX

```
Get-MgBetaIdentityContinuouAccessEvaluationPolicy [-ExpandProperty <String[]>] [-Property <String[]>]
 [-CustomHeader <String>] [<CommonParameters>]
```

## DESCRIPTION
Read the properties and relationships of a continuousAccessEvaluationPolicy object.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```powershell
Import-Module Microsoft.Graph.Beta.Identity.SignIns
Get-MgBetaIdentityContinuouAccessEvaluationPolicy
```



## PARAMETERS

### -CustomHeader
CustomHeader Parameter.
This should have a key:value and comma separated for multiple key:value pairs

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ExpandProperty
Expand related entities

```yaml
Type: System.String[]
Parameter Sets: (All)
Aliases: Expand

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Property
Select properties to be returned

```yaml
Type: System.String[]
Parameter Sets: (All)
Aliases: Select

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### Microsoft.Graph.Beta.PowerShell.Models.IMicrosoftGraphContinuousAccessEvaluationPolicy

## NOTES

ALIASES

## RELATED LINKS

