*** Settings ***
Documentation   Verify IP SGT Mapping Groups
Suite Setup     Login ISE
Resource        ../../ise_common.resource
Default Tags    config   ise   trust_sec   ip_sgt_mapping_groups

*** Test Cases ***

Get IP SGT Mapping Groups
    ${r}=   Get All Pages   ISE_Session   /ers/config/sgmappinggroup
    Set Suite Variable   ${r}

Get Security Groups
    ${security_group}=   Get All Pages   ISE_Session   /ers/config/sgt
    Set Suite Variable   ${security_group}

{% for group in ise.trust_sec.ip_sgt_mapping_groups | default([]) %}
Verify IP SGT Mapping Group {{ group.name }}
    ${group_id}=   Get Value From Json   ${r}   $.SearchResult.resources[?(@.name=='{{ group.name }}')]['id']
    ${security_group_id}=   Get Value From Json   ${security_group}   $.SearchResult.resources[?(@.name=='{{ group.sgt }}')]['id']
    ${r}=   GET On Session   ISE_Session   /ers/config/sgmappinggroup/${group_id}[0]
    Should Be Equal Value Json String   ${r.json()}   $.SGMappingGroup.deployType   {{ group.deploy_type | default(defaults.ise.trust_sec.ip_sgt_mapping_groups.deploy_type) | default('ALL') }}
    Should Be Equal Value Json String   ${r.json()}   $.SGMappingGroup.deployTo   {{ group.deploy_to | default('') }}
    Should Be Equal Value Json String   ${r.json()}   $.SGMappingGroup.sgt   ${security_group_id}[0]
{% endfor %}