# Policy Set

*Location in GUI*:
`Work Centers` » `Network Access` » `Policy Sets`

{{ doc_gen }}

### Examples

Example-1 Network Access Policy Set with Ethernet Port Type Filtering

This example demonstrates a Cisco ISE network access policy set configured to handle wired network authentication scenarios. The policy set "CorporateWiredPolicy" is associated with the "Default Network Access" service and uses a simple attribute-based condition to filter incoming authentication requests. The condition evaluates the RADIUS attribute "NAS-Port-Type" and matches only when it equals "Ethernet", ensuring the policy set exclusively processes wired 802.1X authentication attempts while excluding wireless, VPN, or other connection types. This represents a fundamental policy set structure commonly used in enterprise networks to separate wired and wireless authentication policies, allowing administrators to define different authorization rules and security requirements based on physical connection type.

```yaml
ise:
  network_access:
    policy_sets:
      - name: CorporateWiredPolicy
        service_name: Default Network Access
        condition:
          type: ConditionAttributes
          dictionary_name: Radius
          attribute_name: NAS-Port-Type
          operator: equals
          attribute_value: Ethernet
```

Example-2 Network Access Policy Set with Wireless Port Type and SSID Filtering

This example demonstrates a Cisco ISE network access policy set configured for corporate wireless network authentication with SSID-based filtering. The policy set "Corporate_Wireless_Policy" is enabled and associated with the "Default Network Access" service, using a ConditionAndBlock to enforce two mandatory criteria for policy evaluation. The first condition evaluates the RADIUS attribute "NAS-Port-Type" to match "Wireless - IEEE 802.11", ensuring only wireless connections are processed. The second condition checks the "Called-Station-ID" RADIUS attribute to verify it contains "Corp-SSID", restricting the policy set to a specific corporate wireless SSID. This AND logic configuration ensures the policy set only applies to authenticated users connecting via the designated corporate wireless network, providing network segmentation and allowing administrators to define distinct authentication and authorization rules specific to the corporate SSID while excluding other wireless networks.

```yaml
ise:
  network_access:
    policy_sets:
      - name: Corporate_Wireless_Policy
        description: Policy set for corporate wireless network with SSID filtering
        state: enabled
        service_name: Default Network Access
        condition:
          type: ConditionAndBlock
          children:
            - type: ConditionAttributes
              dictionary_name: Radius
              attribute_name: NAS-Port-Type
              operator: equals
              attribute_value: Wireless - IEEE 802.11
            - type: ConditionAttributes
              dictionary_name: Radius
              attribute_name: Called-Station-ID
              operator: contains
              attribute_value: Corp-SSID
```

Example-3 Network Access Policy Set with Virtual Port Type and Username Filtering

This example demonstrates a network access policy set configured for VPN remote access with AND logic to match multiple connection criteria. The policy set "VPN_Remote_Access_Policy" is enabled and associated with the "Default Network Access" service, using a ConditionAndBlock to evaluate two alternative conditions. The first condition checks if the RADIUS attribute "NAS-Port-Type" equals "Virtual" to identify VPN connections. The second condition evaluates "Network Access : UserName" to match a specific user "User1", allowing the policy set to apply when any VPN connection is detected and the specific username matches.

```yaml
ise:
  network_access:
    policy_sets:
      - name: VPN_Remote_Access_Policy
        description: Policy set for VPN access
        state: enabled
        service_name: Default Network Access
        condition:
          type: ConditionAndBlock
          children:
            - type: ConditionAttributes
              dictionary_name: Radius
              attribute_name: NAS-Port-Type
              operator: equals
              attribute_value: Virtual
            - type: ConditionAttributes
              dictionary_name: Network Access
              attribute_name: UserName
              operator: equals
              attribute_value: User1
```
