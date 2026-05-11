*** Settings ***
Documentation   Verify Device Admin Authorization Global Exception Rules
Suite Setup     Login ISE
Resource        ../../ise_common.resource
Default Tags    config   ise   device_administration   authorization_global_exception_rules

*** Test Cases ***

Get Device Admin Authorization Global Exception Rules
    ${r}=   GET On Session   ISE_Session   /api/v1/policy/device-admin/policy-set/global-exception
    Log   Response Status Code: ${r.status_code}
    Set Suite Variable   ${r}

{% for rule in ise.device_administration.authorization_global_exception_rules | default([]) %}

Verify Device Admin Authorization Global Exception Rule {{ rule.name }}
    ${rule}=   Set Variable   $.response[?(@.rule.name=='{{ rule.name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${rule}.profile   {{ rule.profile }}
    Should Be Equal Value Json String   ${r.json()}   ${rule}.securityGroup   {{ rule.security_group | default('') }}
    Should Be Equal Value Json String   ${r.json()}   ${rule}.rule.rank   {{ rule.rank | default(loop.index0) }}
    Should Be Equal Value Json String   ${r.json()}   ${rule}.rule.state   {{ rule.state | default(defaults.ise.device_administration.authorization_global_exception_rules.state) | default('enabled') }}
{% if rule.condition.type == 'ConditionAttributes' %}
    Should Be Equal Value Json String   ${r.json()}   ${rule}.rule.condition.conditionType   {{ rule.condition.type }}
    Should Be Equal Value Json String   ${r.json()}   ${rule}.rule.condition.isNegate   {{ rule.condition.is_negate | default(defaults.ise.device_administration.authorization_global_exception_rules.condition.is_negate) | default(false) }}
    Should Be Equal Value Json String   ${r.json()}   ${rule}.rule.condition.dictionaryName   {{ rule.condition.dictionary_name }}
    Should Be Equal Value Json String   ${r.json()}   ${rule}.rule.condition.attributeName   {{ rule.condition.attribute_name }}
    Should Be Equal Value Json String   ${r.json()}   ${rule}.rule.condition.attributeValue   {{ rule.condition.attribute_value }}
    Should Be Equal Value Json String   ${r.json()}   ${rule}.rule.condition.operator   {{ rule.condition.operator }}
{% elif rule.condition.type == 'ConditionReference' %}
    Should Be Equal Value Json String   ${r.json()}   ${rule}.rule.condition.conditionType   {{ rule.condition.type }}
    Should Be Equal Value Json String   ${r.json()}   ${rule}.rule.condition.name   {{ rule.condition.name }}
    Should Be Equal Value Json String   ${r.json()}   ${rule}.rule.condition.isNegate   {{ rule.condition.is_negate | default(defaults.ise.device_administration.authorization_global_exception_rules.condition.is_negate) | default(false) }}
{% elif rule.condition.type == 'ConditionAndBlock' or rule.condition.type == 'ConditionOrBlock' %}
    Should Be Equal Value Json String   ${r.json()}   ${rule}.rule.condition.conditionType   {{ rule.condition.type }}
    Should Be Equal Value Json String   ${r.json()}   ${rule}.rule.condition.isNegate   {{ rule.condition.is_negate | default(defaults.ise.device_administration.authorization_global_exception_rules.condition.is_negate) | default(false) }}
{% for child in rule.condition.children %}
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