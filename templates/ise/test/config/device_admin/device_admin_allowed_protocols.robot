*** Settings ***
Documentation   Verify Device Admin Allowed Protocols
Suite Setup     Login ISE
Resource        ../../ise_common.resource
Default Tags    config   ise   device_administration   policy_elements   allowed_protocols

*** Test Cases ***

{% for proto in ise.device_administration.policy_elements.allowed_protocols | default([]) %}
Verify Device Admin Allowed Protocols {{ proto.name }}
    ${r}=   GET On Session   ISE_Session   /ers/config/allowedprotocols/name/{{proto.name}}
    Log   Response Status Code: ${r.status_code}
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.description   {{ proto.description | default('') }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.allowPapAscii   {{ proto.allow_pap_ascii | default('')  }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.allowChap   {{ proto.allow_chap | default(false)  }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.allowMsChapV1   {{ proto.allow_ms_chap_v1 | default(false)  }}
{% endfor %}
