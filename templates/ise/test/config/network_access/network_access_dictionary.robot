*** Settings ***
Documentation   Verify Network Access Dictionaries
Suite Setup     Login ISE
Resource        ../../ise_common.resource
Default Tags    config   ise   network_access   policy_elements   dictionaries

*** Test Cases ***

Get Network Access Dictionaries
    ${r}=   GET On Session   ISE_Session   /api/v1/policy/network-access/dictionaries
    Log   Response Status Code: ${r.status_code}
    Set Suite Variable   ${r}

{% for dictionary in ise.network_access.policy_elements.dictionaries | default([]) %}

Verify Network Access Dictionary {{ dictionary.name }}
    ${dict}=   Set Variable   $.response[?(@.name=='{{ dictionary.name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${dict}.description   {{ dictionary.description | default('') }}
    Should Be Equal Value Json String   ${r.json()}   ${dict}.version   {{ dictionary.version }}
    Should Be Equal Value Json String   ${r.json()}   ${dict}.dictionaryAttrType   {{ dictionary.attribute_type | default(defaults.ise.network_access.policy_elements.dictionaries.attribute_type) | default('ENTITY_ATTR') }}

{% endfor %}