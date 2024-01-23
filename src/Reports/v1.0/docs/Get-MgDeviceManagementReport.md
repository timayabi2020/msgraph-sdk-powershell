---
external help file:
Module Name: Microsoft.Graph.Reports
online version: https://learn.microsoft.com/powershell/module/microsoft.graph.reports/get-mgdevicemanagementreport
schema: 2.0.0
---

# Get-MgDeviceManagementReport

## SYNOPSIS
Read properties and relationships of the deviceManagementReports object.

## SYNTAX

```
Get-MgDeviceManagementReport [-ExpandProperty <String[]>] [-Property <String[]>] [-CustomHeader <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Read properties and relationships of the deviceManagementReports object.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```powershell
Import-Module Microsoft.Graph.Reports
```

Get-MgDeviceManagementReport

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

### Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDeviceManagementReports

## NOTES

ALIASES

## RELATED LINKS

