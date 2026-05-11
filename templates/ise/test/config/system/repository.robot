*** Settings ***
Documentation   Verify System Repositories
Suite Setup     Login ISE
Resource        ../../ise_common.resource
Default Tags    config   ise   system   repositories

*** Test Cases ***

Get System Repositories
    ${r}=   GET On Session   ISE_Session   /api/v1/repository
    Log   Response Status Code: ${r.status_code}
    Set Suite Variable   ${r}

{% for repo in ise.system.repositories | default([]) %}
Verify System Repository {{ repo.name }}
    ${repo}=   Get Value From Json   ${r.json()}   $.response[?(@.name=='{{ repo.name }}')]
    Should Be Equal Value Json String   ${repo}[0]   protocol   {{ repo.protocol }}
    Should Be Equal Value Json String   ${repo}[0]   path   {{ repo.path }}
{% if repo.protocol in ['FTP', 'SFTP', 'TFTP', 'NFS', 'HTTP', 'HTTPS'] %}
    Should Be Equal Value Json String   ${repo}[0]   serverName   {{ repo.server_name }}
{% if repo.protocol in ['FTP', 'SFTP'] %}
    Should Be Equal Value Json String   ${repo}[0]   userName   {{ repo.user_name }}
{% if repo.protocol == 'SFTP' %}
    Should Be Equal Value Json String   ${repo}[0]   enablePki   {{ repo.enable_pki }}
{% endif %}
{% endif %}
{% endif %}
{% endfor %}