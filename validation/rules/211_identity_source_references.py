class Rule:
    id = "211"
    description = "Verify if referenced identity source exist"
    severity = "HIGH"


    @classmethod
    def match(cls, data):
        results = []
        default_identity_sources = ["Internal Users", "Guest Users", "Internal Endpoints", "All_AD_Join_Points"]
        active_directories = []

        ad_join_points = data.get("ise", {}).get("identity_management", {}).get("active_directories", [])
        for ad in ad_join_points:
            active_directories.append(ad.get("name"))


        all_identity_sources = list(set(default_identity_sources + active_directories))

        identity_source_sequences = data.get("ise", {}).get("identity_management", {}).get("identity_source_sequences", [])
        for seq in identity_source_sequences:
            for identity_source in seq.get("identity_sources", []):
                if identity_source not in all_identity_sources:
                    results.append(
                        f"Identity Source - {identity_source} configured under identity source sequenes {seq.get('name')} is not defined"
                    )

        # authentication rule identity_source_name reference
        default_auth_identities = ["All_User_ID_Stores", "Certificate_Request_Sequence", "Guest_Portal_Sequence", "MyDevices_Portal_Sequence", "Sponsor_Portal_Sequence", "Preloaded_Certificate_Profile", "DenyAccess"]
        
        identity_source_seq = data.get("ise", {}).get("identity_management", {}).get("identity_source_sequences", [])
        for sequence in identity_source_seq:
            default_auth_identities.append(sequence.get("name"))

        certificate_authentication_prof = data.get("ise", {}).get("identity_management", {}).get("certificate_authentication_profiles", [])
        for profile in certificate_authentication_prof:
            default_auth_identities.append(profile.get("name"))

        all_identities = default_auth_identities + all_identity_sources

        policy_sets = data.get("ise", {}).get("network_access", {}).get("policy_sets", [])
        for policy_set in policy_sets:
            for rule in policy_set.get("authentication_rules", []):
                identity = rule.get('identity_source_name')
                if identity and identity not in all_identities:
                    results.append(
                        f"Identity Source - {identity} configured under network access policy-set {policy_set.get('name')} -> authentication_rule {rule.get('name')} is not defined"
                    )

        policy_sets = data.get("ise", {}).get("device_administration", {}).get("policy_sets", [])
        for policy_set in policy_sets:
            for rule in policy_set.get("authentication_rules", []):
                identity = rule.get('identity_source_name')
                if identity and identity not in all_identities:
                    results.append(
                        f"Identity Source - {identity} configured under device access policy-set {policy_set.get('name')} -> authentication_rule {rule.get('name')} is not defined"
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