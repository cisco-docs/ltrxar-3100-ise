# Authorization Profile

*Location in GUI*:
`Work Centers` » `Network Access` » `Policy Elements` » `Results` » `Authorization Profiles`

{{ doc_gen }}

### Examples

Example-1 VLAN 100 Network Access Authorization Profilets 

his example demonstrates a Cisco ISE network access authorization profile configured for basic VLAN assignment. The profile "PERMIT_vlan100" is set to ACCESS_ACCEPT to grant network access and assigns authenticated endpoints to VLAN100 using VLAN tag ID 1. The configuration uses the "Cisco" profile name and disables advanced features including track movement, agentless posture assessment, service template, and EasyWired session candidate functionality. This represents a straightforward authorization profile commonly used for granting standard network access with simple VLAN segmentation, suitable for corporate endpoints requiring dedicated network segments without additional security posture checks or dynamic provisioning capabilities.

```yaml
ise:
  network_access:
    policy_elements:
      authorization_profiles:
        - name: PERMIT_vlan100
          description: "PERMIT_vlan100"
          access_type: "ACCESS_ACCEPT"
          track_movement: false
          agentless_posture: false
          service_template: false
          easywired_session_candidate: false
          profile_name: "Cisco"
          vlan_tag_id: 1
          vlan_name_id: VLAN100
```

Example-2 Corporate Employee Full Network Access Authorization Profile

This example demonstrates a Cisco ISE network access authorization profile configured for corporate employees with comprehensive access control. The profile "Corporate_Employee_Full_Access" grants network access (ACCESS_ACCEPT) and assigns devices to CORPORATE_VLAN with VLAN tag ID 10. It enforces multiple layers of access control including a standard ACL named "CORPORATE_ACL", a downloadable ACL "PERMIT_ALL_TRAFFIC" for IPv4 traffic, and "CORPORATE_IPv6_ACL" for IPv6 filtering. The profile enables track_movement for endpoint mobility tracking and implements periodic reauthentication every 8 hours (28800 seconds) using the default connectivity mode. 

```yaml
ise:
  network_access:
    policy_elements:
      authorization_profiles:
        - name: Corporate_Employee_Full_IPv4_Access
          description: "Corporate employees with full network access and ACL restrictions"
          access_type: "ACCESS_ACCEPT"
          vlan_name_id: CORPORATE_VLAN
          vlan_tag_id: 10
          dacl_name: "PERMIT_ALL_IPV4_TRAFFIC"
          ipv6_dacl_name: "DENY_ALL_IPV6_TRAFFIC"
          track_movement: true
          agentless_posture: false
          service_template: false
          easywired_session_candidate: false
          reauthentication_timer: 28800
          reauthentication_connectivity: "DEFAULT"
          profile_name: "Cisco"
```

Example-3 Authorization Profile with Interface Template and Reauthentication for Contractors

This example demonstrates a Cisco ISE network access authorization profile configured for temporary contractor access with enhanced security restrictions. The profile "Contractor_Limited_Access" grants network access (ACCESS_ACCEPT) and assigns contractors to CONTRACTOR_VLAN with VLAN tag ID 30. It applies the "CONTRACTOR_RESTRICTED" downloadable ACL to limit network access and uses the "CONTRACTOR_PORT_CONFIG" interface template for port-level configuration. The profile implements frequent reauthentication every 4 hours (14400 seconds) using RADIUS_REQUEST connectivity mode to ensure continuous validation. Track_movement is enabled for endpoint mobility monitoring, and a custom RADIUS attribute "Cisco:cisco-av-pair" with value "Session:URL-Redirected" is configured for URL redirection capability.

```yaml
ise:
  network_access:
    policy_elements:
      authorization_profiles:
         - name: Contractor_Limited_Access
           description: "Contractors with time-limited and restricted network access"
           access_type: "ACCESS_ACCEPT"
           vlan_name_id: CONTRACTOR_VLAN
           vlan_tag_id: 30
           dacl_name: "CONTRACTOR_RESTRICTED"
           interface_template: "CONTRACTOR_PORT_CONFIG"
           track_movement: true
           agentless_posture: false
           service_template: false
           easywired_session_candidate: false
           reauthentication_timer: 14400
           reauthentication_connectivity: "RADIUS_REQUEST"
           profile_name: "Cisco"
           advanced_attributes:
              - name: "Cisco:cisco-av-pair"
                value: "Session:URL-Redirected"
```

