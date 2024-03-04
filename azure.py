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


gpt_call(messages)
breakpoint()


def get_gpt_op(task, user=1):
    prompt = f"""
# The following tasks are possible in the household
tasks_sample_space = {task_sample_space}

# The following tasks were done by **User 1** previously:
user_tasks = {sequences}

{task}
The first task for the day is: "{task}".
Anticipate the next 4 tasks for the day.
Answer only as a valid python dictionary, with key: 'tasks'. Keep tasks from the sample space: {master_tasks}
"""

    messages = [
        {
            "role": "system",
            "content": f"You are an intelligent agent common househelp agent that anticipates future tasks based on household's previous data. \n # The following tasks are possible in the household tasks_sample_space = {task_sample_space} \n # The following tasks were done by **USER 1** previously: \n user_tasks = {sequences}",
        },
        {
            "role": "user",
            "content": prompt,
        },
    ]
