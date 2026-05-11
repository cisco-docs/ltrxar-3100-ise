# Allowed Protocols

*Location in GUI*:
`Work Centers` » `Device Administration` » `Policy Elements` » `Results` » `Allowed Protocols`

{{ doc_gen }}

### Examples

Example-1: Enabling PAP/ASCII for Device Administration

This example demonstrates how to define an Allowed Protocols profile within Cisco ISE's device administration settings, specifying which authentication methods (PAP/ASCII, CHAP, MS-CHAPv1) are permitted for network devices access. In this case, only PAP/ASCII is enabled, while CHAP and MS-CHAPv1 are disabled, providing clear and structured way to control and document protocol usage for device authentication policies. 

```yaml
ise:
  device_administration:
    policy_elements:
      allowed_protocols:
        - name: Global Protocols
          description: Allowed protocols
          allow_pap_ascii: true
          allow_chap: false
          allow_ms_chap_v1: false
```

Example-2: Enabling CHAP for Device Administration

As in the previous example, this example demonstrates how to define an Allowed Protocols profile within Cisco ISE's device administration settings. As you can see, this example uses a different name and description, and it enables a more secure protocol for device administration.

```yaml
ise:
  device_administration:
    policy_elements:
      allowed_protocols:
        - name: Device Admin Protocols
          description: Allowing CHAP Protocol for Device Administration
          allow_pap_ascii: false
          allow_chap: true
          allow_ms_chap_v1: false
```

Example-3: Adding multiple profiles for device administration 

This example demonstrates how you can configure multiple Allowed Protocols profiles for device administration. 

```yaml
ise:
  device_administration:
    policy_elements:
      allowed_protocols:
        - name: Device Profile 1
          description: Allowing PAP/ASCII Protocol 
          allow_pap_ascii: true
          allow_chap: false
          allow_ms_chap_v1: false
        - name: Device Profile 2
          description: Allowing CHAP Protocol
          allow_pap_ascii: false
          allow_chap: true
          allow_ms_chap_v1: false
```