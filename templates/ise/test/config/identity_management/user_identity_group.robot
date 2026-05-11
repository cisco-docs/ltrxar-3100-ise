*** Settings ***
Documentation   Verify User Identity Groups
Suite Setup     Login ISE
Resource        ../../ise_common.resource
Default Tags    config   ise   identity_management   user_identity_groups

*** Test Cases ***

Get User Identity Groups
    ${user_group}=   Get All Pages   ISE_Session   /ers/config/identitygroup
    Set Suite Variable   ${user_group}
|
{% for user_group in ise.identity_management.user_identity_groups | default([]) %}
Verify user Identity Group {{ user_group.name }}
    ${group_id}=   Get Value From Json   ${user_group}   $.SearchResult.resources[?(@.name=='{{ user_group.name }}')]['id']
    ${r}=   GET On Session   ISE_Session   /ers/config/identitygroup/${group_id}[0]
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $.IdentityGroup.name   {{ user_group.name }}
    Should Be Equal Value Json String   ${r.json()}   $.IdentityGroup.description   {{ user_group.description | default('')  }}
    Should Be Equal Value Json String   ${r.json()}   $.IdentityGroup.parent   {{ user_group.parent_group | default(defaults.ise.identity_management.user_identity_groups.parent_group) | default('NAC Group:NAC:IdentityGroups:User Identity Groups')  }}
{% for child in user_group.children | default([])  %}
    ${group_id}=   Get Value From Json   ${user_group}   $.SearchResult.resources[?(@.name=='{{ child.name }}')]['id']
    ${r}=   GET On Session   ISE_Session   /ers/config/identitygroup/${group_id}[0]
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $.IdentityGroup.name   {{ child.name }}
    Should Be Equal Value Json String   ${r.json()}   $.IdentityGroup.description   {{ child.description | default('')  }}
{% for child_child in child.children | default([])  %}
    ${group_id}=   Get Value From Json   ${user_group}   $.SearchResult.resources[?(@.name=='{{ child_child.name }}')]['id']
    ${r}=   GET On Session   ISE_Session   /ers/config/identitygroup/${group_id}[0]
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $.IdentityGroup.name   {{ child_child.name }}
    Should Be Equal Value Json String   ${r.json()}   $.IdentityGroup.description   {{ child_child.description | default('')  }}
{% for child_child_child in child_child.children | default([]) %}
    ${group_id}=   Get Value From Json   ${user_group}   $.SearchResult.resources[?(@.name=='{{ child_child_child.name }}')]['id']
    ${r}=   GET On Session   ISE_Session   /ers/config/identitygroup/${group_id}[0]
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $.IdentityGroup.name   {{ child_child_child.name }}
    Should Be Equal Value Json String   ${r.json()}   $.IdentityGroup.description   {{ child_child_child.description | default('')  }}
{% for child_child_child_child in child_child_child.children | default([]) %}
    ${group_id}=   Get Value From Json   ${user_group}   $.SearchResult.resources[?(@.name=='{{ child_child_child_child.name }}')]['id']
    ${r}=   GET On Session   ISE_Session   /ers/config/identitygroup/${group_id}[0]
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $.IdentityGroup.name   {{ child_child_child_child.name }}
    Should Be Equal Value Json String   ${r.json()}   $.IdentityGroup.description   {{ child_child_child_child.description | default('')  }}
{% for child_child_child_child_child in child_child_child_child.children | default([])  %}
    ${group_id}=   Get Value From Json   ${user_group}   $.SearchResult.resources[?(@.name=='{{ child_child_child_child_child.name }}')]['id']
    ${r}=   GET On Session   ISE_Session   /ers/config/identitygroup/${group_id}[0]
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $.IdentityGroup.name   {{ child_child_child_child_child.name }}
    Should Be Equal Value Json String   ${r.json()}   $.IdentityGroup.description   {{ child_child_child_child_child.description | default('')  }}
{% endfor %}
{% endfor %}
{% endfor %}
{% endfor %}
{% endfor %}
{% endfor %}