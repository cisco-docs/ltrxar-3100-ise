# User Identity Group

Up to five levels of nested user identity groups are supported.

*Location in GUI*:
`Administration` » `Identity Management` » `Groups` » `User Identity Groups`

{{ doc_gen }}

### Examples

```yaml
ise:
  identity_management:
    user_identity_groups:
      - name: EAP-USERS
        description: My EAP users
        children:
          - name: EAP_USERS_CHILDREN
            description: My Children EAP users
```
