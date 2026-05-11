*** Settings ***
Documentation   Verify Network Resources Network Device Groups
Suite Setup     Login ISE
Resource        ../../ise_common.resource
Default Tags    config   ise   network_resources   network_device_groups

*** Test Cases ***

{% for network_group in ise.network_resources.network_device_groups | default([]) %}
Verify Network Device Group {{ network_group.name }}
{% if network_group.path | default(false) %}
{% if 'Is IPSEC Device' in network_group.path %}
{% set group_name = 'IPSEC' ~ ':' ~ network_group.path ~ ':' ~ network_group.name  %}
{% elif 'All Locations' in network_group.path %}
{% set group_name = 'Location' ~ ':' ~ network_group.path ~ ':' ~ network_group.name %}
{% elif 'All Device Types' in network_group.path %}
{% set group_name = 'Device Type' ~ ':' ~ network_group.path ~ ':' ~ network_group.name %}
{% else %}
{% set group_name = network_group.path.split(':')[0] ~ ':' ~ network_group.name %}
{% endif %}
    ${r}=   GET On Session   ISE_Session   /ers/config/networkdevicegroup/name/{{ group_name }}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDeviceGroup.description   {{ network_group.description | default(defaults.ise.network_resources.network_device_groups.description) | default('') }}
{% for child in network_group.children | default([]) %}
{% set child_group_name = group_name ~ ':' ~ child.name %}
    ${r}=   GET On Session   ISE_Session   /ers/config/networkdevicegroup/name/{{ child_group_name }}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDeviceGroup.description   {{ child.description | default(defaults.ise.network_resources.network_device_groups.description) | default('') }}
{% for child_child in child.children | default([]) %}
{% set child_child_group_name = group_name ~ ':' ~ child.name ~ ':' ~ child_child.name %}
    ${r}=   GET On Session   ISE_Session   /ers/config/networkdevicegroup/name/{{ child_child_group_name }}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDeviceGroup.description   {{ child_child.description | default(defaults.ise.network_resources.network_device_groups.description) | default('') }}
{% endfor %} 
{% endfor %}  
{% else %}
{% set group_name = network_group.name.split(':')[0] ~ ':' ~ network_group.name %}
    ${r}=   GET On Session   ISE_Session   /ers/config/networkdevicegroup/name/{{ group_name }}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDeviceGroup.description   {{ network_group.description | default(defaults.ise.network_resources.network_device_groups.description) | default('') }}
{% for child in network_group.children | default([]) %}
{% set child_group_name = group_name ~ ':' ~ child.name %}
    ${r}=   GET On Session   ISE_Session   /ers/config/networkdevicegroup/name/{{ child_group_name }}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDeviceGroup.description   {{ child.description | default(defaults.ise.network_resources.network_device_groups.description) | default('') }}
{% for child_child in child.children | default([]) %}
{% set child_child_group_name = group_name ~ ':' ~ child.name ~ ':' ~ child_child.name %}
    ${r}=   GET On Session   ISE_Session   /ers/config/networkdevicegroup/name/{{ child_child_group_name }}
    Should Be Equal Value Json String   ${r.json()}   $.NetworkDeviceGroup.description   {{ child_child.description | default(defaults.ise.network_resources.network_device_groups.description) | default('') }}
{% endfor %} 
{% endfor %}  
{% endif %}
{% endfor %}