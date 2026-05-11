# Time Date Condition

*Location in GUI*:
`Work Centers` » `Network Access` » `Policy Elements` » `Conditions` » `Time and Date Conditions`

{{ doc_gen }}

### Examples

Example-1 Network Access Time and Date Condition with Weekly and Daily Time Restrictions

This example demonstrates a Cisco ISE network access time and date condition configured to restrict authentication based on specific days, date ranges, and time windows. The condition "TimeDate1" is defined with is_negate set to false for direct matching, restricting access to Mondays and Tuesdays only within the week_days parameter, limiting the effective date range from May 6, 2026 to May 20, 2026 (start_date and end_date), and enforcing a daily time window from 8:00 AM to 3:00 PM (08:00 to 15:00 in 24-hour format). 

```yaml
ise:
  network_access:
    policy_elements:
      time_date_conditions:
        - name: TimeDate1
          description: My time and date condition
          is_negate: false
          week_days:
            - Monday
            - Tuesday
          start_date: "2026-05-06"
          end_date: "2026-05-20"
          start_time: "08:00"
          end_time: "15:00"
```
Example-2 Network Access Time Condition for Standard Business Hours

This time and date condition defines standard business hours for network access control, matching Monday through Friday from 8:00 AM (08:00) to 6:00 PM (18:00). The condition is not negated (is_negate: false), meaning it will match during the specified weekdays and time window. With no start_date or end_date specified, this condition applies year-round without expiration. 

```yaml
ise:
  network_access:
    policy_elements:
      time_date_conditions:
        - name: Business_Hours
          description: Standard business hours Monday to Friday
          is_negate: false
          week_days:
            - Monday
            - Tuesday
            - Wednesday
            - Thursday
            - Friday
          start_time: "08:00"
          end_time: "18:00"
```
Example-3 Network Access Time Condition for Business Hours with Holiday Exception Period

This time and date condition defines standard business hours (Monday through Friday, 8:00 AM to 6:00 PM) with an exception mechanism that excludes specific holiday dates. The condition matches weekdays during business hours but will NOT match during the exception period from December 24-26, 2026 (Christmas holiday shutdown). This demonstrates ISE's exception handling capability using exception_start_date and exception_end_date parameters, which override the primary time/date criteria during the specified range. 

```yaml
ise:
  network_access:
    policy_elements:
      time_date_conditions:
        - name: Business_Hours_Exclude_Holidays
          description: Business hours excluding company holidays
          is_negate: false
          week_days:
            - Monday
            - Tuesday
            - Wednesday
            - Thursday
            - Friday
          start_time: "08:00"
          end_time: "18:00"
          exception_start_date: "2026-12-24"
          exception_end_date: "2026-12-26"
```