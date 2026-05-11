*** Settings ***
Documentation   Verify TrustSec Matrix Entries
Suite Setup     Login ISE
Resource        ../../ise_common.resource
Default Tags    config   ise   trust_sec   matrix_entries

*** Test Cases ***

Get TrustSect Matrix Entries
    ${r}=   Get All Pages   ISE_Session   /ers/config/egressmatrixcell
    Set Suite Variable   ${r}

Get Security Groups
    ${security_group}=   Get All Pages   ISE_Session   /ers/config/sgt
    Set Suite Variable   ${security_group}

Get Security Groups ACLs
    ${security_group_acl}=   Get All Pages   ISE_Session   /ers/config/sgacl
    Set Suite Variable   ${security_group_acl}

{% for matrix_entry in ise.trust_sec.matrix_entries | default([]) %}
{% set entry_name = matrix_entry.source_sgt ~ '-' ~ matrix_entry.destination_sgt %}
Verify TrustSect Matrix Entry {{ entry_name }}
    ${entry_id}=   Get Value From Json   ${r}   $.SearchResult.resources[?(@.name=='{{ entry_name }}')]['id']
    ${source_sgt_id}=   Get Value From Json   ${security_group}   $.SearchResult.resources[?(@.name=='{{ matrix_entry.source_sgt }}')]['id']
    ${destination_sgt_id}=   Get Value From Json   ${security_group}   $.SearchResult.resources[?(@.name=='{{ matrix_entry.destination_sgt }}')]['id']  
    ${sgacl_id}=   Get Value From Json   ${security_group_acl}   $.SearchResult.resources[?(@.name=='{{ matrix_entry.sgacl_name }}')]['id']  
    ${r}=   GET On Session   ISE_Session   /ers/config/egressmatrixcell/${entry_id}[0]
    Should Be Equal Value Json String   ${r.json()}   $.EgressMatrixCell.sourceSgtId   ${source_sgt_id}[0]
    Should Be Equal Value Json String   ${r.json()}   $.EgressMatrixCell.destinationSgtId   ${destination_sgt_id}[0]
    Should Be Equal Value Json String   ${r.json()}   $.EgressMatrixCell.matrixCellStatus   {{ matrix_entry.rule_status | default(defaults.ise.trust_sec.matrix_entries.rule_status) | default('ENABLED') }}
    Should Be Equal Value Json String   ${r.json()}   $.EgressMatrixCell.sgacls[0]   ${sgacl_id}[0]
{% endfor %}