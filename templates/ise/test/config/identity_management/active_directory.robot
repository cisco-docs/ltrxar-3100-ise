*** Settings ***
Documentation   Verify Active Directories
Suite Setup     Login ISE
Resource        ../../ise_common.resource
Default Tags    config   ise   identity_management   active_directories

*** Test Cases ***

{% for active_directory in ise.identity_management.active_directories | default([]) %}

Verify Internal User {{ active_directory.name }}
    ${r}=   GET On Session   ISE_Session   /ers/config/activedirectory/name/{{active_directory.name}}
    Log   Response Status Code: ${r.status_code}
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $.ERSActiveDirectory.description   {{ active_directory.description | default(defaults.ise.identity_management.active_directories.description, true) | default('') }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSActiveDirectory.domain   {{ active_directory.domain }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSActiveDirectory.enableDomainAllowedList   {{ active_directory.enable_domain_allowed_list | default(defaults.ise.identity_management.active_directories.enable_domain_allowed_list) }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSActiveDirectory.advancedSettings.enablePassChange   {{ active_directory.enable_pass_change | default(defaults.ise.identity_management.active_directories.enable_pass_change) }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSActiveDirectory.advancedSettings.enableMachineAuth  {{ active_directory.enable_machine_auth | default(defaults.ise.identity_management.active_directories.enable_machine_auth) }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSActiveDirectory.advancedSettings.enableMachineAccess   {{ active_directory.enable_machine_access | default(defaults.ise.identity_management.active_directories.enable_machine_access) }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSActiveDirectory.advancedSettings.agingTime   {{ active_directory.aging_time | default(defaults.ise.identity_management.active_directories.aging_time) }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSActiveDirectory.advancedSettings.enableDialinPermissionCheck   {{ active_directory.enable_dialin_permission_check | default(defaults.ise.identity_management.active_directories.enable_dialin_permission_check) }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSActiveDirectory.advancedSettings.enableCallbackForDialinClient   {{ active_directory.enable_callback_for_dialin_client | default(defaults.ise.identity_management.active_directories.enable_callback_for_dialin_client) }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSActiveDirectory.advancedSettings.plaintextAuth   {{ active_directory.plaintext_auth | default(defaults.ise.identity_management.active_directories.plaintext_auth) }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSActiveDirectory.advancedSettings.enableFailedAuthProtection   {{ active_directory.enable_failed_auth_protection | default(defaults.ise.identity_management.active_directories.enable_failed_auth_protection) }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSActiveDirectory.advancedSettings.failedAuthThreshold   {{ active_directory.failed_auth_threshold | default(defaults.ise.identity_management.active_directories.failed_auth_threshold) }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSActiveDirectory.advancedSettings.enableRewrites   {{ active_directory.enable_rewrites | default(defaults.ise.identity_management.active_directories.enable_rewrites) }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSActiveDirectory.adScopesNames   {{ active_directory.ad_scopes_names | default(defaults.ise.identity_management.active_directories.ad_scopes_names) }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSActiveDirectory.advancedSettings.authProtectionType   {{ active_directory.auth_protection_type | default(defaults.ise.identity_management.active_directories.auth_protection_type, true) | default('') }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSActiveDirectory.advancedSettings.unreachableDomainsBehaviour   {{ active_directory.unreachable_domains_behaviour | default(defaults.ise.identity_management.active_directories.unreachable_domains_behaviour, true) | default('') }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSActiveDirectory.advancedSettings.schema   {{ active_directory.schema | default(defaults.ise.identity_management.active_directories.schema, true) | default('') }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSActiveDirectory.advancedSettings.firstName   {{ active_directory.first_name | default(defaults.ise.identity_management.active_directories.first_name, true) | default('') }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSActiveDirectory.advancedSettings.department   {{ active_directory.department | default(defaults.ise.identity_management.active_directories.department, true) | default('') }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSActiveDirectory.advancedSettings.lastName   {{ active_directory.last_name | default(defaults.ise.identity_management.active_directories.last_name, true) | default('') }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSActiveDirectory.advancedSettings.email   {{ active_directory.email | default(defaults.ise.identity_management.active_directories.email, true) | default('') }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSActiveDirectory.advancedSettings.locality   {{ active_directory.locality | default(defaults.ise.identity_management.active_directories.locality, true) | default('') }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSActiveDirectory.advancedSettings.jobTitle   {{ active_directory.job_title | default(defaults.ise.identity_management.active_directories.job_title, true) | default('') }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSActiveDirectory.advancedSettings.telephone   {{ active_directory.telephone | default(defaults.ise.identity_management.active_directories.telephone, true) | default('') }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSActiveDirectory.advancedSettings.country   {{ active_directory.country | default(defaults.ise.identity_management.active_directories.country, true) | default('') }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSActiveDirectory.advancedSettings.streetAddress   {{ active_directory.street_address | default(defaults.ise.identity_management.active_directories.street_address, true) | default('') }}
    Should Be Equal Value Json String   ${r.json()}   $.ERSActiveDirectory.advancedSettings.stateOrProvince   {{ active_directory.state_or_province | default(defaults.ise.identity_management.active_directories.state_or_province, true) | default('') }}
{% for group in active_directory.groups | default([]) %}
   Should Be Equal Value Json String   ${r.json()}   $.ERSActiveDirectory.adgroups.groups[?(@.name=='{{ group.name }}')].name   {{ group.name }}
{% endfor %}
{% for rewrite_rule in active_directory.rewrite_rules | default([]) %}
   Should Be Equal Value Json String   ${r.json()}   $.ERSActiveDirectory.advancedSettings.rewriteRules[{{loop.index0}}].rowId   {{ rewrite_rule.row_id }}
   Should Be Equal Value Json String   ${r.json()}   $.ERSActiveDirectory.advancedSettings.rewriteRules[{{loop.index0}}].rewriteMatch   {{ rewrite_rule.rewrite_match }}
   Should Be Equal Value Json String   ${r.json()}   $.ERSActiveDirectory.advancedSettings.rewriteRules[{{loop.index0}}].rewriteResult   {{ rewrite_rule.rewrite_result }}
{% endfor %}
{% endfor %}