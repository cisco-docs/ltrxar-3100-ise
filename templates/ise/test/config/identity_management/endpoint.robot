*** Settings ***
Documentation   Verify Endpoint Identity Groups
Suite Setup     Login ISE
Resource        ../../ise_common.resource
Default Tags    config   ise   identity_management   endpoints

*** Test Cases ***

{% for endpoint in ise.identity_management.endpoints | default([]) %}

Verify endpoints {{ endpoint.mac }}
    ${r}=   GET On Session   ISE_Session   /ers/config/endpoint/name/{{endpoint.mac}}
    Log   Response Status Code: ${r.status_code}
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $.ERSEndPoint.description   {{ endpoint.description }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSEndPoint.mac   {{ endpoint.mac }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSEndPoint.staticProfileAssignment   {{ endpoint.static_profile_assignment }}
{% if endpoint.static_profile_assignment == True %}
    Should Be Equal Value Json String   ${r.json()}   $.ERSEndPoint.profileId   {{ endpoint.profile_id }}
{% endif %}
    Should Be Equal Value Json String   ${r.json()}   $.ERSEndPoint.staticProfileAssignmentDefined   {{ endpoint.static_profile_assignment_defined | default(true)  }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSEndPoint.staticGroupAssignment   {{ endpoint.static_group_assignment }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSEndPoint.staticGroupAssignmentDefined   {{ endpoint.static_group_assignment_defined | default(true)  }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSEndPoint.identityStore   {{ endpoint.identity_store | default('')  }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSEndPoint.identityStoreId   {{ endpoint.identity_store_id | default('')  }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSEndPoint.portalUser   {{ endpoint.portal_user | default('')  }}
{% if endpoint.static_group_assignment == True %}
    ${endpointgroup}=   GET On Session   ISE_Session   /ers/config/endpointgroup/name/{{ endpoint.endpoint_identity_group }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSEndPoint.groupId   ${endpointgroup.json()['EndPointGroup']['id']}
{% endif %}
{% if endpoint.mdm_attributes | default([])  %}
    Should Be Equal Value Json String   ${r.json()}   $.ERSEndPoint.mdmAttributes.mdmServerName   {{ endpoint.mdm_attributes.server_name }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSEndPoint.mdmAttributes.mdmReachable   {{ endpoint.mdm_attributes.reachable }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSEndPoint.mdmAttributes.mdmEnrolled   {{ endpoint.mdm_attributes.enrolled }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSEndPoint.mdmAttributes.mdmComplianceStatus   {{ endpoint.mdm_attributes.compliance_status }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSEndPoint.mdmAttributes.mdmOS   {{ endpoint.mdm_attributes.os }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSEndPoint.mdmAttributes.mdmManufacturer   {{ endpoint.mdm_attributes.manufacturer }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSEndPoint.mdmAttributes.mdmModel   {{ endpoint.mdm_attributes.model }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSEndPoint.mdmAttributes.mdmSerial   {{ endpoint.mdm_attributes.serial }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSEndPoint.mdmAttributes.mdmEncrypted   {{ endpoint.mdm_attributes.encrypted }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSEndPoint.mdmAttributes.mdmPinlock   {{ endpoint.mdm_attributes.pin_lock }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSEndPoint.mdmAttributes.mdmJailBroken   {{ endpoint.mdm_attributes.jail_broken }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSEndPoint.mdmAttributes.mdmIMEI   {{ endpoint.mdm_attributes.imei }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSEndPoint.mdmAttributes.mdmPhoneNumber   {{ endpoint.mdm_attributes.phone_number }}
{% endif %}
{% endfor %}