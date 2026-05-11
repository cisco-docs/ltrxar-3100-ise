# Endpoint Identity Group

Up to five levels of nested endpoint identity groups are supported.

*Location in GUI*:
`Administration` » `Identity Management` » `Groups` » `Endpoint Identity Groups`

{{ doc_gen }}

### Examples

```yaml
ise:
  identity_management:
    endpoint_identity_groups:
      - name: Group1
        description: My group 1
        parent_group: Blocked List
        children:
          - name: Nested_Group1
            description: My Nested group 1
```
