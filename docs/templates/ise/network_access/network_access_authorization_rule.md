# Authorization Rule

*Location in GUI*:
`Work Centers` » `Network Access` » `Policy Sets` » `XXX` » `Authorization Policy`

{{ doc_gen }}

### Examples

Example-1: Office_Clients authorization rule

This example demonstrates how to configure an authorization rule under the policy_set `Global Policy`. The authorization rule name is `Office_Clients`. It uses the AD Join Point `AD_Join` to query the endpoint, and if the endpoint is part of the AD group `ciscolab.local/Users/DC1`, then the authorization profile `Office_Clients_Profile` and the security group `Office_Clients_SGT` are applied.

```yaml
ise:
  network_access:
    policy_sets:
      - name: Global Policy
        authorization_rules:
          - name: Office_Clients
            state: enabled
            condition:
              type: ConditionAttributes
              dictionary_name: AD_Join
              attribute_name: ExternalGroups
              operator: equals
              attribute_value: ciscolab.local/Users/DC1
            profiles:
              - Office_Clients_Profile
            security_group: Office_Clients_SGT
```

Example-2 Network Access Authorization Rule with Attribute Condition for Endpoint Identity Group

This example demonstrates a Cisco ISE network access authorization rule within a policy set for wired connections. The authorization rule "CorporateDevicesFullAccess" is enabled and uses a simple attribute-based condition to evaluate endpoint identity group membership. The condition checks if the authenticating endpoint belongs to "Endpoint Identity Groups:RegisteredDevices" using an exact equals operator match. When the condition is satisfied, the rule applies the "PermitAccess" authorization profile to grant network access.

```yaml
ise:
  network_access:
    policy_sets:
      - name: CorporateWiredPolicy
        service_name: Default Network Access
        authorization_rules:
          - name: CorporateDevicesFullAccess
            state: enabled
            condition:
              type: ConditionAttributes
              dictionary_name: IdentityGroup
              attribute_name: Name
              operator: equals
              attribute_value: Endpoint Identity Groups:RegisteredDevices
            profiles:
              - PermitAccess
```

Example-3 Network Access Authorization Rule with OR Condition for User Identity Groups

This example demonstrates a Cisco ISE network access authorization rule using OR logic to match multiple user identity groups for flexible access control. The authorization rule "Employees_or_Managers_Standard_Access" is enabled and evaluates three alternative user identity group conditions using a ConditionOrBlock: "User Identity Groups:Employees", "User Identity Groups:Managers", and "User Identity Groups:IT_Staff". When any of these conditions match, the rule applies two authorization profiles—"PermitAccess" for network access and "InternetAccess" for connectivity—and assigns the "TrustSec_Employees" security group tag for TrustSec policy enforcement. This configuration represents a common corporate authorization pattern where multiple user roles receive the same network permissions through a single rule with OR logic, simplifying policy management while maintaining appropriate access control and security group tagging.

```yaml
ise:
  network_access:
    policy_sets:
      - name: CorporateWiredPolicy
        service_name: Default Network Access
        authorization_rules:
          - name: Employees_or_Managers_Standard_Access
            state: enabled
            condition:
              type: ConditionOrBlock
              children:
                - type: ConditionAttributes
                  dictionary_name: IdentityGroup
                  attribute_name: Name
                  operator: equals
                  attribute_value: User Identity Groups:Employees
                - type: ConditionAttributes
                  dictionary_name: IdentityGroup
                  attribute_name: Name
                  operator: equals
                  attribute_value: User Identity Groups:Managers
                - type: ConditionAttributes
                  dictionary_name: IdentityGroup
                  attribute_name: Name
                  operator: equals
                  attribute_value: User Identity Groups:IT_Staff
            profiles:
              - PermitAccess
              - InternetAccess
            security_group: TrustSec_Employees

```
