# Condition

*Location in GUI*:
`Work Centers` » `Network Access` » `Policy Elements` » `Conditions` » `Library Conditions`

{{ doc_gen }}

### Examples

Example-1 Network Access Policy Element Condition for Certificate Expiration Validation

This example demonstrates a network access policy element condition configured to validate certificate expiration status. The condition "CertificateNotExpired" is a library condition of type LibraryConditionAttributes, which creates a reusable condition that can be referenced across multiple policy sets and authorization rules. The condition evaluates the CERTIFICATE dictionary attribute "Is Expired" using an equals operator to match the value "False", with is_negate set to false for straightforward validation. When this condition is evaluated during certificate-based authentication (such as EAP-TLS), it verifies that the presented certificate is currently valid and not expired, allowing the authentication to proceed only with valid certificates.

```yaml
ise:
  network_access:
    policy_elements:
      conditions:
        - name: CertificateNotExpired
          type: LibraryConditionAttributes
          is_negate: false
          dictionary_name: CERTIFICATE
          attribute_name: Is Expired
          operator: equals
          attribute_value: "False"
```

Example-2 Network Access Policy Element Condition for Wireless IEEE 802.11 Connection Type

This example demonstrates a network access policy element condition configured to identify wireless network connections. The condition "WirelessConnection" is a library condition of type LibraryConditionAttributes, creating a reusable condition that can be referenced across multiple policy sets and authorization rules. The condition evaluates the RADIUS dictionary attribute "NAS-Port-Type" using an equals operator to match the value "Wireless - IEEE 802.11", with is_negate set to false for direct matching. When this condition is evaluated during network authentication, it identifies sessions originating from wireless access points using IEEE 802.11 protocols, distinguishing them from wired Ethernet, VPN, or other connection types

```yaml
ise:
  network_access:
    policy_elements:
      conditions:
        - name: WirelessConnection
          type: LibraryConditionAttributes
          is_negate: false
          dictionary_name: Radius
          attribute_name: NAS-Port-Type
          operator: equals
          attribute_value: Wireless - IEEE 802.11
          description: Matches wireless IEEE 802.11 connections
```

Example-3 Network Access Policy Element Condition with OR Block for Multiple User Identity Groups

This example demonstrates a network access policy element condition configured to match privileged users across multiple identity groups using OR logic. The condition "PrivilegedUsers" is a library condition of type LibraryConditionOrBlock, creating a reusable condition that can be referenced throughout policy sets and authorization rules. The condition evaluates three alternative IdentityGroup membership criteria using child ConditionAttributes: "User Identity Groups:Managers", "User Identity Groups:IT_Staff", and "User Identity Groups:Executives". When this condition is evaluated, it returns true if the authenticating user belongs to ANY of these three identity groups, providing flexible matching logic.

```yaml
ise:
  network_access:
    policy_elements:
      conditions:
         - name: PrivilegedUsers
           type: LibraryConditionOrBlock
           description: Managers, IT Staff, or Executives
           children:
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
             - type: ConditionAttributes
               dictionary_name: IdentityGroup
               attribute_name: Name
               operator: equals
               attribute_value: User Identity Groups:Executives
```