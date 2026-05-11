class Rule:
    id = "203"
    description = "Verify if referenced user identity groups exist"
    severity = "HIGH"

    @classmethod
    def match(cls, data):
        results = []
        user_identity_groups = []
        default_user_identity_groups = [
            "ALL_ACCOUNTS (default)",
            "Employee",
            "GROUP_ACCOUNTS (default)",
            "GuestType_Contractor (default)",
            "GuestType_Daily (default)",
            "GuestType_SocialLogin (default)",
            "GuestType_Weekly (default)",
            "OWN_ACCOUNTS (default)",
        ]

        def collect_children_groups(obj):
            # Get the name of the current object
            name = obj.get("name")
            if name:
                user_identity_groups.append(name)

            # Recursively check if there are children and process them
            children = obj.get("children", [])
            for child in children:
                collect_children_groups(child)

        # Traverse the top-level groups
        for obj in data.get("ise", {}).get("identity_management", {}).get("user_identity_groups", []):
            collect_children_groups(obj)

        all_user_identity_groups = list(
            set(user_identity_groups + default_user_identity_groups)
        )

        ## Internal user
        for internal_user in data.get("ise", {}).get("identity_management", {}).get("internal_users", []):
            user_identity_groups = internal_user.get("user_identity_groups")
            if user_identity_groups is not None:
                for group in user_identity_groups:
                    if group not in all_user_identity_groups:
                        results.append(
                            f"user_identity_group - {group} under user - {internal_user['name']} is not defined in identity_management -> user_identity_groups data model"
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
