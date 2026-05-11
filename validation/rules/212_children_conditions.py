class Rule:
    id = "212"
    description = "Validate if children conditions have correct attributes"
    severity = "HIGH"

    @classmethod
    def validate_condition(cls, condition, condition_types, key, results, rule):
        if condition.get("type", "") not in condition_types:
            results.append(
                f"Condition type {condition.get('type', {}) } in {key} - {rule.get('name')} is not valid"
                )
    
    @classmethod
    def validate_attributes(cls, condition, supported_keys, key, results, rule):
        extra_attributes = [key for key in condition.keys() if key not in supported_keys]
        if extra_attributes:
            results.append(
                f"Condition type {condition.get('type', {}) } in {key} - {rule.get('name')} is not valid, unsupported attributes = {','.join(extra_attributes)}"
            )

    @classmethod
    def validate_empty_children_nested_condition(cls, condition, condition_types, key, results, supported_keys, rule):
        if condition.get('type', {}) in condition_types:
            if not condition.get("children"):
                results.append(
                    f"Condition type {condition.get('type', {}) } in {key} - {rule.get('name')} is not valid"
                    )
            else:
                cls.validate_attributes(condition, supported_keys, key, results, rule)
    
    @classmethod
    def validate_level_two_children(cls, level_one_childrens, condition_types, key, results, supported_keys_nested, rule):
        for level_one_children in level_one_childrens:
            cls.validate_empty_children_nested_condition(level_one_children, condition_types, key, results, supported_keys_nested, rule)
            level_two_children =  level_one_children.get("children")
            if level_two_children:
                cls.validate_attributes(level_one_children, supported_keys_nested, key, results, rule)
                cls.validate_condition(level_one_children, condition_types, key, results, rule)
    
    @classmethod
    def validate_conditions(cls, rule_key, rules, results, library_conditions=False):
        default_conditions = {
            "library": {
                "conditions": ["LibraryConditionAndBlock", "LibraryConditionOrBlock", "LibraryConditionAttributes"],
                "nested": ["LibraryConditionAndBlock", "LibraryConditionOrBlock"],
                "children": ["ConditionAndBlock", "ConditionOrBlock"],
                "supported_keys_nested": ["is_negate", "children", "type", "name", "description"]
            },
            "regular": {
                "conditions": ["ConditionAndBlock", "ConditionOrBlock", "ConditionReference", "ConditionAttributes"],
                "nested": ["ConditionAndBlock", "ConditionOrBlock"],
                "children": ["ConditionAndBlock", "ConditionOrBlock"],
                "supported_keys_nested": ["is_negate", "children", "type", "name", "description"]
            }
        }
        condition_types = default_conditions["library" if library_conditions else "regular"]
        
        if not library_conditions:
            for rule in rules:
                condition = rule.get("condition", {})
                cls.validate_library_and_children_condition(condition, condition_types, rule_key, results, rule)
        else:
            for condition in rules:
                cls.validate_condition(condition, condition_types["conditions"], rule_key, results, condition)
                cls.validate_library_and_children_condition(condition, condition_types, rule_key, results, condition)

    @classmethod
    def validate_library_and_children_condition(cls, condition, condition_types, rule_key, results, rule):
        level_one_childrens = condition.get("children", [])
        cls.validate_empty_children_nested_condition(condition, condition_types["nested"], rule_key, results, condition_types["supported_keys_nested"], rule)
        if level_one_childrens:
            cls.validate_condition(condition, condition_types["nested"], rule_key, results, rule)
            cls.validate_attributes(condition, condition_types["supported_keys_nested"], rule_key, results, rule)
            cls.validate_level_two_children(level_one_childrens, condition_types["children"], rule_key, results, condition_types["supported_keys_nested"], rule)

    @classmethod
    def match(cls, data):
        results = []
        data_models = ["network_access", "device_administration"]
        for item in data_models:
            data_model = data.get("ise", {}).get(item, {})
            policy_set_keys = ["authentication_rules", "authorization_exception_rules", "authorization_rules"]            
            
            authorization_global_exception_rules = data_model.get("authorization_global_exception_rules", [])
            if authorization_global_exception_rules:
                cls.validate_conditions("authorization_global_exception_rules", authorization_global_exception_rules, results)

            policy_sets = data_model.get("policy_sets", [])
            if policy_sets:
                cls.validate_conditions("policy_sets", policy_sets, results)
                for policy_set in policy_sets:
                    for key in policy_set_keys:
                        value = policy_set.get(key, [])
                        if value:
                            cls.validate_conditions(key, value, results)
            
            policy_elements_conditions = data_model.get("policy_elements", {}).get("conditions", [])
            if policy_elements_conditions:
                cls.validate_conditions("policy_elements_condition", policy_elements_conditions, results, library_conditions=True)

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