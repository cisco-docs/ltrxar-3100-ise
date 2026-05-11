*** Settings ***
Documentation   Verify Device Admin TACACS Profiles
Suite Setup     Login ISE
Resource        ../../ise_common.resource
Default Tags    config   ise   device_administration   policy_elements   tacacs_profiles

*** Test Cases ***

{% for profile in ise.device_administration.policy_elements.tacacs_profiles | default([]) %}
Verify Device Admin TACACS Profile {{ profile.name }}
    ${r}=   GET On Session   ISE_Session   ers/config/tacacsprofile/name/{{profile.name}}
    Log   Response Status Code: ${r.status_code}
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $.TacacsProfile.description   {{ profile.description | default('') }}  
{% for attr in profile.session_attributes | default([]) %}
    Should Be Equal Value Json String   ${r.json()}   $.TacacsProfile.sessionAttributes.sessionAttributeList[{{loop.index0}}].type   {{ attr.type | default(defaults.ise.device_administration.policy_elements.tacacs_profiles.session_attributes.type) | default('MANDATORY') }}
    Should Be Equal Value Json String   ${r.json()}   $.TacacsProfile.sessionAttributes.sessionAttributeList[{{loop.index0}}].name   {{ attr.name | default(false) }}
    Should Be Equal Value Json String   ${r.json()}   $.TacacsProfile.sessionAttributes.sessionAttributeList[{{loop.index0}}].value   {{ attr.value | default(false) }}
{% endfor %}
{% endfor %}