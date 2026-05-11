# TACACS Command Set

*Location in GUI*:
`Work Centers` » `Device Administration` » `Policy Elements` » `Results` » `TACACS Command Sets`

{{ doc_gen }}

### Examples

Example 1: Basic Allow Command Set

This example shows how to configure a command set that permits only specific "show" commands, like show version, and show running-config. Any command not matched in this list is denied because permit_unmatched is set to false.

```yaml
ise:
  device_administration:
    policy_elements:
      tacacs_command_sets:
        - name: AllowShowCommands1
          description: Allows only show commands
          permit_unmatched: false
          commands:
            - command: show
              grant: PERMIT
```
Example-2 TACACS Command Set to Deny Configuration and Reload Commands

This TACACS command set named "DenyCommands" is designed to explicitly deny specific critical commands related to device configuration and reload operations. It denies the configure terminal command by specifying both the command and its argument, and it denies the reload command with a DENY_ALWAYS grant, ensuring these commands cannot be executed. The setting permit_unmatched: true allows all other commands not explicitly denied, providing a focused restriction on sensitive commands while permitting general command usage. This configuration helps enforce strict control over device management actions to prevent unauthorized changes or reloads.

```yaml
ise:
  device_administration:
    policy_elements:
      tacacs_command_sets:
        - name: DenyCommands
          description: Denies configuration commands and device reload
          permit_unmatched: true
          commands:
            - command: configure
              grant: DENY
              arguments: terminal
            - command: reload
              grant: DENY_ALWAYS
```