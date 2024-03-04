import json
import math
import random
import re
import time

import numpy as np
import openai
from scipy.stats import kendalltau
from tqdm import tqdm

from json_files.master_task import master_tasks
from keyconfig import shivam_gpt

openai.api_type = "azure"
# openai.api_base = "https://taskanticipation-gpt.openai.azure.com/"     # raghav gpt 3.5
# openai.api_base = "https://gpt4-taskanticipation.openai.azure.com/"      # raghav gpt 4
# openai.api_base = "https://task-anticipation-gpt3.openai.azure.com/"  # ahana gpt 3.5
# openai.api_base = "https://gptaccess.openai.azure.com/"      # pranay gpt 4
openai.api_base = "https://shivam.openai.azure.com/"
openai.api_version = "2023-07-01-preview"
# openai.api_key = raghav_gpt3
# openai.api_key = raghav_gpt4
openai.api_key = shivam_gpt
# openai.api_key = pranay_key


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


def gpt_call(messages):
    response = openai.ChatCompletion.create(
        # engine="Task_Anticipation", # raghav gpt 3.5
        # engine="gpt4",  #raghav gpt 4
        engine="first",
        # engine="gpt4",  #pranay gpt 4
        messages=messages,
        temperature=0.7,
        max_tokens=800,
        top_p=0.95,
        frequency_penalty=0,
        presence_penalty=0,
        stop=None,
    )
    return response


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


# gpt_call(messages)
# breakpoint()


def prompt_gpt(task, user=1):
    prompt = f"""
# The following tasks are possible in the household
tasks_sample_space = {task_sample_space}

# The following tasks were done by **User 1** previously:
user_tasks = {sequences}

{task}
Anticipate the next 4 tasks for the day.
Answer only as a valid python dictionary, with keys: 'tasks' and 'chain-of-thought'. Keep tasks from the sample space: {master_tasks}
"""

    messages = [
        {
            "role": "system",
            "content": f"""You are an intelligent agent common househelp agent that anticipates future tasks based on household's previous data.
# The following tasks are possible in the household tasks_sample_space = {task_sample_space}
# The following tasks were done by **USER 1** previously:
user_tasks = {sequences}""",
        },
        {
            "role": "user",
            "content": """
It is morning time, the user has prepared his breakfast
You see the user perform the task:  
* serve the food *
What do you anticipate to be the next 4 tasks?
Requirement: The kitchen is very dirty            
""",
        },
        {
            "role": "assistant",
            "content": """
{
    'chain-of-thought': "To start, we need to finish the requirement by cleaning the kitchen. It is morning time, and from the previous routine, we know that they prepare office clothes, charge electronic devices, and prepare the office bag",
        "clean the room (kitchen)",
        "prepare the office bag",
        "charge electronic devices",
        "prepare office clothes"
    ],
}
""",
        },
        {
            "role": "user",
            "content": """
            It is morning time, the user has to go to the office.
            You see the user perform the task:
            *prepare the office bag*
            What do you anticipate to be the next 4 tasks?
            Requirement: The office clothes are dirty"
            """,
        },
        {
            "role": "assistant",
            "content": """
{
'chain-of-thought': "Before going to the office, the user needs to prepare office clothes, but since the office clothes are dirty, they need to do the laundry first. After that, they need to charge the electronic devices and prepare food",
"tasks": [
"do the laundry",
"prepare office clothes",
"charge the electronic devices",
"prepare food"
],
}
""",
        },
        {
            "role": "user",
            "content": prompt,
        },
    ]
    print("Calling Mr. GPT")
    op_string = gpt_call(messages)
    print("Mr. GPT has responded")
    op_string = op_string.choices[0].message["content"]
    while True:
        try:
            try:
                op_dict = eval(op_string)
            except:
                start_index = op_string.find("{")
                end_index = op_string.rfind("}") + 1
                dict_string = op_string[start_index:end_index]
                op_dict = eval(dict_string)

            if "tasks" not in op_dict.keys():
                raise Exception("Tasks key not found in output")
                # elif len(op_dict["tasks"]) != 4:
                #     raise Exception("Number of tasks is not equal to 4")
                # elif any(task not in master_tasks for task in op_dict["tasks"]):
                #     invalid_tasks = [
                #         task for task in op_dict["tasks"] if task not in master_tasks
                #     ]
                #     raise Exception(
                #         f"Tasks should be from the master task list. \n The following tasks are invalid: {invalid_tasks} \n\n List of master tasks:{master_tasks}"
                #     )
            break
        except Exception as e:
            print(e)
            # if counter == 2:
            #     breakpoint()
            messages.append(
                {
                    "role": "user",
                    "content": "Please provide output only as a valid python dict. When evaluating, we get the following error: "
                    + str(e),
                }
            )
            print("Re-prompting Mr. GPT")
            op_string = gpt_call(messages)
            print("Mr. GPT has responded again!")
    print("exiting azure")
    return op_dict
