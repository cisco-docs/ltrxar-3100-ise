# Authorization Exception Rule

*Location in GUI*:
`Work Centers` » `Device Administration` » `Device Admin Policy Sets` » `XXX` » `Authorization Policy - Local Exceptions`

{{ doc_gen }}

### Examples

Example-1 Authorization Exception Rule for DNAC Devices

This example defines an enabled authorization exception rule named "DNACException" within the "Global Policy" device administration policy set. The rule applies to devices identified by the attribute "DNAC" equal to "DNAC Devices" and assigns the "Default Shell Profile" as the authorization profile.

```yaml
ise:
  device_administration:
    policy_sets:
      - name: Global Policy
        description: Global policy
        state: enabled
        service_name: Default Network Access
        authorization_exception_rules:
          - name: DNACException
            state: enabled
            condition:
              type: ConditionAttributes
              dictionary_name: DEVICE
              attribute_name: DNAC
              operator: equals
              attribute_value: DNAC Devices
            profile: Default Shell Profile
```

Example-2 Authorization Exception Rule for User3 with DenyAllCommands

This example defines an enabled authorization exception rule named "User3" within the "Global Policy" device administration policy set. The rule applies to TACACS users where the User attribute equals "User3." It assigns the "Default Shell Profile" and restricts commands using the "DenyAllCommands" command set. The policy set is active with the service name "Default Network Access."

```yaml
ise:
  device_administration:
    policy_sets:
      - name: Global Policy
        description: Global policy
        state: enabled
        service_name: Default Network Access
        authorization_exception_rules:
          - name: User3
            state: enabled
            condition:
              type: ConditionAttributes
              is_negate: false
              dictionary_name: TACACS
              attribute_name: User
              operator: equals
              attribute_value: User3
            profile: Default Shell Profile
            command_sets:
              - DenyAllCommands
```