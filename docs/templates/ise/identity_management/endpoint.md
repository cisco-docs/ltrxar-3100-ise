# Endpoint

*Location in GUI*:
`Work Centers` » `Network Access` » `Identities` » `Endpoints`

{{ doc_gen }}

### Examples

```yaml
ise:
  identity_management:
    endpoints:
      - mac: FF:FF:FF:FF:FF:FF
        description: My endpoint
        endpoint_identity_group: Blocked List
        static_profile_assignment: false
        static_group_assignment: true
```
