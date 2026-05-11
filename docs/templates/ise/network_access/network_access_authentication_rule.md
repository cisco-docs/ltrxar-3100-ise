# Authentication Rule

*Location in GUI*:
`Work Centers` » `Network Access` » `Policy Sets` » `XXX` » `Authentication Policy`

{{ doc_gen }}

### Examples

Example-1 Network Access Authentication Rule for Wired 802.1X with EAP-TLS Certificate Authentication

This authentication rule processes wired 802.1X network access requests using EAP-TLS certificate-based authentication. The rule is enabled and matches when the Network Access:EapAuthentication attribute equals "EAP-TLS", directing authentication to the Preloaded_Certificate_Profile identity source for certificate validation. The rule implements specific failure handling logic: if_auth_fail is set to REJECT (denying access when credentials are invalid), if_user_not_found is set to CONTINUE (allowing the policy engine to evaluate subsequent rules when the certificate is not found in the identity source), and if_process_fail is set to DROP (terminating the authentication attempt on processing errors)

```yaml
ise:
  network_access:
    policy_sets:
      - name: Global Policy
        authentication_rules:
          - name: Wired_802.1X
            state: enabled
            condition:
              type: ConditionAttributes
              dictionary_name: Network Access
              attribute_name: EapAuthentication
              operator: equals
              attribute_value: EAP-TLS
            identity_source_name: Preloaded_Certificate_Profile
            if_auth_fail: REJECT
            if_user_not_found: CONTINUE
            if_process_fail: DROP
```
Example-2 Network Access Authentication Rule for Wireless 802.11 with EAP-TLS Certificate Authentication

This authentication rule processes wireless 802.11 network access requests using EAP-TLS certificate-based authentication. The rule uses a compound condition (ConditionAndBlock) that matches when both the Radius:NAS-Port-Type equals "Wireless - IEEE 802.11" AND the Network Access:EapAuthentication equals "EAP-TLS", ensuring this rule only applies to wireless clients attempting certificate authentication. Authentication is performed against the Internal Users identity source for certificate validation. The rule implements strict failure handling with all failure scenarios set to deny access: if_auth_fail is REJECT (blocking invalid certificates), if_user_not_found is REJECT (denying unknown certificates), and if_process_fail is DROP (terminating on processing errors).
 
```yaml
ise:
  network_access:
    policy_sets:
      - name: Global Policy
        authentication_rules:
          - name: Wireless_EAP_TLS_Authentication
            state: enabled
            condition:
              type: ConditionAndBlock
              children:
                - type: ConditionAttributes
                  dictionary_name: Radius
                  attribute_name: NAS-Port-Type
                  operator: equals
                  attribute_value: Wireless - IEEE 802.11
                - type: ConditionAttributes
                  dictionary_name: Network Access
                  attribute_name: EapAuthentication
                  operator: equals
                  attribute_value: EAP-TLS
            identity_source_name: Internal Users
            if_auth_fail: REJECT
            if_user_not_found: REJECT
            if_process_fail: DROP
```