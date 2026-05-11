# Network Device Group

Up to five levels of nested network device groups are supported. When adding a group under an existing group, the path must be specified in the format `All Locations#Europe`, where `#` is used as a delimiter.

*Location in GUI*:
`Administration` » `Network Resources` » `Network Device Groups`

{{ doc_gen }}

### Examples

```yaml
ise:
  network_resources:
    network_device_groups:
      - name: Europe
        description: All European locations
        path: All Locations
        children:
          - name: Vienna
            description: Vienna, Austria
```
