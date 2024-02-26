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

f = open("./json_files/sequence.json", "r")
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

with open("data/household1.json") as f:
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

common_count = 0

for scenes in household_responses.keys():
    scene_details = household_responses[scenes]["details"]
    op_dict = prompt_gemini(scene_details, user=1)
    op_tasks = op_dict["tasks"]
    response_users = list(household_responses[scenes].keys())[1:]
    for user in response_users:
        user_tasks = household_responses[scenes][user]
        user_tasks = [remove_parentheses(task) for task in user_tasks]
        op_tasks = [remove_parentheses(task) for task in op_tasks]
        print(f"User {user} tasks: ", user_tasks)
        print(f"Predicted tasks: ", op_tasks)
        print("Overlap: ", set(user_tasks).intersection(op_tasks))
        print("-------------------------------------------------")

        common_count += len(set(user_tasks).intersection(op_tasks))

print("Common tasks: ", common_count)
