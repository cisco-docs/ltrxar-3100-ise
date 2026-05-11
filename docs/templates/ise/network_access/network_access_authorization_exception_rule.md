# Authorization Exception Rule

*Location in GUI*:
`Work Centers` » `Network Access` » `Policy Sets` » `XXX` » `Authorization Policy - Local Exceptions`

{{ doc_gen }}

### Examples

Example-1 Network Access Authorization Exception Rule for Wired 802.1X Endpoints by Identity Group

This authorization exception rule provides high-priority network access control for wired 802.1X authenticated devices that belong to a specific endpoint identity group. Authorization exception rules are evaluated before standard authorization rules in the policy evaluation order, making them ideal for scenarios requiring immediate policy decisions that bypass normal rule processing. The rule matches when the IdentityGroup:Name attribute equals "Endpoint Identity Groups:group_1" and applies the PERMIT_vlan1 authorization profile, which likely assigns VLAN 1 access permissions.

```yaml
ise:
  network_access:
    policy_sets:
      - name: Global Policy
        authorization_exception_rules:
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
Example-2 Network Access Authorization Exception Rule for Quarantining Non-Compliant Devices with Posture Assessment

This authorization exception rule provides immediate quarantine enforcement for devices that fail Cisco ISE posture assessment compliance checks. The rule uses a compound condition (ConditionAndBlock) that matches when BOTH Session:PostureStatus equals "NonCompliant" AND Network Access:AuthenticationMethod equals "MSCHAPV2", ensuring it captures password-authenticated endpoints that have failed security posture validation.

```yaml
ise:
  network_access:
    policy_sets:
      - name: Global Policy
        description: Global policy for network access
        state: enabled
        service_name: Default Network Access
        authorization_exception_rules:
          - name: Quarantine_Non_Compliant_Devices
            state: enabled
            condition:
              type: ConditionAndBlock
              children:
                - type: ConditionAttributes
                  dictionary_name: Session
                  attribute_name: PostureStatus
                  operator: equals
                  attribute_value: NonCompliant
                - type: ConditionAttributes
                  dictionary_name: Network Access
                  attribute_name: AuthenticationMethod
                  operator: equals
                  attribute_value: MSCHAPV2
            profiles:
              - Quarantine_Profile
```
Example-3 Network Access Authorization Exception Rule for Denying Blacklisted and Compromised Endpoints

This authorization exception rule provides immediate and absolute network access denial for endpoints that have been identified as compromised, unauthorized, or otherwise blacklisted by security operations. The rule matches when the IdentityGroup:Name attribute equals "Endpoint Identity Groups:Blacklist" and applies the DenyAccess profile, which completely blocks network connectivity.

```yaml
ise:
  network_access:
    policy_sets:
      - name: Global Policy
        description: Global policy for network access
        state: enabled
        service_name: Default Network Access
        authorization_exception_rules:
          - name: Blacklist_Compromised_Endpoints
            state: enabled
            condition:
              type: ConditionAttributes
              is_negate: false
              dictionary_name: IdentityGroup
              attribute_name: Name
              operator: equals
              attribute_value: Endpoint Identity Groups:Blacklist
            profiles:
              - DenyAccess
```