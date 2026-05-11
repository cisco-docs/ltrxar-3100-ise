class Rule:
    id = "206"
    description = "Verify if referenced downloadable acl exist"
    severity = "HIGH"

    @classmethod
    def match(cls, data):
        results = []
        default_dacl_names = ["DENY_ALL_IPV4_TRAFFIC", "DENY_ALL_IPV6_TRAFFIC", "PERMIT_ALL_IPV4_TRAFFIC", "PERMIT_ALL_IPV6_TRAFFIC"]
        dacl_names = []

        for obj in data.get("ise", {}).get("network_access", {}).get("policy_elements", {}).get("downloadable_acls",[]):
            name = obj.get("name")
            dacl_names.append(name)

        all_dacl_names = list(set(default_dacl_names + dacl_names))

        for dacl_obj in data.get("ise", {}).get("network_access", {}).get("policy_elements", {}).get("authorization_profiles",[]):
            if "dacl_name" in dacl_obj:
                if dacl_obj.get("dacl_name") not in all_dacl_names:
                    results.append(
                        f"dacl_name - {dacl_obj.get('dacl_name')} under authorization_profiles is not defined in network access -> policy_elements -> downloadable_acls data model"
                    )

        return results

## UNCOMMENT TO TEST RULE LOCALLY
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
