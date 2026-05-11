# Authorization Rule

*Location in GUI*:
`Work Centers` » `Device Administration` » `Device Admin Policy Sets` » `XXX` » `Authorization Policy`

{{ doc_gen }}

### Examples

Example-1 Authorization Rule Allowing User1 with Show Command Access

This example defines an authorization rule within the Global Policy of device administration that specifically allows a user named "User1" to access the network device. The rule is enabled and matches when the TACACS user attribute equals "User1." Upon matching, the user is assigned the "Default Shell Profile" and granted the command set "AllowShowCommands," which permits execution of show commands. This configuration is useful for granting limited read-only access to specific users in the device administration policy framework.

```yaml
ise:
  device_administration:
    policy_sets:
      - name: Global Policy
        authorization_rules:
          - name: AllowingUser1
            state: enabled
            condition:
              type: ConditionAttributes
              is_negate: false
              dictionary_name: TACACS
              attribute_name: User
              operator: equals
              attribute_value: User1
            profile: Default Shell Profile
            command_sets:
              - AllowShowCommands
```

Example-2 Device Administration Authorization Rule with OR Condition for Identity Groups

This example demonstrates how an authorization rule in Cisco ISE device administration uses an OR operator to evaluate multiple identity group conditions. The authorization is granted if the user belongs to either the "Employee" or "RegisteredDevices" identity groups. When the condition matches, the user receives the "Default Shell Profile" and is allowed to execute show commands. This setup enables the policy to authorize access flexibly by satisfying any one of the specified identity group conditions, rather than requiring all conditions to be met.

```yaml
ise:
  device_administration:
    policy_sets:
      - name: Global Policy
        authorization_rules:
          - name: AuthorizationGroup
            state: enabled
            condition:
              type: ConditionOrBlock
              children:
                - type: ConditionAttributes
                  is_negate: false
                  dictionary_name: IdentityGroup
                  attribute_name: Name
                  operator: equals
                  attribute_value: Employee
                - type: ConditionAttributes
                  is_negate: false
                  dictionary_name: IdentityGroup
                  attribute_name: Name
                  operator: equals
                  attribute_value: RegisteredDevices
            profile: Default Shell Profile
            command_sets:
              - AllowShowCommands 
```
