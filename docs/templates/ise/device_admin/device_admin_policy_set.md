# Policy Set

*Location in GUI*:
`Work Centers` » `Device Administration` » `Device Admin Policy Sets`

{{ doc_gen }}

### Examples

Example-1 Adding a new Policy Set

This example defines a global device administration policy set within Cisco ISE. It creates a policy named "Global Policy" that is enabled. The policy applies to all devices where the "Location" attribute in the "DEVICE" dictionary equals "All Locations," effectively targeting all device locations. The policy uses the "Device Profile 1" profile to govern device administration access and authorization for matching devices.

```yaml
ise:
  device_administration:
    policy_sets:
      - name: Global Policy
        description: Global policy
        state: enabled
        is_proxy: false
        condition:
          type: ConditionAttributes
          is_negate: false
          dictionary_name: DEVICE
          attribute_name: Location
          operator: equals
          attribute_value: All Locations
        service_name: Device Profile 1
```
Example-2 Adding Multiple Policy Sets

This example demonstrates how to configure multiple device administration policy sets within a single configuration. Each policy set has distinct criteria and applies different device administration services. The first policy set, "Global Policy," targets all device locations and applies "Device Profile 1." The second policy set, "User 1 Policy," specifically controls access for a user named "User 1" based on the "UserName" attribute in the Network Access dictionary, applying "Device Profile 2." This approach allows granular control over device administration policies by defining multiple sets with different conditions and services.

```yaml
ise:
  device_administration:
    policy_sets:
      - name: Global Policy
        description: Global policy
        state: enabled
        is_proxy: false
        condition:
          type: ConditionAttributes
          is_negate: false
          dictionary_name: DEVICE
          attribute_name: Location
          operator: equals
          attribute_value: All Locations
        service_name: Device Profile 1
      - name: User 1 Policy
        description: Policy Set to control User 1 access
        state: enabled
        is_proxy: false
        condition:
          type: ConditionAttributes
          is_negate: false
          dictionary_name: Network Access
          attribute_name: UserName
          operator: equals
          attribute_value: User 1
        service_name: Device Profile 2
```