*** Settings ***
Documentation   Verify Network Access Allowed Protocols
Suite Setup     Login ISE
Resource        ../../ise_common.resource
Default Tags    config   ise   network_access   policy_elements   allowed_protocols

*** Test Cases ***

{% for proto in ise.network_access.policy_elements.allowed_protocols | default([]) %}

Verify Network Access Allowed Protocols {{ proto.name }}
    ${r}=   GET On Session   ISE_Session   /ers/config/allowedprotocols/name/{{proto.name}}
    Log   Response Status Code: ${r.status_code}
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.description   {{ proto.description | default(defaults.ise.network_resources.network_device_groups.description) | default('')  }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.processHostLookup   {{ proto.process_host_lookup | default(defaults.ise.network_access.policy_elements.allowed_protocols.process_host_lookup) | default(true)  }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.allowPapAscii   {{ proto.allow_pap_ascii | default(defaults.ise.network_access.policy_elements.allowed_protocols.allow_pap_ascii) | default(true)  }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.allowChap   {{ proto.allow_chap | default(defaults.ise.network_access.policy_elements.allowed_protocols.allow_chap) | default(false)  }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.allowMsChapV1   {{ proto.allow_ms_chap_v1 | default(defaults.ise.network_access.policy_elements.allowed_protocols.allow_ms_chap_v1) | default(false)  }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.allowMsChapV2   {{ proto.allow_ms_chap_v2 | default(defaults.ise.network_access.policy_elements.allowed_protocols.allow_ms_chap_v2) | default(false)  }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.allowEapMd5   {{ proto.allow_eap_md5 | default(defaults.ise.network_access.policy_elements.allowed_protocols.allow_eap_md5) | default(true)  }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.allowLeap   {{ proto.allow_leap | default(defaults.ise.network_access.policy_elements.allowed_protocols.allow_leap) | default(false)  }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.allowEapTls   {{ proto.allow_eap_tls | default(defaults.ise.network_access.policy_elements.allowed_protocols.allow_eap_tls) | default(true)  }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.allowEapTtls   {{ proto.allow_eap_ttls | default(defaults.ise.network_access.policy_elements.allowed_protocols.allow_eap_ttls) | default(true)  }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.allowEapFast   {{ proto.allow_eap_fast | default(defaults.ise.network_access.policy_elements.allowed_protocols.allow_eap_fast) | default(true) }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.allowPeap   {{ proto.allow_peap | default(defaults.ise.network_access.policy_elements.allowed_protocols.allow_peap) | default(true)  }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.allowTeap   {{ proto.allow_teap | default(defaults.ise.network_access.policy_elements.allowed_protocols.allow_teap) | default(true)  }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.allowPreferredEapProtocol   {{ proto.allow_preferred_eap_protocol | default(defaults.ise.network_access.policy_elements.allowed_protocols.allow_preferred_eap_protocol) | default(false)  }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.eapTlsLBit   {{ proto.eap_tls_l_bit | default(defaults.ise.network_access.policy_elements.allowed_protocols.eap_tls_l_bit) | default(false)  }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.allowWeakCiphersForEap   {{ proto.allow_weak_ciphers_for_eap | default(defaults.ise.network_access.policy_elements.allowed_protocols.allow_weak_ciphers_for_eap) | default(false)  }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.fiveG   {{ proto.five_g | default(defaults.ise.network_access.policy_elements.allowed_protocols.five_g) | default(false)  }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.requireMessageAuth   {{ proto.require_message_auth | default(defaults.ise.network_access.policy_elements.allowed_protocols.require_message_auth) | default(false)  }}
{% if proto.allow_eap_tls| default(false)  %}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.eapTls.allowEapTlsAuthOfExpiredCerts   {{ proto.eap_tls.auth_of_expired_certs | default(defaults.ise.network_access.policy_elements.allowed_protocols.eap_tls.auth_of_expired_certs) | default(false) }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.eapTls.eapTlsEnableStatelessSessionResume   {{ proto.eap_tls.enable_stateless_session_resume | default(defaults.ise.network_access.policy_elements.allowed_protocols.eap_tls.enable_stateless_session_resume) | default(false) }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.eapTls.eapTlsSessionTicketTtl   {{ proto.eap_tls.session_ticket_ttl | default('') }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.eapTls.eapTlsSessionTicketTtlUnits   {{ proto.eap_tls.session_ticket_ttl_units | default('') }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.eapTls.eapTlsSessionTicketTtlPercentage   {{ proto.eap_tls.session_ticket_ttl_percentage | default('') }}
{% endif %}
{% if proto.allow_teap | default(false)  %}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.teap.allowTeapEapMsChapV2   {{ proto.teap.eap_ms_chap_v2 | default(defaults.ise.network_access.policy_elements.allowed_protocols.teap.eap_ms_chap_v2) | default(true) }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.teap.allowTeapEapMsChapV2PwdChange   {{ proto.teap.eap_ms_chap_v2_pwd_change | default(defaults.ise.network_access.policy_elements.allowed_protocols.teap.eap_ms_chap_v2_pwd_change) | default(true) }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.teap.allowTeapEapMsChapV2PwdChangeRetries   {{ proto.teap.eap_ms_chap_v2_pwd_change_retries | default(defaults.ise.network_access.policy_elements.allowed_protocols.teap.eap_ms_chap_v2_pwd_change_retries) | default(3) }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.teap.allowTeapEapTls   {{ proto.teap.eap_tls | default(defaults.ise.network_access.policy_elements.allowed_protocols.teap.eap_tls) | default(true) }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.teap.allowTeapEapTlsAuthOfExpiredCerts   {{ proto.teap.eap_tls_auth_of_expired_certs | default(defaults.ise.network_access.policy_elements.allowed_protocols.teap.eap_tls_auth_of_expired_certs) | default(false) }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.teap.acceptClientCertDuringTunnelEst   {{ proto.teap.accept_client_cert_during_tunnel_est | default(defaults.ise.network_access.policy_elements.allowed_protocols.teap.accept_client_cert_during_tunnel_est) | default(true) }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.teap.enableEapChaining   {{ proto.teap.enable_eap_chaining | default(defaults.ise.network_access.policy_elements.allowed_protocols.teap.enable_eap_chaining) | default(false) }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.teap.allowDowngradeMsk   {{ proto.teap.allow_downgrade_msk | default(defaults.ise.network_access.policy_elements.allowed_protocols.teap.allow_downgrade_msk) | default(true) }}
{% endif %}
{% if proto.allow_eap_ttls | default(false)  %}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.eapTtls.eapTtlsPapAscii   {{ proto.eap_ttls.pap_ascii | default(defaults.ise.network_access.policy_elements.allowed_protocols.eap_ttls.pap_ascii) | default(true) }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.eapTtls.eapTtlsChap   {{ proto.eap_ttls.chap | default(defaults.ise.network_access.policy_elements.allowed_protocols.eap_ttls.chap) | default(true) }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.eapTtls.eapTtlsMsChapV1   {{ proto.eap_ttls.ms_chap_v1 | default(defaults.ise.network_access.policy_elements.allowed_protocols.eap_ttls.ms_chap_v1) | default(true) }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.eapTtls.eapTtlsMsChapV2   {{ proto.eap_ttls.ms_chap_v2 | default(defaults.ise.network_access.policy_elements.allowed_protocols.eap_ttls.ms_chap_v2) | default(true) }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.eapTtls.eapTtlsEapMd5   {{ proto.eap_ttls.eap_md5 | default(defaults.ise.network_access.policy_elements.allowed_protocols.eap_ttls.eap_md5) | default(true) }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.eapTtls.eapTtlsEapMsChapV2   {{ proto.eap_ttls.eap_ms_chap_v2 | default(defaults.ise.network_access.policy_elements.allowed_protocols.eap_ttls.eap_ms_chap_v2) | default(true) }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.eapTtls.eapTtlsEapMsChapV2PwdChange   {{ proto.eap_ttls.eap_ms_chap_v2_pwd_change | default(defaults.ise.network_access.policy_elements.allowed_protocols.eap_ttls.eap_ms_chap_v2_pwd_change) | default(true) }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.eapTtls.eapTtlsEapMsChapV2PwdChangeRetries   {{ proto.eap_ttls.eap_ms_chap_v2_pwd_change_retries | default(defaults.ise.network_access.policy_elements.allowed_protocols.eap_ttls.eap_ms_chap_v2_pwd_change_retries) | default(1) }}
{% endif %}
{% if proto.allow_eap_fast | default(false)  %}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.eapFast.allowEapFastEapMsChapV2   {{ proto.eap_fast.eap_ms_chap_v2 | default(defaults.ise.network_access.policy_elements.allowed_protocols.eap_fast.eap_ms_chap_v2) | default(true) }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.eapFast.allowEapFastEapMsChapV2PwdChange   {{ proto.eap_fast.eap_ms_chap_v2_pwd_change | default(defaults.ise.network_access.policy_elements.allowed_protocols.eap_fast.eap_ms_chap_v2_pwd_change) | default(true) }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.eapFast.allowEapFastEapMsChapV2PwdChangeRetries   {{ proto.eap_fast.eap_ms_chap_v2_pwd_change_retries | default(defaults.ise.network_access.policy_elements.allowed_protocols.eap_fast.eap_ms_chap_v2_pwd_change_retries) | default(1) }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.eapFast.allowEapFastEapGtc   {{ proto.eap_fast.eap_gtc | default(defaults.ise.network_access.policy_elements.allowed_protocols.eap_fast.eap_gtc) | default(true) }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.eapFast.allowEapFastEapGtcPwdChange   {{ proto.eap_fast.eap_gtc_pwd_change | default(defaults.ise.network_access.policy_elements.allowed_protocols.eap_fast.eap_gtc_pwd_change) | default(true) }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.eapFast.allowEapFastEapGtcPwdChangeRetries   {{ proto.eap_fast.eap_gtc_pwd_change_retries | default(defaults.ise.network_access.policy_elements.allowed_protocols.eap_fast.eap_gtc_pwd_change_retries) | default(1) }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.eapFast.allowEapFastEapTls   {{ proto.eap_fast.eap_tls | default(defaults.ise.network_access.policy_elements.allowed_protocols.eap_fast.eap_tls) | default(true) }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.eapFast.allowEapFastEapTlsAuthOfExpiredCerts   {{ proto.eap_fast.eap_tls_auth_of_expired_certs | default(defaults.ise.network_access.policy_elements.allowed_protocols.eap_fast.eap_tls_auth_of_expired_certs) | default(false) }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.eapFast.eapFastUsePacs   {{ proto.eap_fast.use_pacs | default(defaults.ise.network_access.policy_elements.allowed_protocols.eap_fast.use_pacs) | default(true) }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.eapFast.eapFastUsePacsTunnelPacTtl   {{ proto.eap_fast.use_pacs_tunnel_pac_ttl | default(defaults.ise.network_access.policy_elements.allowed_protocols.eap_fast.use_pacs_tunnel_pac_ttl) | default(90) }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.eapFast.eapFastUsePacsTunnelPacTtlUnits   {{ proto.eap_fast.use_pacs_tunnel_pac_ttl_units | default(defaults.ise.network_access.policy_elements.allowed_protocols.eap_fast.use_pacs_tunnel_pac_ttl_units) | default('DAYS') }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.eapFast.eapFastUsePacsUseProactivePacUpdatePrecentage   {{ proto.eap_fast.use_pacs_use_proactive_pac_update_precentage | default(defaults.ise.network_access.policy_elements.allowed_protocols.eap_fast.use_pacs_use_proactive_pac_update_precentage) | default(10) }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.eapFast.eapFastUsePacsAllowAnonymProvisioning   {{ proto.eap_fast.use_pacs_allow_anonym_provisioning | default(defaults.ise.network_access.policy_elements.allowed_protocols.eap_fast.use_pacs_allow_anonym_provisioning) | default(false) }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.eapFast.eapFastUsePacsAllowAuthenProvisioning   {{ proto.eap_fast.use_pacs_allow_authen_provisioning | default(defaults.ise.network_access.policy_elements.allowed_protocols.eap_fast.use_pacs_allow_authen_provisioning) | default(false) }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.eapFast.eapFastUsePacsServerReturns   {{ proto.eap_fast.use_pacs_server_returns | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.eapFast.eapFastUsePacsAcceptClientCert   {{ proto.eap_fast.use_pacs_accept_client_cert | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.eapFast.eapFastUsePacsAllowMachineAuthentication   {{ proto.eap_fast.use_pacs_allow_machine_authentication | default(defaults.ise.network_access.policy_elements.allowed_protocols.eap_fast.use_pacs_allow_machine_authentication) | default(false) }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.eapFast.eapFastUsePacsMachinePacTtl   {{ proto.eap_fast.use_pacs_machine_pac_ttl | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.eapFast.eapFastUsePacsMachinePacTtlUnits   {{ proto.eap_fast.use_pacs_machine_pac_ttl_units | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.eapFast.eapFastUsePacsStatelessSessionResume   {{ proto.eap_fast.use_pacs_stateless_session_resume | default(defaults.ise.network_access.policy_elements.allowed_protocols.eap_fast.use_pacs_stateless_session_resume) | default(false) }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.eapFast.eapFastEnableEAPChaining   {{ proto.eap_fast.enable_eap_chaining | default(defaults.ise.network_access.policy_elements.allowed_protocols.eap_fast.enable_eap_chaining) | default(false) }}
{% endif %}
{% if proto.allow_peap | default(false)  %}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.peap.allowPeapEapMsChapV2   {{ proto.peap.eap_ms_chap_v2 | default(defaults.ise.network_access.policy_elements.allowed_protocols.peap.eap_ms_chap_v2) | default(true) }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.peap.allowPeapEapMsChapV2PwdChange   {{ proto.peap.eap_ms_chap_v2_pwd_change | default(defaults.ise.network_access.policy_elements.allowed_protocols.peap.eap_ms_chap_v2_pwd_change) | default(true) }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.peap.allowPeapEapMsChapV2PwdChangeRetries   {{ proto.peap.eap_ms_chap_v2_pwd_change_retries | default(defaults.ise.network_access.policy_elements.allowed_protocols.peap.eap_ms_chap_v2_pwd_change_retries) | default(1) }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.peap.allowPeapEapGtc   {{ proto.peap.eap_gtc | default(defaults.ise.network_access.policy_elements.allowed_protocols.peap.eap_gtc) | default(false) }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.peap.allowPeapEapGtcPwdChange   {{ proto.peap.eap_gtc_pwd_change | default(defaults.ise.network_access.policy_elements.allowed_protocols.peap.eap_gtc_pwd_change) | default(false) }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.peap.allowPeapEapGtcPwdChangeRetries   {{ proto.peap.eap_gtc_pwd_change_retries | default(defaults.ise.network_access.policy_elements.allowed_protocols.peap.eap_gtc_pwd_change_retries) | default(1) }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.peap.allowPeapEapTls   {{ proto.peap.eap_tls | default(defaults.ise.network_access.policy_elements.allowed_protocols.peap.eap_tls) | default(true) }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.peap.allowPeapEapTlsAuthOfExpiredCerts   {{ proto.peap.eap_tls_auth_of_expired_certs | default(defaults.ise.network_access.policy_elements.allowed_protocols.peap.eap_tls_auth_of_expired_certs) | default(false) }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.peap.requireCryptobinding   {{ proto.peap.require_cryptobinding | default(defaults.ise.network_access.policy_elements.allowed_protocols.peap.require_cryptobinding) | default(false) }}
    Should Be Equal Value Json String   ${r.json()}   $..AllowedProtocols.peap.allowPeapV0   {{ proto.peap.peap_v0 | default(defaults.ise.network_access.policy_elements.allowed_protocols.peap.peap_v0) | default(false) }}
{% endif %}

{% endfor %}