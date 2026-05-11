# Authorization Global Exception Rule

*Location in GUI*:
`Work Centers` » `Network Access` » `Policy Sets` » `XXX` » `Authorization Policy - Global Exceptions`

{{ doc_gen }}

### Examples

Example-1 802.1X Wired Network Global Exception Rule

This example demonstrates a Cisco ISE network access global exception authorization rule for wired 802.1X authentication. The rule "AUTHZ_DOT1x_wired" is enabled and evaluates endpoint membership in "Endpoint Identity Groups:group_1" using a simple attribute-based condition with an equals operator. When the condition matches, the rule applies the "PERMIT_vlan1" authorization profile to grant network access. This configuration represents a straightforward identity group-based authorization policy for granting specific network permissions to pre-defined endpoint groups in corporate wired environments.

```yaml
ise:
  network_access:
    authorization_global_exception_rules:
      - name: AUTHZ_DOT1x_wired
        state: enabled
        condition:
          type: ConditionAttributes
          is_negate: false
          dictionary_name: IdentityGroup
          attribute_name: Name
          operator: equals
          attribute_value: Endpoint Identity Groups:group_1
        profiles:
          - PERMIT_vlan1
```

Example-2 Corporate Wireless and IoT Multi-Condition Global Exception Rule

This example demonstrates a Cisco ISE network access global exception authorization rule using OR logic to match multiple network access scenarios. The rule "Corporate_Wireless_or_IoT" is enabled and evaluates three alternative conditions: wireless controller device types, corporate user identity group membership (using contains operator), or RADIUS Called-Station-ID patterns matching IoT device prefixes (AC- or IoT-). When any of these conditions match, the rule assigns the "TrustSec-Employees" security group tag for TrustSec policy enforcement, demonstrating flexible authorization for diverse network endpoints without applying specific authorization profiles.

```yaml
ise:
  network_access:
    authorization_global_exception_rules:
      - name: Corporate_Wireless_or_IoT
        state: enabled
        condition:
          type: ConditionOrBlock
          children:
            - type: ConditionAttributes
              dictionary_name: DEVICE
              attribute_name: Device Type
              operator: equals
              attribute_value: All Device Types
            - type: ConditionAttributes
              dictionary_name: IdentityGroup
              attribute_name: Name
              operator: contains
              attribute_value: Employee
        security_group:  Employees
```

Example-3 Time and Location-Based Guest Global Exception Rule

This example demonstrates a Cisco ISE network access global exception authorization rule using AND logic to enforce restrictive guest access policies. The rule "Restricted_Guest_Access" is enabled and requires all three conditions to match simultaneously: the network device must be one of the designated guest switches or access points (Guest-Switch-01, Guest-Switch-02, or Guest-AP-Building-A) using the in operator, the user must belong to "User Identity Groups:Guest" using an exact match, and access must occur during business hours via a referenced condition named "Business_Hours_Only". When all conditions are satisfied, the rule applies the "Guest_Internet_Only" authorization profile to provide limited network access, demonstrating combined time-based, location-based, and identity-based access control for temporary network users in enterprise guest wireless deployments.


```yaml
ise:
  network_access:
    authorization_global_exception_rules:
      - name: Restricted_Guest_Access
        state: enabled
        condition:
          type: ConditionAndBlock
          children:
            - type: ConditionAttributes
              dictionary_name: Network Access
              attribute_name: NetworkDeviceName
              operator: in
              attribute_value: Guest-Switch-01,Guest-Switch-02,Guest-AP-Building-A
            - type: ConditionAttributes
              dictionary_name: IdentityGroup
              attribute_name: Name
              operator: equals
              attribute_value: User Identity Groups:Guest
            - type: ConditionReference
              name: Business_Hours_Only
        profiles:
          - Guest_Internet_Only
```
