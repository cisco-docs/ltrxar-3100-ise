class Rule:
    id = "210"
    description = "Verify if referenced endpoint identity group exist"
    severity = "HIGH"

    paths = ["ise.network_access.policy_sets.authentication_rules.name",
             "ise.device_administration.policy_sets.authentication_rules.name",
             "ise.network_access.policy_sets.authorization_rules.name",
             "ise.device_administration.policy_sets.authorization_rules.name",
             "ise.network_access.policy_sets.authorization_exception_rules.name",
             "ise.device_administration.policy_sets.authorization_exception_rules.name",
             "ise.network_access.authorization_global_exception_rules.name",
             "ise.device_administration.authorization_global_exception_rules.name",
             "ise.network_access.policy_sets.name",
             "ise.device_administration.policy_sets.name",
            ]

    @classmethod
    def match_path(cls, inventory, full_path, search_path, all_endpoint_identity_groups):
        results = []
        path_elements = search_path.split(".")
        inv_element = inventory
        for idx, path_element in enumerate(path_elements[:-1]):
            if isinstance(inv_element, dict):
                inv_element = inv_element.get(path_element)
            elif isinstance(inv_element, list):
                for i in inv_element:
                    r = cls.match_path(i, full_path, ".".join(path_elements[idx:]), all_endpoint_identity_groups)
                    results.extend(r)
                return results
            if inv_element is None:
                return results

        if isinstance(inv_element, list):
            for i in inv_element:
                if not isinstance(i, dict):
                    continue
                name = i.get(path_elements[-1])

                condition = i.get('condition')
                if condition is not None:
                    if condition.get('children'):
                        for child in condition.get('children'):
                            if child.get('children'):
                                for child_child in child.get('children'):
                                    if child_child.get('attribute_value') is not None and child_child['attribute_value'].startswith('Endpoint Identity Groups'):
                                        endpoint_identity_group = child_child['attribute_value'].split(':')[1]
                                        if endpoint_identity_group not in all_endpoint_identity_groups:
                                            results.append(
                                                f"Endpoint Identity Group - {endpoint_identity_group} under {full_path.split('.name')[0]}->{name} is not defined in endpoint_identity_groups data model"
                                            )
                            else:
                                if child.get('attribute_value') is not None and child['attribute_value'].startswith('Endpoint Identity Groups'):
                                    endpoint_identity_group = child['attribute_value'].split(':')[1]
                                    if endpoint_identity_group not in all_endpoint_identity_groups:
                                        results.append(
                                            f"Endpoint Identity Group - {endpoint_identity_group} under {full_path.split('.name')[0]}->{name} is not defined in endpoint_identity_groups data model"
                                        )
                    else:
                        if condition.get('attribute_value') is not None and condition['attribute_value'].startswith('Endpoint Identity Groups'):
                            endpoint_identity_group = condition['attribute_value'].split(':')[1]
                            if endpoint_identity_group not in all_endpoint_identity_groups:
                                results.append(
                                    f"Endpoint Identity Group - {endpoint_identity_group} under {full_path.split('.name')[0]}->{name} is not defined in endpoint_identity_groups data model"
                                )
        return results

    @classmethod
    def match(cls, inventory):
        results = []
        default_endpoint_identity_groups = ['Android', 'Apple-iDevice', 'Axis-Device', 'BlackBerry', 'Blocked List', 'Cisco-IP-Phone', 'Cisco-Meraki-Device', 'Epson-Device', 'GuestEndpoints', 'Juniper-Device', 'OS_X_BigSur-Workstation', 'Profiled', 'RegisteredDevices', 'Sony-Device', 'Synology-Device', 'Trendnet-Device', 'Unknown', 'Vizio-Device', 'Workstation']
        endpoint_identity_groups = []
        
        for group in inventory.get("ise", {}).get("identity_management", {}).get("endpoint_identity_groups", []):
            name = group.get("name")
            endpoint_identity_groups.append(name)
        
        all_endpoint_identity_groups = list(set(default_endpoint_identity_groups + endpoint_identity_groups))

        for path in cls.paths:
            r = cls.match_path(inventory, path, path, all_endpoint_identity_groups)
            results.extend(r)
        return results


# UNCOMMENT TO TEST RULE LOCALLY
# import os
# from yaml.loader import SafeLoader
# import yaml
# from collections import defaultdict

# data = defaultdict(dict)
# directory = "../../tests/integration/fixtures/ise/standard"
# a = Rule()

# for filename in os.listdir(directory):
#     if filename.endswith(".yaml"):
#         with open(os.path.join(directory, filename)) as file:
#             file_data = yaml.load(file, Loader=SafeLoader)
#             for key, value in file_data.items():
#                 data[key].update(value)

# print(a.match(dict(data)))
