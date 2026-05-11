class Rule:
    id = "208"
    description = "Verify if referenced tacacs profile exist"
    severity = "HIGH"

    @classmethod
    def match(cls, data):
        results = []
        tacacs_profiles = []
        default_tacacs_profiles = [
            "Default Shell Profiles",
            "Deny All Shell Profile",
            "WLC ALL",
            "WLC MONITOR"
        ]

        ## tacacs_profiles
        for obj in data.get("ise", {}).get("device_administration", {}).get("policy_elements", {}).get("tacacs_profiles",[]):
            name = obj.get("name")

            tacacs_profiles.append(name)

        all_tacacs_profiles = list(
            set(tacacs_profiles + default_tacacs_profiles)
        )

        policy_sets = data.get("ise", {}).get("device_administration", {}).get("policy_sets", [])
        for policy_set in policy_sets:
            for rule in policy_set.get("authorization_rules", []):
                profile = rule.get('profile')
                if profile and profile not in all_tacacs_profiles:
                    results.append(
                        f"Tacacs Profile - {profile} configured under device admin policy-set {policy_set.get('name')} -> authorization_rule {rule.get('name')} is not defined in tacacs_profiles data model"
                    )

        for policy_set in policy_sets:
            for rule in policy_set.get("authorization_exception_rules", []):
                profile = rule.get("profile")
                if profile and profile not in all_tacacs_profiles:
                    results.append(
                        f"Tacacs Profile - {profile} configured under device admin policy-set {policy_set.get('name')} -> authorization_exception_rules {rule.get('name')} is not defined in tacacs_profiles data model"
                    )

        global_exception_rules = data.get("ise", {}).get("device_administration", {}).get("authorization_global_exception_rules", [])
        for rule in global_exception_rules:
            profile = rule.get("profile")
            if profile and profile not in all_tacacs_profiles:
                results.append(
                    f"Tacacs Profile - {profile} configured under device admin authorization_global_exception_rules {rule.get('name')} is not defined in tacacs_profiles data model"
                )

        results = list(set(results))

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
