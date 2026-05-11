class Rule:
    id = "209"
    description = "Verify if referenced network device group exist"
    severity = "HIGH"

    @classmethod
    def process_group(cls, group, path=None):
        if path is None:
            path = []
        name = group["name"]
        if group.get("path"):
            root_path = group.get("path")

            if root_path == 'Is IPSEC Device':
                root_path = ["Is IPSEC Device"]
            elif root_path == 'All Locations':
                root_path = ["All Locations"]
            elif root_path == 'All Device Types':
                root_path = ["All Device Types"]
            new_path = root_path + path + [name]
        else:
            new_path = path + [name]

        children = group.get("children", [])
        paths = []
        for child in children:
            paths.extend(cls.process_group(child, new_path))

        if not children:  # If this group has no children, return the path
            full_path = "#".join(new_path)
            paths.append(full_path)

        return paths


    @classmethod
    def match(cls, data):
        results = []
        default_network_device_groups = [
            "Is IPSEC Device",
            "Is IPSEC Device#Yes",
            "Is IPSEC Device#No",
            "All Device Types",
            "All Locations",
            "DNAC#DNAC Devices"
        ]

        ## network device groups
        network_device_groups = []

        # Start processing from the root groups
        for group in data.get("ise", {}).get("network_resources", {}).get("network_device_groups", []):
            network_device_groups.extend(cls.process_group(group))

        all_network_device_groups = list(
            set(network_device_groups + default_network_device_groups)
        )

        devices = data.get("ise", {}).get("network_resources", {}).get("network_devices", [])
        for device in devices:
            device_groups = device.get("network_device_groups", [])
            for device_group in device_groups:
                if device_group and device_group not in all_network_device_groups:
                    results.append(
                        f"Network Device Group - {device_group} configured under network device {device.get('name')} is not defined in network_device_groups data model"
                    )

        results = list(set(results))

        return results


# ## UNCOMMENT TO TEST RULE LOCALLY
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