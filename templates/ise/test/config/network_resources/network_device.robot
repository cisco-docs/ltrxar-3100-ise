*** Settings ***
Documentation   Verify Network Resources Network Devices
Suite Setup     Login ISE
Resource        ../../ise_common.resource
Default Tags    config   ise   network_resources   network_devices

*** Test Cases ***

{% for network_device in ise.network_resources.network_devices | default([]) %}
Verify Network Resource Device {{ network_device.name }}
    ${r}=   GET On Session   ISE_Session   /ers/config/networkdevice/name/{{ network_device.name }}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDevice.description   {{ network_device.description | default(defaults.ise.network_resources.network_device_groups.description, true) | default('') }}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDevice.profileName   {{ network_device.profile_name | default(defaults.ise.network_resources.network_devices.profile_name, true) | default('') }}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDevice.modelName   {{ network_device.model_name | default('') }}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDevice.softwareVersion   {{ network_device.software_version | default('') }}
{% if network_device.radius | default(false) %}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDevice.authenticationSettings.networkProtocol   {{ network_device.authentication_network_protocol }}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDevice.authenticationSettings.radiusSharedSecret   {{ network_device.radius.shared_secret }}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDevice.authenticationSettings.secondRadiusSharedSecret   {{ network_device.radius.second_shared_secret | default('') }}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDevice.coaPort   {{ network_device.radius.coa_port | default(defaults.ise.network_resources.network_devices.radius.coa_port, true) | default('') }}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDevice.authenticationSettings.dtlsRequired    {{ network_device.radius.dtls_required | default(defaults.ise.network_resources.network_devices.radius.dtls_required) | default(false) }}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDevice.dtlsDnsName    {{ network_device.radius.dtls_dns_name | default('') }}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDevice.authenticationSettings.enableKeyWrap    {{ network_device.radius.enable_key_wrap | default(defaults.ise.network_resources.network_devices.radius.enable_key_wrap) | default(false) }}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDevice.authenticationSettings.keyEncryptionKey    {{ network_device.radius.encryption_key | default('') }}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDevice.authenticationSettings.keyInputFormat    {{ network_device.radius.encryption_key_format | default(defaults.ise.network_resources.network_devices.radius.encryption_key_format, true) | default('') }}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDevice.authenticationSettings.messageAuthenticatorCodeKey    {{ network_device.radius.message_authenticator_code_key | default('') }}
{% endif %}
{% if network_device.snmp | default(false) %}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDevice.snmpsettings.version   {{ network_device.snmp.version }}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDevice.snmpsettings.roCommunity   {{ network_device.snmp.ro_community }}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDevice.snmpsettings.pollingInterval   {{ network_device.snmp.polling_interval | default(defaults.ise.network_resources.network_devices.snmp.polling_interval, true) | default('') }}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDevice.snmpsettings.originatingPolicyServicesNode   {{ network_device.snmp.originating_policy_services_node | default(defaults.ise.network_resources.network_devices.snmp.originating_policy_services_node, true) | default('') }}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDevice.snmpsettings.macTrapQuery   {{ network_device.snmp.mac_trap_query | default(defaults.ise.network_resources.network_devices.snmp.mac_trap_query) | default(false) }}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDevice.snmpsettings.linkTrapQuery   {{ network_device.snmp.link_trap_query | default(defaults.ise.network_resources.network_devices.snmp.link_trap_query) | default(false) }}
{% endif %}
{% if network_device.trust_sec | default(false) %}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDevice.trustsecsettings.deviceAuthenticationSettings.sgaDeviceId   {{ network_device.trust_sec.device_id }}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDevice.trustsecsettings.deviceAuthenticationSettings.sgaDevicePassword   {{ network_device.trust_sec.device_password }}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDevice.trustsecsettings.deviceAuthenticationSettings.restApiUsername   {{ network_device.trust_sec.rest_api_username }}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDevice.trustsecsettings.sgaNotificationAndUpdates.downlaodEnvironmentDataEveryXSeconds   {{ network_device.trust_sec.download_environment_data_every_x_seconds | default(defaults.ise.network_resources.network_devices.trust_sec.download_environment_data_every_x_seconds, true) | default('') }}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDevice.trustsecsettings.sgaNotificationAndUpdates.downlaodPeerAuthorizationPolicyEveryXSeconds   {{ network_device.trust_sec.download_peer_authorization_policy_every_x_seconds | default(defaults.ise.network_resources.network_devices.trust_sec.download_peer_authorization_policy_every_x_seconds, true) | default('') }}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDevice.trustsecsettings.sgaNotificationAndUpdates.reAuthenticationEveryXSeconds   {{ network_device.trust_sec.re_authentication_every_x_seconds | default(defaults.ise.network_resources.network_devices.trust_sec.re_authentication_every_x_seconds, true) | default('') }}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDevice.trustsecsettings.sgaNotificationAndUpdates.downloadSGACLListsEveryXSeconds   {{ network_device.trust_sec.download_sgacl_lists_every_x_seconds | default(defaults.ise.network_resources.network_devices.trust_sec.download_sgacl_lists_every_x_seconds, true) | default('') }}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDevice.trustsecsettings.sgaNotificationAndUpdates.otherSGADevicesToTrustThisDevice   {{ network_device.trust_sec.other_sga_devices_to_trust_this_device | default(defaults.ise.network_resources.network_devices.trust_sec.other_sga_devices_to_trust_this_device) | default(false) }}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDevice.trustsecsettings.sgaNotificationAndUpdates.sendConfigurationToDevice   {{ network_device.trust_sec.send_configuration_to_device | default(defaults.ise.network_resources.network_devices.trust_sec.send_configuration_to_device) | default(false) }}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDevice.trustsecsettings.sgaNotificationAndUpdates.sendConfigurationToDeviceUsing   {{ network_device.trust_sec.send_configuration_to_device_using | default(defaults.ise.network_resources.network_devices.trust_sec.send_configuration_to_device_using, true) | default('') }}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDevice.trustsecsettings.sgaNotificationAndUpdates.coaSourceHost   {{ network_device.trust_sec.coa_source_host | default(defaults.ise.network_resources.network_devices.trust_sec.coa_source_host, true) | default('') }}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDevice.trustsecsettings.deviceConfigurationDeployment.includeWhenDeployingSGTUpdates   {{ network_device.trust_sec.include_when_deploying_sgt_updates | default(defaults.ise.network_resources.network_devices.trust_sec.include_when_deploying_sgt_updates) | default(false) }}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDevice.trustsecsettings.deviceConfigurationDeployment.execModeUsername   {{ network_device.trust_sec.exec_mode_username }}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDevice.trustsecsettings.deviceConfigurationDeployment.execModePassword   {{ network_device.trust_sec.exec_mode_password }}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDevice.trustsecsettings.deviceConfigurationDeployment.enableModePassword   {{ network_device.trust_sec.enable_mode_password }}
{% endif %}
{% if network_device.tacacs | default(false) %}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDevice.tacacsSettings.connectModeOptions   {{ network_device.tacacs.connect_mode_options | default(defaults.ise.network_resources.network_devices.tacacs.connect_mode_options, true) | default('') }}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDevice.tacacsSettings.sharedSecret   {{ network_device.tacacs.shared_secret }}
{% endif %}
{% for ip_item in network_device.ips | default([]) %}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDevice.NetworkDeviceIPList[{{loop.index0}}].ipaddress   {{ ip_item.ip }}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDevice.NetworkDeviceIPList[{{loop.index0}}].ipaddressExclude   {{ ip_item.ip_exclude | default('') }}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDevice.NetworkDeviceIPList[{{loop.index0}}].mask   {{ ip_item.mask | default(defaults.ise.network_resources.network_devices.ips.mask, true) | default('') }}
{% endfor %}
{% if network_device.network_device_groups | default(false) %}
    ${network_device_groups}=   Create List
{% for network_group in network_device.network_device_groups %}
{% if 'Is IPSEC Device' in network_group %}
{% set concat_str = 'IPSEC' ~ '#' ~ network_group %}
{% elif 'All Locations' in network_group %}
{% set concat_str = 'Location' ~ '#' ~ network_group %}
{% elif 'All Device Types' in network_group%}
{% set concat_str = 'Device Type' ~ '#' ~ network_group %}
{% elif 'DNAC#DNAC Devices' in network_group%}
{% set concat_str = network_group %}
{% elif network_group.split('#')[0] == network_group %}
{% set concat_str = network_group.split('#')[0] %}
{% else %}
{% set concat_str = network_group.split('#')[0] ~ '#' ~ network_group %}
{% endif %}
    Append To List   ${network_device_groups}   {{ concat_str }}
{% endfor %}
    Should Be Equal Value Json List   ${r.json()}   $.NetworkDevice.NetworkDeviceGroupList   ${network_device_groups}
{% endif %}
{% endfor %}