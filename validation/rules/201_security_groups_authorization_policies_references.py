class Rule:
    id = "201"
    description = "Verify if security group is defined under security_groups data model if its assigned under authorization rules"
    severity = "HIGH"

    @classmethod
    def match(cls, data):
        results = []
        security_groups_names = []
        default_security_groups_names = [
            "BYOD",
            "Contractors",
            "Developers",
            "Employees",
            "Guests",
            "Network_Services",
            "Production_Users",
            "Quarantined_Systems",
            "Unknown",
            "TrustSec_Devices",
            None,
        ]

        ## security groups
        for obj in data.get("ise", {}).get("trust_sec", {}).get("security_groups", []):
            name = obj.get("name")
            security_groups_names.append(name)

        all_security_groups = list(
            set(security_groups_names + default_security_groups_names)
        )

        ## network access authorization rules
        for ps in data.get("ise", {}).get("network_access", {}).get("policy_sets", []):
            for rule in ps.get("authorization_rules", []):
                if rule.get("security_group") not in all_security_groups:
                    results.append(
                        f"Security Group - {rule.get('security_group')} is not defined in trust_sec security_groups data model"
                    )
            for rule in ps.get("authorization_exception_rules", []):
                if rule.get("security_group") not in all_security_groups:
                    results.append(
                        f"Security Group - {rule.get('security_group')} is not defined in trust_sec security_groups data model"
                    )
            for rule in data.get("ise", {}).get("network_access", {}).get("authorization_global_exception_rules", []):
                if rule.get("security_group") not in all_security_groups:

                    results.append(
                        f"Security Group - {rule.get('security_group')} is not defined in trust_sec security_groups data model"
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
