# Security Group ACL

*Location in GUI*:
`Work Centers` » `TrustSec` » `Components` » `Security Group ACLs`

{{ doc_gen }}

### Examples

```yaml
ise:
  trust_sec:
    security_group_acls:
      - name: ACL_99
        ip_version: "IPV4"
        description: "ACL_99"
        acl_content: |
          permit icmp
          permit ssh
          deny https
```
