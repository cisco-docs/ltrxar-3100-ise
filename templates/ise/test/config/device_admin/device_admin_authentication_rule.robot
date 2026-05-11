*** Settings ***
Documentation   Verify Device Admin Authentiction Rules
Suite Setup     Login ISE
Resource        ../../ise_common.resource
Default Tags    config   ise   device_administration   policy_sets   authentication_rules

*** Test Cases ***

Get Device Admin Policy Sets
    ${r}=   GET On Session   ISE_Session   /api/v1/policy/device-admin/policy-set
    Log   Response Status Code: ${r.status_code}
    Set Suite Variable   ${r}

{% for policy_set in ise.device_administration.policy_sets | default([]) %}
{% for rule in policy_set.authentication_rules | default([]) %}
Verify Device Admin Authentication Rule {{ rule.name }} in {{ policy_set.name }}
    ${policy_id}=   Get Value From Json   ${r.json()}   $.response[?(@.name=='{{ policy_set.name }}')]['id']
    ${r}=   GET On Session   ISE_Session  /api/v1/policy/device-admin/policy-set/${policy_id}[0]/authentication
    ${rule}=   Set Variable   $.response[?(@.rule.name=='{{ rule.name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${rule}.identitySourceName   {{ rule.identity_source_name | default('Internal Users')}}
    Should Be Equal Value Json String   ${r.json()}   ${rule}.ifAuthFail   {{ rule.if_auth_fail | default(defaults.ise.device_administration.policy_sets.authentication_rules.if_auth_fail) | default('REJECT') }}
    Should Be Equal Value Json String   ${r.json()}   ${rule}.ifUserNotFound   {{ rule.if_user_not_found | default(defaults.ise.device_administration.policy_sets.authentication_rules.if_user_not_found) }}
    Should Be Equal Value Json String   ${r.json()}   ${rule}.ifProcessFail   {{ rule.if_process_fail | default(defaults.ise.device_administration.policy_sets.authentication_rules.if_process_fail) | default('DROP') }}
    Should Be Equal Value Json String   ${r.json()}   ${rule}.rule.rank   {{ rule.rank | default(loop.index0) }}
    Should Be Equal Value Json String   ${r.json()}   ${rule}.rule.state   {{ rule.state | default(defaults.ise.device_administration.policy_sets.authentication_rules.state) | default('enabled') }}
{% set condition = rule.condition if rule.condition is defined else {"type": "DefaultCondition"} %}
{% if condition.type == 'ConditionAttributes' %}
    Should Be Equal Value Json String   ${r.json()}   ${rule}.rule.condition.conditionType   {{ condition.type }}
    Should Be Equal Value Json String   ${r.json()}   ${rule}.rule.condition.isNegate   {{ condition.is_negate | default(defaults.ise.device_administration.policy_sets.authentication_rules.condition.is_negate) | default(false) }}
    Should Be Equal Value Json String   ${r.json()}   ${rule}.rule.condition.dictionaryName   {{ condition.dictionary_name }}
    Should Be Equal Value Json String   ${r.json()}   ${rule}.rule.condition.attributeName   {{ condition.attribute_name }}
    Should Be Equal Value Json String   ${r.json()}   ${rule}.rule.condition.attributeValue   {{ condition.attribute_value }}
    Should Be Equal Value Json String   ${r.json()}   ${rule}.rule.condition.operator   {{ condition.operator }}
{% elif condition.type == 'ConditionReference' %}
    Should Be Equal Value Json String   ${r.json()}   ${rule}.rule.condition.conditionType   {{ condition.type }}
    Should Be Equal Value Json String   ${r.json()}   ${rule}.rule.condition.name   {{ condition.name }}
    Should Be Equal Value Json String   ${r.json()}   ${rule}.rule.condition.isNegate   {{ condition.is_negate | default(defaults.ise.device_administration.policy_sets.authentication_rules.condition.is_negate) | default(false) }}
{% elif condition.type == 'ConditionAndBlock' or condition.type == 'ConditionOrBlock' %}
    Should Be Equal Value Json String   ${r.json()}   ${rule}.rule.condition.conditionType   {{ condition.type }}
    Should Be Equal Value Json String   ${r.json()}   ${rule}.rule.condition.isNegate   {{ condition.is_negate | default(defaults.ise.device_administration.policy_sets.authentication_rules.condition.is_negate) | default(false) }}
{% for child in condition.children %}
    ${cond_child}=   Set Variable   ${rule}.rule.condition.children[{{loop.index0}}]
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
{% endfor %}