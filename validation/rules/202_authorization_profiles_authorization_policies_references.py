class Rule:
    id = "202"
    description = "Verify if authorization profile is defined under authorization_profiles data model if its assigned under authorization rules"
    severity = "HIGH"

    @classmethod
    def match(cls, data):
        results = []
        authorization_profiles = []
        default_authorization_profiles = [
            "Block_Wireless_Access",
            "Cisco_IP_Phones",
            "Cisco_Temporal_Onboard",
            "Cisco_WebAuth",
            "NSP_Onboard",
            "Non_Cisco_IP_Phones",
            "UDN",
            "DenyAccess",
            "PermitAccess",
        ]

        ## authorization_profiles
        for obj in data.get("ise", {}).get("network_access", {}).get("policy_elements", {}).get("authorization_profiles", []):
            name = obj.get("name")
            authorization_profiles.append(name)


        all_authorization_profiles = list(
            set(authorization_profiles + default_authorization_profiles)
        )

        ## network access authorization rules
        for ps in data.get("ise", {}).get("network_access", {}).get("policy_sets", []):
            for rule in ps.get("authorization_rules", []):
                for profile in rule.get("profiles", []):
                    if profile not in all_authorization_profiles:
                        results.append(
                            f"Authorization Profile - {profile} is not defined in authorization_profiles data model"
                        )
        for ps in data.get("ise", {}).get("network_access", {}).get("policy_sets", []):
            for rule in ps.get("authorization_exception_rules", []):
                for profile in rule.get("profiles", []):
                    if profile not in all_authorization_profiles:
                        results.append(
                            f"Authorization Profile - {profile} is not defined in authorization_profiles data model"
                        )
        for rule in data.get("ise", {}).get("network_access", {}).get("authorization_global_exception_rules", []):
            for profile in rule.get("profiles", []):
                if profile not in all_authorization_profiles:
                    results.append(
                        f"Authorization Profile - {profile} is not defined in authorization_profiles data model"
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
