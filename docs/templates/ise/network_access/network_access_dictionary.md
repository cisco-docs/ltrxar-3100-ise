# Dictionary

*Location in GUI*:
`Work Centers` » `Network Access` » `Dictionaries` » `User`

{{ doc_gen }}

### Examples

Example-1 Network Access Policy Element Dictionary with Entity Attribute Type

This example demonstrates a Cisco ISE network access policy element dictionary configured as a custom attribute container for entity-level attributes. The dictionary "Dict1" is defined with version "1.1" and attribute_type set to ENTITY_ATTR, which designates it as an entity attribute dictionary used for storing endpoint or user-specific attributes.

```yaml
ise:
  network_access:
    policy_elements:
      dictionaries:
        - name: Dict1
          description: My dictionary
          version: "1.1"
          attribute_type: ENTITY_ATTR
```

Example-2 Network Access Policy Element Dictionary with Message Attribute Type for RADIUS

This example demonstrates a Cisco ISE network access policy element dictionary configured for RADIUS message attributes with real-time session processing. The dictionary "Custom_RADIUS_Attributes" is defined with version "2.0" and attribute_type set to MSG_ATTR, which designates it as a message attribute dictionary used for storing session-specific RADIUS attributes that are evaluated during authentication and authorization flows.

```yaml
ise:
  network_access:
    policy_elements:
      dictionaries:
        - name: Custom_RADIUS_Attributes
          description: Custom dictionary for RADIUS message attributes
          version: "2.0"
          attribute_type: MSG_ATTR
```

Example-3 Policy Element Dictionary with Policy Information Point Attribute Type for External Data Sources

This example demonstrates a Cisco ISE network access policy element dictionary configured for Policy Information Point (PIP) integration with external data sources. The dictionary "External_API_Attributes" is defined with version "1.5" and attribute_type set to PIP_ATTR, which designates it as a Policy Information Point attribute dictionary used for retrieving real-time data from external systems via REST APIs, database queries, or other integration mechanisms

```yaml
ise:
  network_access:
    policy_elements:
      dictionaries:
        - name: External_API_Attributes
          description: Dictionary for attributes from external APIs or data sources
          version: "1.5"
          attribute_type: PIP_ATTR
```