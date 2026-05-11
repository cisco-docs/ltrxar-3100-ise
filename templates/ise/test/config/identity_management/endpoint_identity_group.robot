*** Settings ***
Documentation   Verify Endpoint Identity Groups
Suite Setup     Login ISE
Resource        ../../ise_common.resource
Default Tags    config   ise   identity_management   endpoint_identity_groups

*** Test Cases ***

{% for endpoint_group in ise.identity_management.endpoint_identity_groups | default([]) %}

Verify Endpoint Identity Group {{ endpoint_group.name }}
    ${r}=   GET On Session   ISE_Session   /ers/config/endpointgroup/name/{{endpoint_group.name}}
    Log   Response Status Code: ${r.status_code}
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $..EndPointGroup.description   {{ endpoint_group.description | default(defaults.ise.identity_management.endpoint_identity_groups.description) | default('')  }}
{% if endpoint_group.parent_group | default([]) %}
    ${parent_group}=   GET On Session   ISE_Session   /ers/config/endpointgroup/name/{{endpoint_group.parent_group}}
    Should Be Equal Value Json String   ${r.json()}   $..EndPointGroup.parentId   ${parent_group.json()['EndPointGroup']['id']}
{% endif %}
{% for child in endpoint_group.children| default([]) %}
    ${r}=   GET On Session   ISE_Session   /ers/config/endpointgroup/name/{{child.name}}
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $..EndPointGroup.description   {{ child.description | default('')  }}
{% for child_child in child.children | default([]) %}
    ${r}=   GET On Session   ISE_Session   /ers/config/endpointgroup/name/{{child_child.name}}
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $..EndPointGroup.description   {{ child_child.description | default('')  }}
{% for child_child_child in child_child.children | default([]) %}
    ${r}=   GET On Session   ISE_Session   /ers/config/endpointgroup/name/{{child_child_child.name}}
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $..EndPointGroup.description   {{ child_child_child.description | default('')  }}
{% for child_child_child_child in child_child_child.children | default([]) %}
    ${r}=   GET On Session   ISE_Session   /ers/config/endpointgroup/name/{{child_child_child_child.name}}
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $..EndPointGroup.description   {{ child_child_child_child.description | default('')  }}
{% for child_child_child_child_child in child_child_child_child.children | default([]) %}
    ${r}=   GET On Session   ISE_Session   /ers/config/endpointgroup/name/{{child_child_child_child_child.name}}
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $..EndPointGroup.description   {{ child_child_child_child_child.description | default('')  }}
{% endfor %}
{% endfor %}
{% endfor %}
{% endfor %}
{% endfor %}
{% endfor %}
