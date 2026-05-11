class Rule:
    id = "207"
    description = "Verify if referenced security group exist"
    severity = "HIGH"

    @classmethod
    def match(cls, data):
        results = []
        default_security_groups_names = [
        "Auditors", "BYOD", "Contractors", "Developers", "Development_Servers",
        "Employees", "Guests", "Network_Services", "PCI_Servers",
        "Point_of_Sale_Systems", "Production_Servers", "Production_Users",
        "Quarantined_Systems", "Test_Servers", "TrustSec_Devices", "Unknown", None,
        ]   
        
        security_groups_names = [
            obj["name"] for obj in data.get("ise", {}).get("trust_sec", {}).get("security_groups", [])
            if "name" in obj
        ]

        all_security_groups = list(set(security_groups_names + default_security_groups_names))

        matrix_entries = data.get("ise", {}).get("trust_sec", {}).get("matrix_entries", [])

        results = [
            f"security group - {sgt} configured under matrix_entries {security_group.get('source_sgt')}-{security_group.get('destination_sgt')} is not defined in trustsec security_groups data model"
            for security_group in matrix_entries
            for sgt in [security_group.get("source_sgt"), security_group.get("destination_sgt")]
            if sgt and sgt not in all_security_groups
        ]

        ip_sgt_mappings = data.get("ise", {}).get("trust_sec", {}).get("ip_sgt_mappings", [])

        results.extend([
            f"security group - {mapping.get('sgt')} configured under ip_sgt_mappings is not defined in trustsec security_groups data model"
            for mapping in ip_sgt_mappings
            if mapping.get('sgt') and mapping.get('sgt') not in all_security_groups
        ])

        ip_sgt_mapping_groups = data.get("ise", {}).get("trust_sec", {}).get("ip_sgt_mapping_groups", [])

        results.extend([
            f"security group - {group.get('sgt')} configured under ip_sgt_mapping_groups {group.get('name')} is not defined in trustsec security_groups data model"
            for group in ip_sgt_mapping_groups
            if group.get('sgt') and group.get('sgt') not in all_security_groups
        ])

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