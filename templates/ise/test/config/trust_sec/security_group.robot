*** Settings ***
Documentation   Verify Security Groups
Suite Setup     Login ISE
Resource        ../../ise_common.resource
Default Tags    config   ise   trust_sec   security_groups

*** Test Cases ***

{% for security_group in ise.trust_sec.security_groups | default([]) %}
Verify Security Group {{ security_group.name }}
    ${r}=   GET On Session   ISE_Session   /ers/config/sgt/name/{{security_group.name}}
    Log   Response Status Code: ${r.status_code}
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $.Sgt.description   {{ security_group.description | default('') }}
    Should Be Equal Value Json String   ${r.json()}   $.Sgt.propogateToApic   {{ security_group.propagate_to_apic | default(defaults.ise.trust_sec.security_groups.propagate_to_apic) | default(false) }}
    Should Be Equal Value Json String   ${r.json()}   $.Sgt.value   {{ security_group.value }}
{% endfor %}