*** Settings ***
Documentation   Verify Internal Users
Suite Setup     Login ISE
Resource        ../../ise_common.resource
Default Tags    config   ise   identity_management  internal_users

*** Test Cases ***

Get User Identity Gropus
    ${identity_groups}=   Get All Pages   ISE_Session   /ers/config/identitygroup
    Set Suite Variable   ${identity_groups}

{% for user in ise.identity_management.internal_users | default([]) %}

Verify Internal User {{ user.name }}
    ${r}=   GET On Session   ISE_Session   /ers/config/internaluser/name/{{user.name}}
    Log   Response Status Code: ${r.status_code}
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $..InternalUser.description  {{ user.description | default('') }}
    Should Be Equal Value Json String   ${r.json()}   $..InternalUser.enabled   {{ user.enabled | default(defaults.ise.identity_management.internal_users.enabled) | default(true)  }}
    Should Be Equal Value Json String   ${r.json()}   $..InternalUser.email   {{ user.email | default('')  }}
    Should Be Equal Value Json String   ${r.json()}   $..InternalUser.accountNameAlias  {{ user.account_name_alias | default('')  }}
    Should Be Equal Value Json String   ${r.json()}   $..InternalUser.firstName   {{ user.first_name | default('')  }}
    Should Be Equal Value Json String   ${r.json()}   $..InternalUser.lastName   {{ user.last_name | default('')  }}
    Should Be Equal Value Json String   ${r.json()}   $..InternalUser.changePassword   {{ user.change_password | default(defaults.ise.identity_management.internal_users.change_password) | default(true)  }}
    Should Be Equal Value Json String   ${r.json()}   $..InternalUser.passwordIDStore   {{ user.password_id_store | default(defaults.ise.identity_management.internal_users.password_id_store) | default('Internal Users')  }}
    ${identity_groups_list}=   Create List
    {% for group in user.user_identity_groups | default([])  %}

    ${identity_group_id}=   Get Value From Json   ${identity_groups}   $.SearchResult.resources[?(@.name=='{{ group }}')]['id']
    Append To List   ${identity_groups_list}   ${identity_group_id}[0]
    {% endfor %}
    ${identity_groups_string} =   Evaluate   ",".join(${identity_groups_list})
    Should Be Equal Value Json String   ${r.json()}   $..InternalUser.identityGroups   ${identity_groups_string}

{% endfor %}