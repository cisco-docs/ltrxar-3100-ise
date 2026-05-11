class Rule:
    id = "101"
    description = "Verify unique keys"
    severity = "HIGH"

    paths = [
        "ise.system.repositories.name",
        "ise.system.licenses.name",
        "ise.identity_management.endpoint_identity_groups.name",
        "ise.identity_management.user_identity_groups.name",
        "ise.identity_management.internal_users.name",
        "ise.identity_management.certificate_authentication_profiles.name",
        "ise.trust_sec.security_groups.name",
        "ise.trust_sec.security_groups.value",
        "ise.trust_sec.security_group_acls.name",
        "ise.trust_sec.ip_sgt_mapping_groups.name",
        "ise.trust_sec.ip_sgt_mappings.name",
        "ise.network_access.policy_elements.authorization_profiles.name",
        "ise.network_access.policy_elements.authorization_profiles.advanced_attributes.attribute",
        "ise.network_access.policy_elements.conditions.name",
        "ise.network_access.policy_elements.allowed_protocols.name",
        "ise.network_access.policy_elements.downloadable_acls.name",
        "ise.network_access.policy_elements.dictionaries.name",
        "ise.network_access.policy_elements.time_date_conditions.name",
        "ise.network_access.policy_sets.name",
        "ise.network_access.policy_sets.authentication_rules.name",
        "ise.network_access.policy_sets.authorization_rules.name",
        "ise.network_access.policy_sets.authorization_exception_rules.name",
        "ise.network_access.authorization_global_exception_rules..name",
        "ise.device_administration.policy_elements.conditions.name",
        "ise.device_administration.policy_elements.allowed_protocols.name",
        "ise.device_administration.policy_elements.tacacs_profiles.name",
        "ise.device_administration.policy_elements.tacacs_command_sets.name",
        "ise.device_administration.policy_elements.time_date_conditions.name",
        "ise.device_administration.policy_sets.name",
        "ise.device_administration.policy_sets.authentication_rules.name",
        "ise.device_administration.policy_sets.authorization_rules.name",
        "ise.device_administration.policy_sets.authorization_exception_rules.name",
        "ise.device_administration.authorization_global_exception_rules.name",
    ]

    @classmethod
    def match_path(cls, inventory, full_path, search_path):
        results = []
        path_elements = search_path.split(".")
        inv_element = inventory
        for idx, path_element in enumerate(path_elements[:-1]):
            if isinstance(inv_element, dict):
                inv_element = inv_element.get(path_element)
            elif isinstance(inv_element, list):
                for i in inv_element:
                    r = cls.match_path(i, full_path, ".".join(path_elements[idx:]))
                    results.extend(r)
                return results
            if inv_element is None:
                return results
        values = []
        if isinstance(inv_element, list):
            for i in inv_element:
                if not isinstance(i, dict):
                    continue
                value = i.get(path_elements[-1])
                if isinstance(value, list):
                    values = []
                    for v in value:
                        if v not in values:
                            values.append(v)
                        else:
                            results.append(full_path + " - " + str(v))
                elif value:
                    if value not in values:
                        values.append(value)
                    else:
                        results.append(full_path + " - " + str(value))
        elif isinstance(inv_element, dict):
            list_element = inv_element.get(path_elements[-1])
            if isinstance(list_element, list):
                for value in list_element:
                    if value:
                        if value not in values:
                            values.append(value)
                        else:
                            results.append(full_path + " - " + str(value))
        return results

    @classmethod
    def match(cls, inventory):
        results = []
        for path in cls.paths:
            r = cls.match_path(inventory, path, path)
            results.extend(r)
        return results
