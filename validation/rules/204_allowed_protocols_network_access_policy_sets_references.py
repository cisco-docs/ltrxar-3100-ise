class Rule:
    id = "204"
    description = "Verify if referenced allowed protocols exist"
    severity = "HIGH"

    @classmethod
    def match(cls, data):
        results = []
        default_allowed_protocols = ["Default Network Access"]
        allowed_protocols = []

        for obj in data.get("ise", {}).get("network_access", {}).get("policy_elements", {}).get("allowed_protocols", []):
            name = obj.get("name")
            allowed_protocols.append(name)  
        # Needed if you are using the same allowed protocols under network access and device administration
        for obj in data.get("ise", {}).get("device_administration", {}).get("policy_elements", {}).get("allowed_protocols", []):
            name = obj.get("name")
            allowed_protocols.append(name)   

        all_allowed_protocols = list(set(default_allowed_protocols + allowed_protocols))

        for policy_set in data.get("ise", {}).get("network_access", {}).get("policy_sets", []):
            if policy_set.get("service_name") not in all_allowed_protocols:
                results.append(
                    f"service_name - {policy_set.get('service_name')} under policy_set - {policy_set.get('name')} is not defined in network access -> policy_elements -> allowed_protocols data model"
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
