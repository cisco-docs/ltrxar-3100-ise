*** Settings ***
Documentation   Verify Device Admin Time and Date Conditions
Suite Setup     Login ISE
Resource        ../../ise_common.resource
Default Tags    config   ise   device_administration   policy_elements   time_date_conditions

*** Test Cases ***

Get Device Admin Time and Date Conditions
    ${r}=   GET On Session   ISE_Session   /api/v1/policy/device-admin/time-condition
    Log   Response Status Code: ${r.status_code}
    Set Suite Variable   ${r}

{% for condition in ise.device_administration.policy_elements.time_date_conditions | default([]) %}
Verify Device Admin Time and Date Condition {{ condition.name }}
    ${cond}=   Set Variable   $.response[?(@.name=='{{ condition.name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${cond}.name   {{ condition.name }}
    Should Be Equal Value Json String   ${r.json()}   ${cond}.description   {{ condition.description | default('') }}
    Should Be Equal Value Json String   ${r.json()}   ${cond}.datesRange.startDate   {{ condition.start_date | default('') }}
    Should Be Equal Value Json String   ${r.json()}   ${cond}.datesRange.endDate   {{ condition.end_date | default('') }}
    Should Be Equal Value Json String   ${r.json()}   ${cond}.datesRangeException.startDate   {{ condition.exception_start_date | default('') }}
    Should Be Equal Value Json String   ${r.json()}   ${cond}.datesRangeException.endDate   {{ condition.exception_end_date | default('') }}
    Should Be Equal Value Json String   ${r.json()}   ${cond}.hoursRange.startTime   {{ condition.start_time | default('') }}
    Should Be Equal Value Json String   ${r.json()}   ${cond}.hoursRange.endTime   {{ condition.end_time | default('') }}
    Should Be Equal Value Json String   ${r.json()}   ${cond}.hoursRangeException.startTime   {{ condition.exception_start_time | default('') }}
    Should Be Equal Value Json String   ${r.json()}   ${cond}.hoursRangeException.endTime   {{ condition.exception_end_time | default('') }}
{% if condition.week_days | default([])  %}
    ${list}=   Create List   {{ condition.week_days | join('   ') }}
    Should Be Equal Value Json List   ${r.json()}   ${cond}.weekDays   ${list}
{% endif %}
{% if condition.week_days_exception | default([])  %}
    ${list}=   Create List   {{ condition.week_days_exception | join('   ') }}
    Should Be Equal Value Json List   ${r.json()}   ${cond}.weekDaysException   ${list}
{% endif %}
{% endfor %}