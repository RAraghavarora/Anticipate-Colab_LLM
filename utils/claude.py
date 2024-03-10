import json
import os

import anthropic
from json_files.master_task import master_tasks
from keyconfig import claude_api

from .misc_utils import (count_folders, extract_op_string, remove_parentheses,
                         replace_options, write_file)
from .prompts import inp1, inp2, op1_cot, op2_cot

client = anthropic.Anthropic(api_key=claude_api)
model_name = "claude-3-opus-20240229"

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
def get_messages(task, icl=True, cot=True):
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
    ]
    if icl == True:
        if cot == True:
            messages.append({"role": "user", "content": inp1})
            messages.append({"role": "assistant", "content": op1_cot})
            messages.append({"role": "user", "content": inp2})
            messages.append({"role": "assistant", "content": op2_cot})
        else:
            messages.append({"role": "user", "content": inp1})
            messages.append({"role": "assistant", "content": op1_cot})
            messages.append({"role": "user", "content": inp2})
            messages.append({"role": "assistant", "content": op2_cot})

    return messages


def claude_call(messages):
    response = client.messages.create(
        model="claude-3-opus-20240229",
        max_tokens=800,
        system=messages[0]["content"],
        messages=messages[1:],
    )
    return (response, messages[-1]["content"])


def prompt_claude(task, dirname, icl=True, cot=True, user=1):
    messages = get_messages(task)
    op_string_, message_content = claude_call(messages)
    op_string = op_string_.dict()["content"][0]["text"]
    messages.append({"role": "assistant", "content": op_string})
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
            print("Re-prompting Mr. Claude")
            op_string, message_content = claude_call(messages)
            try:
                op_string = op_string.dict()["content"][0]["text"]
            except Exception as e:
                breakpoint()
                print(e)
            print("Mr. Claude has responded again!")

    if not os.path.exists(f"llm_cache/{dirname}"):
        os.makedirs(f"llm_cache/{dirname}")

    if icl == True:
        if cot == True:
            write_file(message_content, f"llm_cache/{dirname}/claude_cot_prompt")
            write_file(op_string, f"llm_cache/{dirname}/claude_cot_response")
        else:
            write_file(message_content, f"llm_cache/{dirname}/claude_icl_prompt")
            write_file(op_string, f"llm_cache/{dirname}/claude_icl_response")
    else:
        write_file(message_content, f"llm_cache/{dirname}/claude_prompt")
        write_file(op_string, f"llm_cache/{dirname}/claude_response")

    return op_dict, messages
