*** Settings ***
Documentation   Verify Security Groups ACLs
Suite Setup     Login ISE
Resource        ../../ise_common.resource
Default Tags    config   ise   trust_sec   security_group_acls

*** Test Cases ***

Get Security Groups ACLs
    ${r}=   Get All Pages   ISE_Session   /ers/config/sgacl
    Set Suite Variable   ${r}
{% for acl in ise.trust_sec.security_group_acls | default([]) %}
Verify Security Group ACL {{ acl.name }}
    ${acl_id}=   Get Value From Json   ${r}   $.SearchResult.resources[?(@.name=='{{ acl.name }}')]['id']
    ${r}=   GET On Session   ISE_Session   /ers/config/sgacl/${acl_id}[0]
    Should Be Equal Value Json String   ${r.json()}   $.Sgacl.description   {{ acl.description | default('') }}
{% if acl.ip_version | default(false) != 'IP_AGNOSTIC' %}
    Should Be Equal Value Json String   ${r.json()}   $.Sgacl.ipVersion   {{ acl.ip_version | default(defaults.ise.trust_sec.security_group_acls.ip_version) | default('IPV4') }}
{% endif %}
    Should Be Equal Value Json String   ${r.json()}   $.Sgacl.aclcontent   {{ acl.acl_content }}
{% endfor %}