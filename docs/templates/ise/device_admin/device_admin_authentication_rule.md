# Authentication Rule

*Location in GUI*:
`Work Centers` » `Device Administration` » `Device Admin Policy Sets` » `XXX` » `Authentication Policy`

{{ doc_gen }}

### Examples

Example-1 Global Policy with an Authentication Rule

This example shows how to associate an authentication rule named "PrimaryAuthentication" within a device administration policy set. The rule is enabled and applies to devices located in "All Locations." The authentication rule uses the identity source "Internal Users" and specifies failure handling actions: reject on authentication failure, continue if the user is not found, and drop if the authentication process fails.

```yaml
ise:
  device_administration:
    policy_sets:
      - name: Global Policy
        description: Global policy
        state: enabled
        service_name: Default Network Access
        authentication_rules:
          - name: PrimaryAuthentication
            state: enabled
            condition:
              type: ConditionAttributes
              dictionary_name: DEVICE
              attribute_name: Location
              operator: equals
              attribute_value: All Locations
            identity_source_name: Internal Users
            if_auth_fail: REJECT
            if_user_not_found: CONTINUE
            if_process_fail: DROP
```
Example-2 Multiple Authentication Rules

The example defines a global device administration policy with two authentication rules. The PrimaryAuthentication rule is enabled, applies to devices located in "All Locations," uses the "Internal Users" identity source, and specifies failure actions: reject on authentication failure, continue if the user is not found, and drop if the process fails. The SecondaryAuthentication rule is in monitor state, applies to the user "User1" from the "Guest Users" identity source, and handles failures by continuing on authentication fail, rejecting if the user is not found, and continuing on process fail.

```yaml
ise:
  device_administration:
    policy_sets:
      - name: Global Policy
        description: Global policy
        state: enabled
        service_name: Default Network Access
        authentication_rules:
          - name: PrimaryAuthentication
            state: enabled
            condition:
              type: ConditionAttributes
              dictionary_name: DEVICE
              attribute_name: Location
              operator: equals
              attribute_value: All Locations
            identity_source_name: Internal Users
            if_auth_fail: REJECT
            if_user_not_found: CONTINUE
            if_process_fail: DROP
          - name: SecondaryAuthentication
            state: monitor
            condition:
              type: ConditionAttributes
              dictionary_name: Network Access
              attribute_name: UserName
              operator: equals
              attribute_value: User1
            identity_source_name: Guest Users
            if_auth_fail: CONTINUE
            if_user_not_found: REJECT
            if_process_fail: CONTINUE
```
Example-3 Multi-Condition Authentication Rule with AND Operator in Device Administration

This example illustrates the configuration of an authentication rule within Cisco ISE device administration that requires multiple conditions to be met simultaneously using an AND operator. The rule, named "MultiConditionAuthRule," is enabled under the Global Policy and applies to the Default Network Access service. It specifies a condition block of type ConditionAndBlock with two child conditions: one matching the user name "User1" in the Network Access dictionary, and the other matching the device location "All Locations" in the DEVICE dictionary. The identity source is set to "Internal Users," and the rule enforces rejection if authentication fails, the user is not found, or the process fails. This configuration ensures that authentication is granted only when both user identity and device location criteria are satisfied.

```yaml
ise:
  device_administration:
    policy_sets:
      - name: Global Policy
        description: Global policy
        state: enabled
        service_name: Default Network Access
        authentication_rules:
          - name: MultiConditionAuthRule
            state: enabled
            condition:
              type: ConditionAndBlock
              children:
                - type: ConditionAttributes
                  is_negate: false
                  dictionary_name: Network Access
                  attribute_name: UserName
                  operator: equals
                  attribute_value: User1
                - type: ConditionAttributes
                  is_negate: false
                  dictionary_name: DEVICE
                  attribute_name: Location
                  operator: equals
                  attribute_value: All Locations
            identity_source_name: Internal Users
            if_auth_fail: REJECT
            if_user_not_found: REJECT
            if_process_fail: REJECT
```

