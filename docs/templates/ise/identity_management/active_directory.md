# Active Directory

*Location in GUI*:
`Administration` » `Identity Management` » `External Identity Sources` » `Active Directory`

{{ doc_gen }}

### Examples

Example 1: Full domain join with groups (default behavior) - Creates AD join point, joins ISE to the domain, and add groups for policy use. Groups are specified as objects with name (SID will be looked up from AD):

```yaml
ise:
  identity_management:
    active_directories:
      - name: corp.example.com
        description: Corporate AD with full join
        domain: corp.example.com
        ad_scopes_names: Default_Scope
        ad_username: administrator
        ad_password: C1sco12345
        groups:
          - name: corp.example.com/Users/Domain Admins
          - name: corp.example.com/Users/Network Admins
```

Example 2: Create join point only without joining domain - Useful for initial setup or environments where domain join needs to be performed separately:

```yaml
ise:
  identity_management:
    active_directories:
      - name: corp.example.com
        description: AD join point without domain join
        domain: corp.example.com
        ad_scopes_names: Default_Scope
        join_domain: false
        # No groups specified - will be added later
```

Example 3: Add groups to existing join point without re-joining - Updates an existing AD configuration to add groups without triggering a domain re-join operation. Groups are objects with name field (SID will be looked up from AD):

```yaml
ise:
  identity_management:
    active_directories:
      - name: corp.example.com
        description: Add groups to existing join point
        domain: corp.example.com
        ad_scopes_names: Default_Scope
        join_domain: false  # Don't re-join, just update groups
        groups:
          - name: corp.example.com/Users/Domain Admins
          - name: corp.example.com/Users/Network Admins
          - name: corp.example.com/Users/Helpdesk
```

Example 4: Add groups with SID without domain join or AD connectivity - Specify groups with their Security Identifiers (SIDs) directly, eliminating the need for domain join and AD lookup. Ideal for test/dev environments without AD access, or when you want faster deployments:

```yaml
ise:
  identity_management:
    active_directories:
      - name: corp.example.com
        description: AD groups with pre-defined SIDs
        domain: corp.example.com
        ad_scopes_names: Default_Scope
        join_domain: false  # No AD join required!
        groups:
          - name: corp.example.com/Users/Domain Admins
            sid: S-1-5-21-1234567890-1234567890-1234567890-512
            type: GLOBAL
          - name: corp.example.com/Users/Network Admins
            sid: corp.example.com/S-1-5-21-1234567890-1234567890-1234567890-1001
            # type is optional
          - name: corp.example.com/Builtin/Users
            sid: S-1-5-32-545
            type: "BUILTIN"
```
