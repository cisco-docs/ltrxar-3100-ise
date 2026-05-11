*** Settings ***
Documentation   Verify Device Admin Conditions
Suite Setup     Login ISE
Resource        ../../ise_common.resource
Default Tags    config   ise   device_administration   policy_elements   conditions

*** Test Cases ***

Get Device Admin Conditions
    ${r}=   GET On Session   ISE_Session   /api/v1/policy/device-admin/condition
    Log   Response Status Code: ${r.status_code}
    Set Suite Variable   ${r}

{% for condition in ise.device_administration.policy_elements.conditions | default([]) %}
Verify Device Admin Condition {{ condition.name }}
    ${cond}=   Set Variable   $.response[?(@.name=='{{ condition.name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${cond}.description   {{ condition.description | default('') }}
{% if condition.type == 'LibraryConditionAttributes' %}
    Should Be Equal Value Json String   ${r.json()}   ${cond}.conditionType   {{ condition.type }}
    Should Be Equal Value Json String   ${r.json()}   ${cond}.isNegate   {{ condition.is_negate | default(defaults.ise.device_administration.policy_elements.conditions.is_negate) | default(false) }}
    Should Be Equal Value Json String   ${r.json()}   ${cond}.dictionaryName   {{ condition.dictionary_name }}
    Should Be Equal Value Json String   ${r.json()}   ${cond}.attributeName   {{ condition.attribute_name }}
    Should Be Equal Value Json String   ${r.json()}   ${cond}.attributeValue   {{ condition.attribute_value }}
    Should Be Equal Value Json String   ${r.json()}   ${cond}.operator   {{ condition.operator }}
{% elif condition.type == 'LibraryConditionAndBlock' or condition.type == 'LibraryConditionOrBlock' %}
    Should Be Equal Value Json String   ${r.json()}   ${cond}.conditionType   {{ condition.type }}
    Should Be Equal Value Json String   ${r.json()}   ${cond}.isNegate   {{ condition.is_negate | default(defaults.ise.device_administration.policy_elements.conditions.is_negate) | default(false) }}
{% for child in condition.children %}
    ${cond_child}=   Set Variable   ${cond}.children[{{loop.index0}}]
{% if child.type == 'ConditionAttributes' %}
    Should Be Equal Value Json String   ${r.json()}   ${cond_child}.conditionType   {{ child.type }}
    Should Be Equal Value Json String   ${r.json()}   ${cond_child}.isNegate   {{ child.is_negate | default(defaults.ise.device_administration.policy_elements.conditions.is_negate) | default(false) }}
    Should Be Equal Value Json String   ${r.json()}   ${cond_child}.attributeName   {{ child.attribute_name }}
    Should Be Equal Value Json String   ${r.json()}   ${cond_child}.dictionaryName   {{ child.dictionary_name }}
    Should Be Equal Value Json String   ${r.json()}   ${cond_child}.attributeValue   {{ child.attribute_value }}
    Should Be Equal Value Json String   ${r.json()}   ${cond_child}.operator   {{ child.operator }}
{% elif child.type == 'ConditionReference' %}
    Should Be Equal Value Json String   ${r.json()}   ${cond_child}.conditionType   {{ child.type }}
    Should Be Equal Value Json String   ${r.json()}   ${cond_child}.isNegate   {{ child.is_negate | default(defaults.ise.device_administration.policy_elements.conditions.is_negate) | default(false) }}
    Should Be Equal Value Json String   ${r.json()}   ${cond_child}.name   {{ child.name }}
{% elif child.type == 'ConditionAndBlock' or child.type == 'ConditionOrBlock' %}
    Should Be Equal Value Json String   ${r.json()}   ${cond_child}.conditionType   {{ child.type }}
    Should Be Equal Value Json String   ${r.json()}   ${cond_child}.isNegate   {{ child.is_negate | default(defaults.ise.device_administration.policy_elements.conditions.is_negate) | default(false) }}
{% for child_child in child.children %}
    ${cond_child_child}=   Set Variable   ${cond_child}.children[{{loop.index0}}]
{% if child_child.type == 'ConditionAttributes' %}
    Should Be Equal Value Json String   ${r.json()}   ${cond_child_child}.conditionType   {{ child_child.type }}
    Should Be Equal Value Json String   ${r.json()}   ${cond_child_child}.isNegate   {{ child_child.is_negate | default(defaults.ise.device_administration.policy_elements.conditions.is_negate) | default(false) }}
    Should Be Equal Value Json String   ${r.json()}   ${cond_child_child}.attributeName   {{ child_child.attribute_name }}
    Should Be Equal Value Json String   ${r.json()}   ${cond_child_child}.dictionaryName   {{ child_child.dictionary_name }}
    Should Be Equal Value Json String   ${r.json()}   ${cond_child_child}.attributeValue   {{ child_child.attribute_value }}
    Should Be Equal Value Json String   ${r.json()}   ${cond_child_child}.operator   {{ child_child.operator }}
{% elif child_child.type == 'ConditionReference' %}
    Should Be Equal Value Json String   ${r.json()}   ${cond_child_child}.name   {{ child_child.name }}
    Should Be Equal Value Json String   ${r.json()}   ${cond_child_child}.conditionType   {{ child_child.type }}
    Should Be Equal Value Json String   ${r.json()}   ${cond_child_child}.isNegate   {{ child_child.is_negate | default(defaults.ise.device_administration.policy_elements.conditions.is_negate) | default(false) }}
{% endif %}
{% endfor %}
{% endif %}
{% endfor %}
{% endif %}
{% endfor %}