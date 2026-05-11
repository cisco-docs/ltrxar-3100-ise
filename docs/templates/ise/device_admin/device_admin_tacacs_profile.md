# TACACS Profile

*Location in GUI*:
`Work Centers` » `Device Administration` » `Policy Elements` » `Results` » `TACACS Profiles`

{{ doc_gen }}

### Examples

Example-1 : TACACS Profile with Mandatory Privilege 15 

This example defines a TACACS profile named "TacacsProfileWithPrivilege15" within ISE's device administration policy elements. The profile enforces a mandatory session attribute where the privilege level is set to 15. This ensures that any device session authenticated using this profile must have privilege 15 assigned.

```yaml
ise:
  device_administration:
    policy_elements:
      tacacs_profiles:
        - name: TacacsProfileWithPrivilege15
          description: TACACS profile with mandatory privilege 15
          session_attributes:
            - type: MANDATORY
              name: privilege
              value: '15'
```

Example-2 Basic TACACS Profile with Mandatory Session Attributes

This example defines a TACACS profile named "BasicTacacsProfile" that enforces mandatory session attributes for device administration. It requires the session to include the service type set to "shell" and the protocol set to "tacacs+". These mandatory attributes ensure that only sessions meeting these criteria are authorized, providing a foundational level of control for TACACS+ authentication and authorization processes.

```yaml
ise:
  device_administration:
    policy_elements:
      tacacs_profiles:
        - name: BasicTacacsProfile
          description: Basic TACACS profile with mandatory session attributes
          session_attributes:
            - type: MANDATORY
              name: service
              value: shell
            - type: MANDATORY
              name: protocol
              value: tacacs+
```
Example-3 TACACS Profile with multiple Custom Session Attributes

This example defines a TACACS profile within Cisco ISE device administration policies. The profile, named "TacacsProfile," includes custom session attributes to enhance control over device access. It specifies a mandatory session attribute for the service type set to "shell," ensuring shell access is required. Additionally, it includes optional session attributes for device location "DataCenter1" and device type "CatalystSwitch", allowing for more granular policy enforcement based on device context.

```yaml
ise:
  device_administration:
    policy_elements:
      tacacs_profiles:
        - name: TacacsProfile
          description: TACACS profile with custom session attributes for enhanced control
          session_attributes:
            - type: MANDATORY
              name: service
              value: shell
            - type: OPTIONAL
              name: device-location
              value: DataCenter1
            - type: OPTIONAL
              name: device-type
              value: CatalystSwitch
```

