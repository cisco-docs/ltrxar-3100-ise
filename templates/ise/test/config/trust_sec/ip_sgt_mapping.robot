*** Settings ***
Documentation   Verify IP SGT Mappings
Suite Setup     Login ISE
Resource        ../../ise_common.resource
Default Tags    config   ise   trust_sec   ip_sgt_mappings

*** Test Cases ***

Get IP SGT Mappings
    ${r}=   Get All Pages   ISE_Session   /ers/config/sgmapping
    Set Suite Variable   ${r}

Get Security Groups
    ${security_group}=   Get All Pages   ISE_Session   /ers/config/sgt
    Set Suite Variable   ${security_group}

Get IP SGT Mapping Groups 
    ${mapping_group}=   Get All Pages   ISE_Session   /ers/config/sgmappinggroup
    Set Suite Variable   ${mapping_group}

{% for mapping in ise.trust_sec.ip_sgt_mappings | default([]) %}
{% set mapping_key = mapping.host_name | default(mapping.host_ip) %}
Verify IP SGT Mapping {{ mapping_key }}
    ${mapping_id}=   Get Value From Json   ${r}   $.SearchResult.resources[?(@.name=='{{ mapping_key }}')]['id']
    ${r}=   GET On Session   ISE_Session   /ers/config/sgmapping/${mapping_id}[0]
    Should Be Equal Value Json String   ${r.json()}   $.SGMapping.deployType   {{ mapping.deploy_type | default('')  }}
    Should Be Equal Value Json String   ${r.json()}   $.SGMapping.deployTo   {{ mapping.deploy_to | default('') }}
    Should Be Equal Value Json String   ${r.json()}   $.SGMapping.hostIp   {{ mapping.host_ip | default('') }}
    Should Be Equal Value Json String   ${r.json()}   $.SGMapping.hostName   {{ mapping.host_name | default('') }}
{% if mapping.mapping_group | default(false) %}
    ${mapping_group_id}=   Get Value From Json   ${mapping_group}   $.SearchResult.resources[?(@.name=='{{ mapping.mapping_group }}')]['id']
    Should Be Equal Value Json String   ${r.json()}   $.SGMapping.mappingGroup   ${mapping_group_id}[0]
{% endif %}
{% if mapping.sgt | default(false) %}
    ${security_group_id}=   Get Value From Json   ${security_group}   $.SearchResult.resources[?(@.name=='{{ mapping.sgt }}')]['id']
    Should Be Equal Value Json String   ${r.json()}   $.SGMapping.sgt   ${security_group_id}[0]
{% endif %}
{% endfor %}