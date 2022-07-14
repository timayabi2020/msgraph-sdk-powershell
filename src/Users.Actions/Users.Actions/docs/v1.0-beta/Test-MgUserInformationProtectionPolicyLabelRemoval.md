---
external help file:
Module Name: Microsoft.Graph.Users.Actions
online version: https://docs.microsoft.com/en-us/powershell/module/microsoft.graph.users.actions/test-mguserinformationprotectionpolicylabelremoval
schema: 2.0.0
---

# Test-MgUserInformationProtectionPolicyLabelRemoval

## SYNOPSIS
Invoke action evaluateRemoval

## SYNTAX

### EvaluateExpanded (Default)
```
Test-MgUserInformationProtectionPolicyLabelRemoval -UserId <String> [-AdditionalProperties <Hashtable>]
 [-ContentInfo <IMicrosoftGraphContentInfo>] [-DowngradeJustification <IMicrosoftGraphDowngradeJustification>]
 [-Confirm] [-WhatIf] [<CommonParameters>]
```

### Evaluate
```
Test-MgUserInformationProtectionPolicyLabelRemoval -UserId <String>
 -BodyParameter <IPaths853H88UsersUserIdInformationprotectionPolicyLabelsMicrosoftGraphEvaluateremovalPostRequestbodyContentApplicationJsonSchema>
 [-Confirm] [-WhatIf] [<CommonParameters>]
```

### EvaluateViaIdentity
```
Test-MgUserInformationProtectionPolicyLabelRemoval -InputObject <IUsersActionsIdentity>
 -BodyParameter <IPaths853H88UsersUserIdInformationprotectionPolicyLabelsMicrosoftGraphEvaluateremovalPostRequestbodyContentApplicationJsonSchema>
 [-Confirm] [-WhatIf] [<CommonParameters>]
```

### EvaluateViaIdentityExpanded
```
Test-MgUserInformationProtectionPolicyLabelRemoval -InputObject <IUsersActionsIdentity>
 [-AdditionalProperties <Hashtable>] [-ContentInfo <IMicrosoftGraphContentInfo>]
 [-DowngradeJustification <IMicrosoftGraphDowngradeJustification>] [-Confirm] [-WhatIf] [<CommonParameters>]
```

## DESCRIPTION
Invoke action evaluateRemoval

## EXAMPLES

## PARAMETERS

### -AdditionalProperties
Additional Parameters

```yaml
Type: System.Collections.Hashtable
Parameter Sets: EvaluateExpanded, EvaluateViaIdentityExpanded
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BodyParameter
.
To construct, please use Get-Help -Online and see NOTES section for BODYPARAMETER properties and create a hash table.

```yaml
Type: Microsoft.Graph.PowerShell.Models.IPaths853H88UsersUserIdInformationprotectionPolicyLabelsMicrosoftGraphEvaluateremovalPostRequestbodyContentApplicationJsonSchema
Parameter Sets: Evaluate, EvaluateViaIdentity
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ContentInfo
contentInfo
To construct, please use Get-Help -Online and see NOTES section for CONTENTINFO properties and create a hash table.

```yaml
Type: Microsoft.Graph.PowerShell.Models.IMicrosoftGraphContentInfo
Parameter Sets: EvaluateExpanded, EvaluateViaIdentityExpanded
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DowngradeJustification
downgradeJustification
To construct, please use Get-Help -Online and see NOTES section for DOWNGRADEJUSTIFICATION properties and create a hash table.

```yaml
Type: Microsoft.Graph.PowerShell.Models.IMicrosoftGraphDowngradeJustification
Parameter Sets: EvaluateExpanded, EvaluateViaIdentityExpanded
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputObject
Identity Parameter
To construct, please use Get-Help -Online and see NOTES section for INPUTOBJECT properties and create a hash table.

```yaml
Type: Microsoft.Graph.PowerShell.Models.IUsersActionsIdentity
Parameter Sets: EvaluateViaIdentity, EvaluateViaIdentityExpanded
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -UserId
key: id of user

```yaml
Type: System.String
Parameter Sets: Evaluate, EvaluateExpanded
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Microsoft.Graph.PowerShell.Models.IPaths853H88UsersUserIdInformationprotectionPolicyLabelsMicrosoftGraphEvaluateremovalPostRequestbodyContentApplicationJsonSchema

### Microsoft.Graph.PowerShell.Models.IUsersActionsIdentity

## OUTPUTS

### Microsoft.Graph.PowerShell.Models.IMicrosoftGraphInformationProtectionAction

## NOTES

ALIASES

COMPLEX PARAMETER PROPERTIES

To create the parameters described below, construct a hash table containing the appropriate properties. For information on hash tables, run Get-Help about_Hash_Tables.


BODYPARAMETER <IPaths853H88UsersUserIdInformationprotectionPolicyLabelsMicrosoftGraphEvaluateremovalPostRequestbodyContentApplicationJsonSchema>: .
  - `[(Any) <Object>]`: This indicates any property can be added to this object.
  - `[ContentInfo <IMicrosoftGraphContentInfo>]`: contentInfo
    - `[(Any) <Object>]`: This indicates any property can be added to this object.
    - `[Format <String>]`: contentFormat
    - `[Identifier <String>]`: Identifier used for Azure Information Protection Analytics.
    - `[Metadata <IMicrosoftGraphKeyValuePair[]>]`: Existing Microsoft Purview Information Protection metadata is passed as key/value pairs, where the key is the MSIP_Label_GUID_PropName.
      - `[Name <String>]`: Name for this key-value pair. Possible names are: AdditionalWSFedEndpointCheckResult,  AllowedAuthenticationClassReferencesCheckResult, AlwaysRequireAuthenticationCheckResult,   AutoUpdateEnabledCheckResult, ClaimsProviderNameCheckResult, EncryptClaimsCheckResult,  EncryptedNameIdRequiredCheckResult, MonitoringEnabledCheckResult,NotBeforeSkewCheckResult,  RequestMFAFromClaimsProvidersCheckResult, SignedSamlRequestsRequiredCheckResult, AdditionalAuthenticationRulesCheckResult, TokenLifetimeCheckResult,  DelegationAuthorizationRulesCheckResult, IssuanceAuthorizationRulesCheckResult, IssuanceTransformRulesCheckResult.
      - `[Value <String>]`: Value for this key-value pair. Possible result values are 0 (when the validation check passed), 1 (when the validation check failed), or 2 (when the validation check is a warning).
    - `[State <String>]`: contentState
  - `[DowngradeJustification <IMicrosoftGraphDowngradeJustification>]`: downgradeJustification
    - `[(Any) <Object>]`: This indicates any property can be added to this object.
    - `[IsDowngradeJustified <Boolean?>]`: Indicates whether the downgrade is or is not justified.
    - `[JustificationMessage <String>]`: Message that indicates why a downgrade is justified. The message will appear in administrative logs.

CONTENTINFO <IMicrosoftGraphContentInfo>: contentInfo
  - `[(Any) <Object>]`: This indicates any property can be added to this object.
  - `[Format <String>]`: contentFormat
  - `[Identifier <String>]`: Identifier used for Azure Information Protection Analytics.
  - `[Metadata <IMicrosoftGraphKeyValuePair[]>]`: Existing Microsoft Purview Information Protection metadata is passed as key/value pairs, where the key is the MSIP_Label_GUID_PropName.
    - `[Name <String>]`: Name for this key-value pair. Possible names are: AdditionalWSFedEndpointCheckResult,  AllowedAuthenticationClassReferencesCheckResult, AlwaysRequireAuthenticationCheckResult,   AutoUpdateEnabledCheckResult, ClaimsProviderNameCheckResult, EncryptClaimsCheckResult,  EncryptedNameIdRequiredCheckResult, MonitoringEnabledCheckResult,NotBeforeSkewCheckResult,  RequestMFAFromClaimsProvidersCheckResult, SignedSamlRequestsRequiredCheckResult, AdditionalAuthenticationRulesCheckResult, TokenLifetimeCheckResult,  DelegationAuthorizationRulesCheckResult, IssuanceAuthorizationRulesCheckResult, IssuanceTransformRulesCheckResult.
    - `[Value <String>]`: Value for this key-value pair. Possible result values are 0 (when the validation check passed), 1 (when the validation check failed), or 2 (when the validation check is a warning).
  - `[State <String>]`: contentState

DOWNGRADEJUSTIFICATION <IMicrosoftGraphDowngradeJustification>: downgradeJustification
  - `[(Any) <Object>]`: This indicates any property can be added to this object.
  - `[IsDowngradeJustified <Boolean?>]`: Indicates whether the downgrade is or is not justified.
  - `[JustificationMessage <String>]`: Message that indicates why a downgrade is justified. The message will appear in administrative logs.

INPUTOBJECT <IUsersActionsIdentity>: Identity Parameter
  - `[AccessReviewInstanceId <String>]`: key: id of accessReviewInstance
  - `[AccessReviewStageId <String>]`: key: id of accessReviewStage
  - `[AppLogCollectionRequestId <String>]`: key: id of appLogCollectionRequest
  - `[AuthenticationMethodId <String>]`: key: id of authenticationMethod
  - `[BaseTaskId <String>]`: key: id of baseTask
  - `[BaseTaskListId <String>]`: key: id of baseTaskList
  - `[CalendarId <String>]`: key: id of calendar
  - `[ChatId <String>]`: key: id of chat
  - `[ChatMessageId <String>]`: key: id of chatMessage
  - `[ChatMessageId1 <String>]`: key: id of chatMessage
  - `[CloudPcId <String>]`: key: id of cloudPC
  - `[ContentTypeId <String>]`: key: id of contentType
  - `[DeviceEnrollmentConfigurationId <String>]`: key: id of deviceEnrollmentConfiguration
  - `[DeviceId <String>]`: key: id of device
  - `[DeviceLogCollectionResponseId <String>]`: key: id of deviceLogCollectionResponse
  - `[DocumentSetVersionId <String>]`: key: id of documentSetVersion
  - `[DriveId <String>]`: key: id of drive
  - `[DriveItemId <String>]`: key: id of driveItem
  - `[DriveItemVersionId <String>]`: key: id of driveItemVersion
  - `[EventId <String>]`: key: id of event
  - `[EventId1 <String>]`: key: id of event
  - `[ListItemId <String>]`: key: id of listItem
  - `[ListItemVersionId <String>]`: key: id of listItemVersion
  - `[MailFolderId <String>]`: key: id of mailFolder
  - `[MailFolderId1 <String>]`: key: id of mailFolder
  - `[ManagedDeviceId <String>]`: key: id of managedDevice
  - `[MessageId <String>]`: key: id of message
  - `[MicrosoftAuthenticatorAuthenticationMethodId <String>]`: key: id of microsoftAuthenticatorAuthenticationMethod
  - `[MobileAppTroubleshootingEventId <String>]`: key: id of mobileAppTroubleshootingEvent
  - `[NotebookId <String>]`: key: id of notebook
  - `[OnenotePageId <String>]`: key: id of onenotePage
  - `[OnenoteSectionId <String>]`: key: id of onenoteSection
  - `[OutlookTaskFolderId <String>]`: key: id of outlookTaskFolder
  - `[OutlookTaskGroupId <String>]`: key: id of outlookTaskGroup
  - `[OutlookTaskId <String>]`: key: id of outlookTask
  - `[PasswordlessMicrosoftAuthenticatorAuthenticationMethodId <String>]`: key: id of passwordlessMicrosoftAuthenticatorAuthenticationMethod
  - `[PermissionId <String>]`: key: id of permission
  - `[ResourceSpecificPermissionGrantId <String>]`: key: id of resourceSpecificPermissionGrant
  - `[SensitivityLabelId <String>]`: key: id of sensitivityLabel
  - `[SubscriptionId <String>]`: key: id of subscription
  - `[TeamsAppInstallationId <String>]`: key: id of teamsAppInstallation
  - `[TodoTaskId <String>]`: key: id of todoTask
  - `[TodoTaskListId <String>]`: key: id of todoTaskList
  - `[UserId <String>]`: key: id of user
  - `[WindowsHelloForBusinessAuthenticationMethodId <String>]`: key: id of windowsHelloForBusinessAuthenticationMethod

## RELATED LINKS
