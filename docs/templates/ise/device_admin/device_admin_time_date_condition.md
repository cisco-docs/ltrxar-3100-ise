*Location in GUI*:
`Work Centers` » `Device Administration` » `Policy Elements` » `Conditions` » `Time and Date`

# Time Date Condition

{{ doc_gen }}

### Examples

Example-1 Time and Date Access Control Condition

This example defines a time and date condition named "TimeDate1" within the device administration policy elements. The condition specifies allowed access on Mondays and Tuesdays between May 6, 2026, and May 20, 2026, during the time window from 08:00 to 15:00. The is_negate flag is set to false, indicating the condition permits access during these specified days and times. This configuration demonstrates how to enforce temporal access controls for precise network device administration based on date and time criteria.

```yaml
ise:
  device_administration:
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

Example-2 Time and Date Condition with Time Range Exception

This example defines a time and date condition within device administration policy elements that applies on weekdays (Monday through Friday) throughout the year 2026. The condition is active daily from 09:00 to 17:00, but includes a time range exception from 12:00 to 13:00 during which the condition does not apply. This configuration allows precise control over access based on both date and time, with a specified exception period during the day.

```yaml
ise:
  device_administration:
    policy_elements:
      time_date_conditions:
        - name: TimeDateWithTimeRangeException
          description: Time and date condition with a time range exception
          is_negate: false
          week_days:
            - Monday
            - Tuesday
            - Wednesday
            - Thursday
            - Friday
          start_date: "2026-01-01"
          end_date: "2026-12-31"
          start_time: "09:00"
          end_time: "17:00"
          exception_start_time: "12:00"
          exception_end_time: "13:00"
```