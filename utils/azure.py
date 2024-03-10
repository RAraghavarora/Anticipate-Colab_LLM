import json
import os

import openai
from json_files.master_task import master_tasks
from keyconfig import shivam_gpt

from .misc_utils import (count_folders, extract_op_string, remove_parentheses,
                         write_file)
from .prompts import inp1, inp2, op1_cot, op2_cot

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


f = open("./json_files/task.json", "r")
task_sample_space = json.load(f)
f.close()

f = open("./json_files/sequence_1.json", "r")
sequences = json.load(f)
f.close()

f = open("./json_files/food.json", "r")
food = json.load(f)
f.close()

# task_sample_space = replace_options(task_sample_space, food)


def replace_options(tasks, food_options):
    """
    Replace the options in the tasks with the corresponding values from
    the food options.
    """
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


def get_messages(task):
    """
    task: str
    Takes a task description and returns the messages to be sent to the GPT API
    """
    prompt = f"""
# The following tasks are possible in the household
tasks_sample_space = {master_tasks}

# The following tasks were done by **User 1** previously:
user_tasks = {sequences}

{task}
Anticipate the next 4 tasks for the day.
Answer only as a valid python dictionary, with keys: 'tasks' and 'chain-of-thought'. Keep tasks from the sample space."""

    messages = [
        {
            "role": "system",
            "content": f"""You are an intelligent househelp agent that anticipates future tasks based on household's previous data. You need to observe pattern of tasks done by a user and decide the next 4 tasks for the day. You can use the following information to anticipate the tasks:
# The following tasks are possible in the household tasks_sample_space = {master_tasks}
# The following observations were made for **USER 1** previously:
user_tasks = {sequences}""",
        },
        {"role": "user", "content": inp1},
        {"role": "assistant", "content": op1_cot},
        {"role": "user", "content": inp2},
        {"role": "assistant", "content": op2_cot},
        {"role": "user", "content": prompt},
    ]

    return messages


def gpt_call(messages):
    response = openai.ChatCompletion.create(
        # engine="Task_Anticipation", # raghav gpt 3.5
        # engine="gpt4",  #raghav gpt 4
        engine="first",  # 'first'
        # engine="gpt4",  #pranay gpt 4
        messages=messages,
        temperature=0.7,
        max_tokens=800,
        top_p=0.95,
        frequency_penalty=0,
        presence_penalty=0,
        stop=None,
    )
    return (response, messages[-1]["content"])


def prompt_gpt(task, dirname, user=1):
    messages = get_messages(task)
    op_string_, message_content = gpt_call(messages)
    op_string = op_string_.choices[0].message["content"]
    while True:
        try:
            op_dict = extract_op_string(op_string)
            if "tasks" not in op_dict.keys():
                raise Exception("Tasks key not found in output")
            elif len(op_dict["tasks"]) != 4:
                raise Exception("Number of tasks is not equal to 4")
            elif any(task not in master_tasks for task in op_dict["tasks"]):
                invalid_tasks = [
                    task for task in op_dict["tasks"] if task not in master_tasks
                ]
                raise Exception(
                    f"Tasks should be from the master task list. \n The following tasks are invalid: {invalid_tasks} \n\n List of master tasks:{master_tasks}"
                )
            break
        except Exception as e:
            print(e)
            messages.append(
                {
                    "role": "user",
                    "content": "Please provide output only as a valid python dict. When evaluating, we get the following error: "
                    + str(e),
                }
            )
            print("Re-prompting Mr. GPT")
            op_string, message_content = gpt_call(messages)
            op_string = op_string.choices[0].message["content"]
            print("Mr. GPT has responded again!")

    if not os.path.exists(f"llm_cache/{dirname}"):
        os.makedirs(f"llm_cache/{dirname}")

    write_file(message_content, f"llm_cache/{dirname}/gpt_prompt")
    write_file(op_string, f"llm_cache/{dirname}/gpt_response")

    return op_dict, messages
