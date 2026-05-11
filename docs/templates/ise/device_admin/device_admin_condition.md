# Condition

*Location in GUI*:
`Work Centers` » `Device Administration` » `Policy Elements` » `Conditions` » `Library Conditions`

{{ doc_gen }}

### Examples

Example-1 Defining a Policy Element Condition

This example illustrates how to define a policy element condition within device administration by specifying a condition that checks if a user attribute matches a specific value. The condition named "CertificateNotExpired" uses the "LibraryConditionAttributes" type to evaluate whether the "User" attribute in the "TACACS" dictionary equals "User1."

```yaml
ise:
  device_administration:
    policy_elements:
      conditions:
        - name: CertificateNotExpired
          type: LibraryConditionAttributes
          is_negate: false
          dictionary_name: TACACS
          attribute_name: User
          operator: equals
          attribute_value: User1
```

Example-2 Defining Multiple Policy Element Condition

This example defines two separate policy elements named "PolicyUser1" and "PolicyUser2,". Both conditions check the TACACS dictionary for the "User" attribute, verifying equality to "User1" and "User2," respectively. This setup allows distinct policy elements to be applied based on the specific user identity, enabling user-specific access control within device administration.

```yaml
ise:
  device_administration:
    policy_elements:
      conditions:
        - name: PolicyUser1
          type: LibraryConditionAttributes
          is_negate: false
          dictionary_name: TACACS
          attribute_name: User
          operator: equals
          attribute_value: User1
        - name: PolicyUser2
          type: LibraryConditionAttributes
          is_negate: false
          dictionary_name: TACACS
          attribute_name: User
          operator: equals
          attribute_value: User2
```

Example-3 Router Compliance Policy Element with AND Condition Block

This example defines a policy element named "RouterCompliance" that uses a LibraryConditionAndBlock type to combine multiple conditions with an AND logic. It includes two conditions: one verifying that the device's software version equals "12.17.4" and another ensuring the device location matches "All Locations." This structure enforces that both conditions must be true for the policy element to apply, enabling precise compliance checks for routers based on software version and location.

```yaml
ise:
  device_administration:
    policy_elements:
      conditions:
        - name: RouterCompliance
          type: LibraryConditionAndBlock
          is_negate: false
          children:
            - name: RouterSofrwareVersion
              type: ConditionAttributes
              is_negate: false
              dictionary_name: DEVICE
              attribute_name: Software Version
              operator: equals
              attribute_value: 12.17.4
            - name: DeviceLocation
              type: ConditionAttributes
              is_negate: false
              dictionary_name: DEVICE
              attribute_name: Location
              operator: equals
              attribute_value: All Locations
```