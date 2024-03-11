import json
import os

import google.generativeai as palm
from json_files.master_task import master_tasks
from keyconfig import gemini as palm_api

from .misc_utils import write_file
from .prompts import inp1, inp2, op1_cot, op2_cot

palm.configure(api_key=palm_api)

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

op1_nocot = """
{
    'tasks' = [
        "clean the room (kitchen)",
        "clean the room (living_room)",
        "set up the office table",
        "serve a drink"
    ],
}
"""
op2_nocot = """
{
    'tasks' = [
        "throw away leftover food"
        "prepare food",
        "serve the food",
        "prepare medicines",
    ],
}
"""


def prompt_gemini(task, dirname, icl=True, cot=True, user=1):
    if icl == False or cot == False:
        del sequences["user 1"]["description"]
        prompt = f"""
# The following tasks are possible in the household
tasks_sample_space = {master_tasks}

# The following tasks were done by **User 1** previously:
user_tasks = {sequences}

{task}
    
Answer only as a valid python dictionary, with a key: 'tasks'. Number of tasks should be 4! Keep tasks from the sample space.
"""
    else:
        prompt = f"""
# The following tasks are possible in the household
tasks_sample_space = {master_tasks}

# The following tasks were done by **User 1** previously:
user_tasks = {sequences}

{task}
    
Answer only as a valid python dictionary, with a key: 'tasks'. Number of tasks should be 4! Keep tasks from the sample space.
"""

    model = palm.GenerativeModel("gemini-1.0-pro-latest")
    if icl == True:
        if cot == True:
            convo = model.start_chat(
                history=[
                    {"role": "user", "parts": [inp1]},
                    {"role": "model", "parts": [op1_cot]},
                    {"role": "user", "parts": [inp2]},
                    {"role": "model", "parts": [op2_cot]},
                ]
            )
        elif cot == False:
            convo = model.start_chat(
                history=[
                    {"role": "user", "parts": [inp1]},
                    {"role": "model", "parts": [op1_nocot]},
                    {"role": "user", "parts": [inp2]},
                    {"role": "model", "parts": [op2_nocot]},
                ]
            )

    else:
        convo = model.start_chat(history=[])
    _ = convo.send_message(prompt)

    counter = 0
    while True:
        print(counter)
        counter += 1
        try:
            try:
                op_dict = eval(convo.last.text)
            except:
                op_string = convo.last.text
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
            response = convo.send_message(
                "Please provide output only as a valid python dict. When evaluating, we get the following error: "
                + str(e)
            )

    if not os.path.exists(f"llm_cache/{dirname}"):
        os.makedirs(f"llm_cache/{dirname}")

    if icl == True:
        if cot == True:
            write_file(prompt, f"llm_cache/{dirname}/gemini_cot_prompt")
            write_file(convo.last.text, f"llm_cache/{dirname}/gemini_cot_response")
        else:
            write_file(prompt, f"llm_cache/{dirname}/gemini_icl_prompt")
            write_file(convo.last.text, f"llm_cache/{dirname}/gemini_icl_response")
    else:
        write_file(prompt, f"llm_cache/{dirname}/gemini_prompt")
        write_file(convo.last.text, f"llm_cache/{dirname}/gemini_response")

    return op_dict, convo


def main():
    while True:
        prompt = f"""
# The following tasks are possible in the household
tasks_sample_space = {master_tasks}

# The following tasks were done by **User 1** and **User 2** previously:
user_tasks = {sequences}

You are serving **USER 1** today.
You see the user open the microwave.
Anticipate the next 4 tasks for the day.
"""
        model = palm.GenerativeModel("gemini-pro")
        model2 = palm.GenerativeModel("palm-2")
        print(model2)
        convo = model.start_chat(
            history=[
                {"role": "user", "parts": [inp1]},
                {"role": "model", "parts": [op1]},
                # {
                #     "role": "user",
                #     "parts": [inp2]
                # },
                # {
                #     "role": "model",
                #     "parts": [op2]
                # },
            ]
        )
        response = convo.send_message(prompt)
        print(convo.last.text)
        feedback = input("Enter feedback: ")
        while feedback != "exit":
            response = convo.send_message(feedback)
            print(convo.last.text)
            feedback = input("Enter feedback: ")


if __name__ == "__main__":
    main()
