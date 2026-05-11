# Allowed Protocols

*Location in GUI*:
`Work Centers` » `Network Access` » `Policy Elements` » `Results` » `Allowed Protocols`

{{ doc_gen }}

### Examples

Example-1 Network Access Policy Configuration with Allowed EAP Protocols in Cisco ISE

This example configures Cisco ISE network access policy with detailed allowed EAP protocols and their specific parameters. For EAP-TLS, session ticket lifetime is set to 5 days with 5% session ticket usage. EAP-FAST includes settings for password change retries (3), PAC tunnel PAC TTL of 90 days, proactive PAC update at 90%, and machine PAC TTL of 1 week. Other protocols like EAP-TTLS and TEAP have password change retries configured (1 and 3 respectively). Legacy protocols such as PAP ASCII and EAP-MD5 are allowed, while others like CHAP and MS-CHAP v2 are disabled. EAP-FAST is designated as the preferred EAP protocol, ensuring secure and efficient authentication management within the Cisco SDA environment.

```yaml
ise:
  network_access:
    policy_elements:
      allowed_protocols:
        - name: Global Protocols
          description: Allowed protocols
          eap_tls:
            auth_of_expired_certs: false
            enable_stateless_session_resume: true
            session_ticket_ttl: 5
            session_ticket_ttl_unit: DAYS
            session_ticket_percentage: 5
          eap_fast:
            eap_ms_chap_v2: true
            eap_ms_chap_v2_pwd_change: true
            eap_ms_chap_v2_pwd_change_retries: 3
            eap_gtc: true
            eap_gtc_pwd_change: true
            eap_gtc_pwd_change_retries: 3
            eap_tls: true
            eap_tls_auth_of_expired_certs: false
            use_pacs: true
            use_pacs_tunnel_pac_ttl: 90
            use_pacs_tunnel_pac_ttl_units: DAYS
            use_pacs_use_proactive_pac_update_precentage: 90
            use_pacs_allow_anonym_provisioning: true
            use_pacs_allow_authen_provisioning: true
            use_pacs_accept_client_cert: true
            use_pacs_server_returns: true
            use_pacs_allow_machine_authentication: true
            use_pacs_machine_pac_ttl: 1
            use_pacs_machine_pac_ttl_units: WEEKS
            use_pacs_stateless_session_resume: false
            enable_eap_chaining: false
          eap_ttls:
            pap_ascii: true
            chap: true
            ms_chap_v1: true
            ms_chap_v2: true
            eap_md5: true
            eap_ms_chap_v2: true
            eap_ms_chap_v2_pwd_change: true
            eap_ms_chap_v2_pwd_change_retries: 1
          teap:
            eap_ms_chap_v2: true
            eap_ms_chap_v2_pwd_change: true
            eap_ms_chap_v2_pwd_change_retries: 3
            eap_tls: true
            eap_tls_auth_of_expired_certs: false
            accept_client_cert_during_tunnel_est: true
            enable_eap_chaining: false
            allow_downgrade_msk: true
            request_basic_pwd_auth: false
          process_host_lookup: true
          allow_pap_ascii: true
          allow_chap: false
          allow_ms_chap_v1: false
          allow_ms_chap_v2: false
          allow_eap_md5: true
          allow_leap: false
          allow_eap_tls: true
          allow_eap_ttls: true
          allow_eap_fast: true
          allow_peap: false
          allow_teap: true
          allow_preferred_eap_protocol: true
          preferred_eap_protocol: EAP_FAST
          eap_tls_l_bit: false
          allow_weak_ciphers_for_eap: false
          require_message_auth: false
          five_g: false
```

Example-2  Network Access Allowed Protocols Configuration with Enhanced Security and Session Control

This example demonstrates a Cisco ISE network access policy configuration focused exclusively on EAP-TTLS with multiple inner authentication methods. The configuration enables only EAP-TTLS as the outer authentication protocol, while disabling all other EAP methods including EAP-TLS, EAP-FAST, PEAP, and TEAP. Within the EAP-TTLS tunnel, multiple inner authentication methods are supported: PAP ASCII, CHAP, MS-CHAPv2, and EAP-MS-CHAPv2. EAP-MS-CHAPv2 is configured with password change capability enabled and password change retries set to 3. Security features include message authentication required, weak ciphers disabled, and EAP-TLS L-bit enabled for proper length validation. Legacy insecure protocols such as MS-CHAPv1, EAP-MD5, and LEAP are explicitly disabled. Top-level PAP ASCII and CHAP are disabled, ensuring all authentication occurs within the secure EAP-TTLS tunnel. The configuration does not enable preferred EAP protocol selection, 5G support, or process host lookup, maintaining a streamlined focus on secure tunneled authentication with flexible inner method support for diverse client compatibility.

```yaml
ise:
  network_access:
    policy_elements:
      allowed_protocols:
          - name: EAP-TTLS Multi-Method
            description: EAP-TTLS with PAP and MSCHAPv2 support
            allow_pap_ascii: false
            allow_chap: false
            allow_ms_chap_v1: false
            allow_ms_chap_v2: false
            allow_eap_md5: false
            allow_leap: false
            allow_eap_tls: false
            allow_eap_ttls: true
            allow_eap_fast: false
            allow_peap: false
            allow_teap: false
            eap_tls_l_bit: true
            allow_weak_ciphers_for_eap: false
            require_message_auth: true
            five_g: false
            eap_ttls:
              pap_ascii: true
              chap: true
              ms_chap_v1: false
              ms_chap_v2: true
              eap_md5: false
              eap_ms_chap_v2: true
              eap_ms_chap_v2_pwd_change: true
              eap_ms_chap_v2_pwd_change_retries: 3
```

Example-3 PEAP MSCHAPv2 Corporate Authentication Protocol

This example demonstrates a Cisco ISE network access policy configuration designed for standard corporate 802.1X authentication using PEAP with EAP-MS-CHAPv2. The configuration enables only PEAP as the outer authentication protocol, while disabling all other EAP methods including EAP-TLS, EAP-TTLS, EAP-FAST, and TEAP. The preferred EAP protocol is explicitly set to PEAP. Within the PEAP tunnel, only EAP-MS-CHAPv2 is enabled as the inner authentication method, with password change capability enabled and password change retries set to 3. Alternative inner methods such as EAP-GTC and EAP-TLS are disabled. Security features include cryptobinding required, message authentication required, weak ciphers disabled, and EAP-TLS L-bit enabled for proper length validation. PEAP version 0 is enabled for broad client compatibility. All legacy insecure protocols such as PAP ASCII, CHAP, MS-CHAPv1, MS-CHAPv2, EAP-MD5, and LEAP are explicitly disabled at the top level. Authentication of expired certificates within the PEAP tunnel is disabled. The configuration does not enable 5G support or process host lookup, maintaining a focused and secure authentication profile widely used in enterprise environments for Windows and other corporate endpoints.

``` yaml
ise:
  network_access:
    policy_elements:
      allowed_protocols:
          - name: PEAP MSCHAPv2
            description: Standard PEAP configuration for corporate networks
            allow_pap_ascii: false
            allow_chap: false
            allow_ms_chap_v1: false
            allow_ms_chap_v2: false
            allow_eap_md5: false
            allow_leap: false
            allow_eap_tls: false
            allow_eap_ttls: false
            allow_eap_fast: false
            allow_peap: true
            allow_teap: false
            allow_preferred_eap_protocol: true
            preferred_eap_protocol: PEAP
            eap_tls_l_bit: true
            allow_weak_ciphers_for_eap: false
            require_message_auth: true
            five_g: false
            peap:
              eap_ms_chap_v2: true
              eap_ms_chap_v2_pwd_change: true
              eap_ms_chap_v2_pwd_change_retries: 3
              eap_gtc: false
              eap_gtc_pwd_change: false
              eap_gtc_pwd_change_retries: 0
              eap_tls: false
              eap_tls_auth_of_expired_certs: false
              require_cryptobinding: true
              peap_v0: true
```