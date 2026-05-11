# Matrix Entry

*Location in GUI*:
`Work Centers` » `TrustSec` » `TrustSec Policy` » `Matrix`

{{ doc_gen }}

### Examples

Example 1: Basic TrustSec matrix entry configuration allowing all traffic between TrustSec devices using the default Permit IP security group ACL:

```yaml
ise:
  trust_sec:
    matrix_entries:
      - source_sgt: TrustSec_Devices
        destination_sgt: TrustSec_Devices
        rule_status: ENABLED
        sgacl_name: Permit IP
```

Example 2: Comprehensive TrustSec deployment with automatic push mode enabled for immediate policy distribution to network devices, featuring custom security groups, granular ACLs for HTTP/HTTPS traffic control, and multiple matrix entries defining segmentation policies between printer and server zones:

```yaml
ise:
  trust_sec:
    push_mode: AUTO
    security_groups:
      - name: Printers
        description: Printer security group
        value: 101
      - name: Servers
        description: Server security group
        value: 102
    security_group_acls:
      - name: Permit_HTTP_HTTPS
        description: Allow HTTP and HTTPS traffic
        ip_version: IPV4
        acl_content:
          - permit tcp dst eq 80
          - permit tcp dst eq 443
    matrix_entries:
      - source_sgt: Printers
        destination_sgt: Servers
        rule_status: ENABLED
        sgacl_name: Permit_HTTP_HTTPS
      - source_sgt: Servers
        destination_sgt: Printers
        rule_status: ENABLED
        sgacl_name: Permit_HTTP_HTTPS
```
