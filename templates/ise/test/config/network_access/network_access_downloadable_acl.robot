*** Settings ***
Documentation   Verify Network Access Downloadable ACLs
Suite Setup     Login ISE
Resource        ../../ise_common.resource
Default Tags    config   ise   network_access   policy_elements   downloadable_acls

*** Test Cases ***

{% for acl in ise.network_access.policy_elements.downloadable_acls | default([]) %}

Verify Network Access Downloadable ACL {{ acl.name }}
   ${r}=   GET On Session   ISE_Session   /ers/config/downloadableacl/name/{{acl.name}}
   Log   Response Status Code: ${r.status_code}
   Set Suite Variable   ${r}
   Should Be Equal Value Json String   ${r.json()}   $.DownloadableAcl.description   {{ acl.description | default('') }}
   Should Be Equal Value Json String   ${r.json()}   $.DownloadableAcl.dacl   {{ acl.dacl_content }}
   Should Be Equal Value Json String   ${r.json()}   $.DownloadableAcl.daclType   {{ acl.dacl_type | default(defaults.ise.network_access.policy_elements.downloadable_acls.dacl_type) | default('IPV4') }}

{% endfor %}