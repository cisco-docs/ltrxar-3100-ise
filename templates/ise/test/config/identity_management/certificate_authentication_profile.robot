*** Settings ***
Documentation   Verify Certificate Authentication Profiles
Suite Setup     Login ISE
Resource        ../../ise_common.resource
Default Tags    config   ise   identity_management   certificate_authentication_profiles

*** Test Cases ***

{% for profile in ise.identity_management.certificate_authentication_profiles | default([]) %}

Verify Certificate Authentication Profile {{ profile.name }}
    ${r}=   GET On Session   ISE_Session   /ers/config/certificateprofile/name/{{profile.name}}
    Log   Response Status Code: ${r.status_code}
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $.CertificateProfile.description   {{ profile.description | default('') }}
    Should Be Equal Value Json String   ${r.json()}   $.CertificateProfile.allowedAsUserName   {{ profile.allowed_as_user_name | default(defaults.ise.identity_management.certificate_authentication_profiles.allowed_as_user_name) | default(false) }}
    Should Be Equal Value Json String   ${r.json()}   $.CertificateProfile.matchMode   {{ profile.match_mode | default(defaults.ise.identity_management.certificate_authentication_profiles.match_mode) | default('NEVER') }}
    Should Be Equal Value Json String   ${r.json()}   $.CertificateProfile.usernameFrom   {{ profile.username_from | default(defaults.ise.identity_management.certificate_authentication_profiles.username_from) | default('CERTIFICATE') }}
    Should Be Equal Value Json String   ${r.json()}   $.CertificateProfile.certificateAttributeName   {{ profile.certificate_attribute_name | default(defaults.ise.identity_management.certificate_authentication_profiles.certificate_attribute_name) | default('SUBJECT_COMMON_NAME') }}
    Should Be Equal Value Json String   ${r.json()}   $.CertificateProfile.externalIdentityStoreName   {{ profile.external_identity_store_name | default(defaults.ise.identity_management.certificate_authentication_profiles.external_identity_store_name) | default('[not applicable]') }}
{% endfor %}