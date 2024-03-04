import json
import math
import pprint
import random
import re
import textwrap

import google.generativeai as palm
import numpy as np

from json_files.master_task import master_tasks
from json_files.task_users import task_user_1, task_user_2
from keyconfig import gemini as palm_api
from palm_sequence import prompt_gemini

palm.configure(api_key=palm_api)
random.seed(69)


def replace_options(tasks, food_options):
    for task_id, task_description in tasks.items():
        if "(options =" in task_description:
            start_index = task_description.find("(options = ") + len("(options = ")
            end_index = task_description.find(")")
            options = task_description[start_index:end_index].split(", ")
            for i in range(len(options)):
                option = options[i]
                if option in food_options:
                    task_description = task_description.replace(
                        option, str(food_options[option])
                    )
                    tasks[task_id] = task_description
    return tasks


def remove_parentheses(text):
    return re.sub(r"\s*\([^)]*\)", "", text).strip()


models = [
    m for m in palm.list_models() if "generateText" in m.supported_generation_methods
]
model = models[0].name

f = open("./json_files/object_2.json", "r")
objects = json.load(f)
f.close()

f = open("./json_files/receptacle.json", "r")
receptacles = json.load(f)
f.close()

f = open("./json_files/task.json", "r")
task_sample_space = json.load(f)
f.close()

f = open("./json_files/sequence_1.json", "r")
sequences = json.load(f)
f.close()

f = open("./json_files/food.json", "r")
food = json.load(f)
f.close()

task_sample_space = replace_options(task_sample_space, food)

f = open("./json_files/task_resource.json", "r")
resource_mapping = json.load(f)
f.close()

f = open("./json_files/task_phrase.json", "r")
phrase_mapping = json.load(f)
f.close()

f = open("./json_files/task_resource.json", "r")
resource_mapping = json.load(f)
f.close()

with open("data/h1_corrected_format.json") as f:
    household_responses = json.load(f)


# for i in range(10):
#     # random_key = random.choice(list(task_sample_space.keys()))
#     # task = task_sample_space[random_key]
#     task = random.choice(task_user_2)
#     # if "fire" in task:
#     #     continue
#     # if "clothes" in task or "room" in task:
#     #     pass
#     # else:
#     #     task = remove_parentheses(task)

#     print(
#         "You see the user perform the task: ",
#         task,
#         "\n What do you anticipate to be the next 4 tasks?",
#     )

#     task = "It is morning time, the user has prepared his breakfast \n You see the user perform the task:  \n *serve the food (boiled eggs) (location=office table)* \n What do you anticipate to be the next 4 tasks? \n Requirement: The kitchen is very dirty\n"
#     op_dict = prompt_gemini(task, user=1)
#     import pdb

#     resource_found = False
#     for task in op_dict["tasks"]:
#         if task in resource_mapping.keys():
#             print(f"Resource {resource_mapping[task]} is not available")
#             resource_found = True

#     if not resource_found:
#         print("No resource found")

#     task_phrase = random.choice(list(phrase_mapping.keys()))
#     print("Requirement: ", phrase_mapping[task_phrase])

#     print("------------------------------------")

#     pdb.set_trace()

# common_ratio = list()
# llm_requirement_satisfied = list()
# user_requirement_satisfied = list()
# llm_resource_used = list()
# user_resource_used = list()
# for scenes in list(household_responses.keys()):
#     scene_details = household_responses[scenes]["details"]
#     required_task = household_responses[scenes]["required_task"]
#     # print("scene details: ", scene_details)
#     if "not_required_task" in household_responses[scenes].keys():
#         not_required_task = household_responses[scenes]["not_required_task"]
#     else:
#         not_required_task = None
#     required_task = remove_parentheses(required_task)
#     op_dict = prompt_gemini(scene_details, user=1)
#     op_tasks = op_dict["tasks"]
#     print(op_tasks)
#     op_tasks = [remove_parentheses(task) for task in op_tasks]
#     op_tasks = [
#         (
#             "prepare food"
#             if task in ["prepare breakfast", "prepare lunch", "prepare dinner"]
#             else task
#         )
#         for task in op_tasks
#     ]
#     if len(op_tasks) > 4:
#         op_tasks = op_tasks[:4]
#     if required_task in op_tasks:
#         llm_requirement_satisfied.append(1)
#     else:
#         llm_requirement_satisfied.append(0)
#         # breakpoint()

#     if not_required_task and not_required_task in op_tasks:
#         llm_resource_used.append(1)
#     else:
#         llm_resource_used.append(0)

#     response_users = [
#         key for key in household_responses[scenes].keys() if key.startswith("user")
#     ]
#     for user in response_users:
#         user_tasks = household_responses[scenes][user]
#         user_tasks = [remove_parentheses(task) for task in user_tasks]
#         user_tasks = [
#             (
#                 "prepare food"
#                 if task in ["prepare breakfast", "prepare lunch", "prepare dinner"]
#                 else task
#             )
#             for task in user_tasks
#         ]

#         if len(user_tasks) > 4:
#             user_tasks = user_tasks[:4]

#         if required_task in user_tasks:
#             user_requirement_satisfied.append(1)
#         else:
#             user_requirement_satisfied.append(0)

#         if not_required_task and not_required_task in user_tasks:
#             user_resource_used.append(1)
#         else:
#             user_resource_used.append(0)

#         print(f"User {user} tasks: ", user_tasks)
#         print(f"Predicted tasks: ", op_tasks)
#         print("Overlap: ", set(user_tasks).intersection(op_tasks))
#         print("-------------------------------------------------")

#         common_ratio.append(len(set(user_tasks).intersection(op_tasks)) / 4)
#         # if len(set(user_tasks).intersection(op_tasks)) == 0:

# print("Common tasks: ", sum(common_ratio) / len(common_ratio))
# print(
#     "LLM requirement satisfied: ",
#     sum(llm_requirement_satisfied) / len(llm_requirement_satisfied),
# )
# print(
#     "User requirement satisfied: ",
#     sum(user_requirement_satisfied) / len(user_requirement_satisfied),
# )
# print("LLM resource used: ", sum(llm_resource_used) / len(llm_resource_used))
# print("User resource used: ", sum(user_resource_used) / len(user_resource_used))
# breakpoint()


alpha = np.zeros([3, 3, 5])
breakpoint()


for scene in list(household_responses.keys())[:5]:
    del household_responses[scene]["user_1"]


for scn_id, scenes in enumerate(household_responses.keys()):
    if scn_id == 5:
        break
    scene_details = household_responses[scenes]["details"]
    response_users = list(household_responses[scenes].keys())[1:]
    for user1_id, user in enumerate(response_users):
        user_tasks = household_responses[scenes][user]
        # user_tasks = [remove_parentheses(task) for task in user_tasks]
        for user2_id, user2 in enumerate(response_users):
            user2_tasks = household_responses[scenes][user2]
            # user2_tasks = [remove_parentheses(task) for task in user2_tasks]
            overlap = set(user_tasks).intersection(user2_tasks)

            print(f"{user} and {user2} overlap: ", len(overlap))
            alpha[user1_id][user2_id][scn_id] = len(overlap)

        print("-------------------------------------------------")

print(np.mean(alpha, axis=-1))
print(np.mean(alpha))
breakpoint()
