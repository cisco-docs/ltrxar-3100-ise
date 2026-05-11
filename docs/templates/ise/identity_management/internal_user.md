# Internal User

*Location in GUI*:
`Administration` » `Identity Management` » `Identities` » `Users`

{{ doc_gen }}

### Examples

```yaml
ise:
  identity_management:
    internal_users:
      - name: ap-user
        enabled: true
        password: Cisco123
        first_name: AP User
        change_password: false
        user_identity_groups: 
          - EAP-USERS
        password_id_store: Internal Users
```
