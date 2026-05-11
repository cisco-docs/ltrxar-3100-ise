*** Settings ***
Documentation   Verify Identity Source Sequences
Suite Setup     Login ISE
Resource        ../../ise_common.resource
Default Tags    config   ise   identity_management   identity_source_sequences

*** Test Cases ***

{% for identity_source_seq in ise.identity_management.identity_source_sequences | default([]) %}

Verify Identity Source Sequence {{ identity_source_seq.name }}
   ${r}=   GET On Session   ISE_Session   /ers/config/idstoresequence/name/{{identity_source_seq.name}}
   Log   Response Status Code: ${r.status_code}
   Set Suite Variable   ${r}
   Should Be Equal Value Json String   ${r.json()}   $..IdStoreSequence.description   {{ identity_source_seq.description }}
   Should Be Equal Value Json String   ${r.json()}   $..IdStoreSequence.certificateAuthenticationProfile   {{ identity_source_seq.certificate_authentication_profile }}
   Should Be Equal Value Json String   ${r.json()}   $..IdStoreSequence.breakOnStoreFail   {{ identity_source_seq.break_on_store_fail }}
{% for idstore in identity_source_seq.identity_sources %}
   Should Be Equal Value Json String   ${r.json()}   $..IdStoreSequence.idSeqItem[{{loop.index0}}].idstore   {{ idstore }}
{% endfor %}

{% endfor %}