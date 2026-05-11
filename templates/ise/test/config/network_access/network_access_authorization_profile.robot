*** Settings ***
Documentation   Verify Network Access Authorization Profile
Suite Setup     Login ISE
Resource        ../../ise_common.resource
Default Tags    config   ise   network_access   policy_elements   authorization_profiles

*** Test Cases ***

{% for profile in ise.network_access.policy_elements.authorization_profiles | default([]) %}

Verify Authorization Profiles {{ profile.name }}
    ${r}=   GET On Session   ISE_Session   /ers/config/authorizationprofile/name/{{profile.name}}
    Log   Response Status Code: ${r.status_code}
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $.AuthorizationProfile.description   {{ profile.description | default('')  }}
    Should Be Equal Value Json String   ${r.json()}   $.AuthorizationProfile.accessType   {{ profile.access_type | default(defaults.ise.network_access.policy_elements.authorization_profiles.access_type) | default('ACCESS_ACCEPT')  }}
    Should Be Equal Value Json String   ${r.json()}   $.AuthorizationProfile.trackMovement   {{ profile.track_movement | default(defaults.ise.network_access.policy_elements.authorization_profiles.track_movement) | default(false)  }}
    Should Be Equal Value Json String   ${r.json()}   $.AuthorizationProfile.agentlessPosture   {{ profile.agentless_posture | default(defaults.ise.network_access.policy_elements.authorization_profiles.agentless_posture) | default(false)  }}
    Should Be Equal Value Json String   ${r.json()}   $.AuthorizationProfile.serviceTemplate   {{ profile.service_template | default(defaults.ise.network_access.policy_elements.authorization_profiles.service_template) | default(false)  }}
    Should Be Equal Value Json String   ${r.json()}   $.AuthorizationProfile.easywiredSessionCandidate   {{ profile.easywired_session_candidate | default(defaults.ise.network_access.policy_elements.authorization_profiles.easywired_session_candidate) | default(false)  }}
    Should Be Equal Value Json String   ${r.json()}   $.AuthorizationProfile.profileName   {{ profile.profile_name | default('Cisco')  }}
    Should Be Equal Value Json String   ${r.json()}   $.AuthorizationProfile.daclName   {{ profile.dacl_name | default('')  }}
    Should Be Equal Value Json String   ${r.json()}   $.AuthorizationProfile.ipv6DaclName   {{ profile.ipv6_dacl_name | default('')  }}
    Should Be Equal Value Json String   ${r.json()}   $.AuthorizationProfile.reauth.timer   {{ profile.reauthentication_timer | default('')  }}
    Should Be Equal Value Json String   ${r.json()}   $.AuthorizationProfile.reauth.connectivity   {{ profile.reauthentication_connectivity | default('')  }}
    Should Be Equal Value Json String   ${r.json()}   $.AuthorizationProfile.voiceDomainPermission   {{ profile.voice_domain_permission | default('') }}
{% if profile.web_redirection | default(false) %}
    Should Be Equal Value Json String   ${r.json()}   $.AuthorizationProfile.webRedirection.WebRedirectionType   {{ profile.web_redirection.type }}
    Should Be Equal Value Json String   ${r.json()}   $.AuthorizationProfile.webRedirection.acl   {{ profile.web_redirection.acl }}
    Should Be Equal Value Json String   ${r.json()}   $.AuthorizationProfile.webRedirection.portalName   {{ profile.web_redirection.portal_name }}
    Should Be Equal Value Json String   ${r.json()}   $.AuthorizationProfile.webRedirection.profileName   {{ profile.web_redirection.profile_name | default('')  }}
    Should Be Equal Value Json String   ${r.json()}   $.AuthorizationProfile.webRedirection.displayCertificatesRenewalMessages   {{ profile.web_redirection.display_certificates_renewal_messages }}
{% endif %}
{% if profile.vlan_tag_id | default(false) and profile.vlan_name_id %}
    Should Be Equal Value Json String   ${r.json()}   $.AuthorizationProfile.vlan.nameID   {{ profile.vlan_name_id }}
    Should Be Equal Value Json String   ${r.json()}   $.AuthorizationProfile.vlan.tagID   {{ profile.vlan_tag_id }}
{% endif %}
{% if profile.advanced_attributes | default(false) %}
{% for advanced_attribute in profile.advanced_attributes %}
    Should Be Equal Value Json String   ${r.json()}   $.AuthorizationProfile.advancedAttributes[{{loop.index0}}].leftHandSideDictionaryAttribue.dictionaryName   {{ advanced_attribute.name.split(':')[0] }}
    Should Be Equal Value Json String   ${r.json()}   $.AuthorizationProfile.advancedAttributes[{{loop.index0}}].leftHandSideDictionaryAttribue.attributeName   {{ advanced_attribute.name.split(':')[1] }}
{% if ':' in advanced_attribute.value %}
    Should Be Equal Value Json String   ${r.json()}   $.AuthorizationProfile.advancedAttributes[{{loop.index0}}].rightHandSideAttribueValue.dictionaryName   {{ advanced_attribute.value.split(':')[0] }}
    Should Be Equal Value Json String   ${r.json()}   $.AuthorizationProfile.advancedAttributes[{{loop.index0}}].rightHandSideAttribueValue.attributeName   {{ advanced_attribute.value.split(':')[1] }}
{% else %}
    Should Be Equal Value Json String   ${r.json()}   $.AuthorizationProfile.advancedAttributes[{{loop.index0}}].rightHandSideAttribueValue.value   {{ advanced_attribute.value }}
{% endif %}
{% if advanced_attribute.name.split(':')[1].startswith('Tunnel-') and advanced_attribute.tag_id is defined %}
    Should Be Equal Value Json String   ${r.json()}   $.AuthorizationProfile.advancedAttributes[{{loop.index0}}].rightHandSideAttribueValue.tagID   {{ advanced_attribute.tag_id }}
{% endif %}
{% endfor %}
{% endif %}
{% endfor %}