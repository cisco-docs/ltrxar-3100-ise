# Authorization Global Exception Rule

*Location in GUI*:
`Work Centers` » `Device Administration` » `Device Admin Policy Sets` » `XXX` » `Authorization Policy - Global Exceptions`

{{ doc_gen }}

### Examples

Example-1 Global Authorization Exception Rule for User2 Denying All Commands

This example defines a global authorization exception rule in the device administration policy for User2. When the condition matches User2 in the TACACS dictionary, the rule is enabled and applies the command set "DenyAllCommands," effectively denying all commands for this user. This configuration enforces strict command restrictions globally for User2 across the network device administration environment.

```yaml
ise:
  device_administration:
    authorization_global_exception_rules:
      - name: User2
        default: false
        state: enabled
        condition:
          type: ConditionAttributes
          is_negate: false
          dictionary_name: TACACS
          attribute_name: User
          operator: equals
          attribute_value: User2
        command_sets:
          - DenyAllCommands
```

Example-2 Global Authorization Exception Rule with Multiple Identity Group Conditions Using AND Operator

This example illustrates a global authorization exception rule in device administration that requires two identity group conditions to be met simultaneously using an AND operator. The rule applies when the user belongs to both the "GuestEndpoints" and "Employee" identity groups. When both conditions match, the rule is enabled and applies the "AllowShowCommands" command set, permitting only show commands for users who satisfy both identity group memberships.

```yaml
ise:
  device_administration:
    authorization_global_exception_rules:
      - name: OnlyShowCommands
        state: enabled
        condition:
          type: ConditionAndBlock
          children:
            - type: ConditionAttributes
              is_negate: false
              dictionary_name: IdentityGroup
              attribute_name: Name
              operator: equals
              attribute_value: GuestEndpoints
            - type: ConditionAttributes
              is_negate: false
              dictionary_name: IdentityGroup
              attribute_name: Name
              operator: equals
              attribute_value: Employee
        command_sets:
          - AllowShowCommands
```