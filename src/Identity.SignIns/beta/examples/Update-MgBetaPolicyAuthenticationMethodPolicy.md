### Example 1: Code snippet

```powershellImport-Module Microsoft.Graph.Beta.Identity.SignIns

$params = @{
	registrationEnforcement = @{
		authenticationMethodsRegistrationCampaign = @{
			snoozeDurationInDays = 1
			state = "enabled"
			excludeTargets = @(
			)
			includeTargets = @(
				@{
					id = "3ee3a9de-0a86-4e12-a287-9769accf1ba2"
					targetType = "group"
					targetedAuthenticationMethod = "microsoftAuthenticator"
				}
			)
		}
	}
	reportSuspiciousActivitySettings = @{
		state = "enabled"
		includeTarget = @{
			targetType = "group"
			id = "all_users"
		}
		voiceReportingCode = 0
	}
}

Update-MgBetaPolicyAuthenticationMethodPolicy -BodyParameter $params
```
This example shows how to use the Update-MgBetaPolicyAuthenticationMethodPolicy Cmdlet.
To learn about permissions for this resource, see the [permissions reference](/graph/permissions-reference).

