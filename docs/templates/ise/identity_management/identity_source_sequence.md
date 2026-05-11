# Identity Source Sequence

*Location in GUI*:
`Administration` » `Identity Management` » `Identity Source Sequences`

{{ doc_gen }}

### Examples

```yaml
ise:
  identity_management:
    identity_source_sequences:
      - name: Sequence1
        description: My identity source sequence
        certificate_authentication_profile: Preloaded_Certificate_Profile
        break_on_store_fail: true
        identity_sources:
          - Internal Users
          - Guest Users
```
