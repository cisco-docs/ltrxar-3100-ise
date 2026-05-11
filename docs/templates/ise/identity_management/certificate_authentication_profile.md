# Certificate Authentication Profile

Due to API limitations (as of version 3.2) a Certificate Authentication Profile can only be created and updated, but not deleted.

*Location in GUI*:
`Administration` » `Identity Management` » `External Identity Sources` » `Certificate Authentication Profiles`

{{ doc_gen }}

### Examples

#### Example 1: Basic Certificate Authentication

```yaml
ise:
  identity_management:
    certificate_authentication_profiles:
      - name: Global_Certificate
        description: Global_Certificate
        certificate_attribute_name: SUBJECT_COMMON_NAME
        allowed_as_user_name: false
        match_mode: NEVER
        username_from: CERTIFICATE
```

#### Example 2: Certificate Authentication with Active Directory (UPN)

This example demonstrates the "Any Subject or Alternative Name Attributes in the Certificate" option, which is available for Active Directory only. Setting `username_from: UPN` allows ISE to use any Subject or Alternative Name attributes from the certificate for AD lookup.

**Important**: When `username_from` is set to `UPN`, do NOT set `certificate_attribute_name`. ISE will automatically set it to `ALL_SUBJECT_AND_ALTERNATIVE_NAMES`. The `certificate_attribute_name` field is only used when `username_from: CERTIFICATE`.

```yaml
ise:
  identity_management:
    certificate_authentication_profiles:
      - name: AD_Certificate_UPN
        description: Certificate profile for Active Directory with UPN
        username_from: UPN
        external_identity_store_name: MyActiveDirectory
        match_mode: RESOLVE_IDENTITY_AMBIGUITY
        allowed_as_user_name: true
        # Note: certificate_attribute_name is NOT set when using UPN
```
