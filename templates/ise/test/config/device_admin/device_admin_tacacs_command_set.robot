*** Settings ***
Documentation   Verify Device Admin TACACS Command Sets
Suite Setup     Login ISE
Resource        ../../ise_common.resource
Default Tags    config   ise   device_administration   policy_elements   tacacs_command_sets

*** Test Cases ***

{% for command_set in ise.device_administration.policy_elements.tacacs_command_sets | default([]) %}
Verify Device Admin TACACS Command Set {{ command_set.name }}
    ${r}=   GET On Session   ISE_Session   /ers/config/tacacscommandsets/name/{{ command_set.name }}
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $.TacacsCommandSets.description   {{ command_set.description | default('')  }}  
    Should Be Equal Value Json String   ${r.json()}   $.TacacsCommandSets.permitUnmatched   {{ command_set.permit_unmatched | default(defaults.ise.device_administration.policy_elements.tacacs_command_sets.permit_unmatched) | default(false)  }}  
{% for command in command_set.commands | default([])   %}
    Should Be Equal Value Json String   ${r.json()}   $.TacacsCommandSets.commands.commandList[{{loop.index0}}].command   {{ command.command }}
    Should Be Equal Value Json String   ${r.json()}   $.TacacsCommandSets.commands.commandList[{{loop.index0}}].grant   {{ command.grant | default(defaults.ise.device_administration.policy_elements.tacacs_command_sets.commands.grant) | default('PERMIT') }}
    Should Be Equal Value Json String   ${r.json()}   $.TacacsCommandSets.commands.commandList[{{loop.index0}}].arguments   {{ command.arguments | default(defaults.ise.device_administration.policy_elements.tacacs_command_sets.commands.arguments) | default('') }}
{% endfor %}
{% endfor %}