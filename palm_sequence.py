import json
import math
import pprint
import random
import textwrap

from IPython.display import Markdown, display
import google.generativeai as palm
import numpy as np
from scipy.stats import kendalltau

from json_files.master_task import master_tasks
from keyconfig import gemini as palm_api

palm.configure(api_key=palm_api)


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

# print(task_sample_space)


inp1 = f"""
# The following tasks are possible in the household
tasks_sample_space = {task_sample_space}

# The following tasks were done by **USER 1** previously:
user_tasks = {sequences}

You are serving **USER 1** today.
It is morning time, the user has prepared his breakfast
You see the user perform the task:  
* serve the food (boiled eggs) *
What do you anticipate to be the next 4 tasks?
Requirement: The kitchen is very dirty
"""

op1 = """
{
    'chain-of-thought': "It is morning time, and the user will first finish the requirement by cleaning the kitchen. From the previous routine, we know that they cleans the living room in the morning, followed by setting up the office table for work. They also serve coffee with breakfast.",
    'tasks' = [
        "clean the room (kitchen)",
        "clean the room (living room)",
        "set up the office table",
        "serve a drink"
    ],
}
"""

inp2 = f"""
# The following tasks are possible in the household
tasks_sample_space = {task_sample_space}

# The following tasks were done by **User 1** previously:
user_tasks = {sequences}

You are serving **user 1** today.
It is the evening time, and user has not eaten dinner yet.
You see the user perform the task:  
prepare clothes (casual)
What do you anticipate to be the next 4 tasks?
Requirement: Spoiled food needs to be thrown
*Rice is not available*
"""

op2 = """
{
    'chain-of-thought': "We know that on evenings the user eats dinner and takes medicines. The user has not eaten yet, so they will first prepare and serve their dinner. Since the user takes his medicine after food in the evening, we can anticipate that the user will prepare medicines. We know that the spoiled food needs to be thrown, so the user will throw away leftover food. We see that the user has prepared casual clothes, so they will prepare a casual and fun dinner. Hence we can anticipate the user eating pizza.",
    'tasks' = [
        "throw away leftover food"
        "prepare food (pizza)",
        "serve the food (pizza)",
        "prepare medicines",
    ],
}
"""


def prompt_gemini(task, user=1):
    prompt = f"""
# The following tasks are possible in the household
tasks_sample_space = {task_sample_space}

# The following tasks were done by **User 1** and **User 2** previously:
user_tasks = {sequences}

You are serving **USER {user}** today.
{task}
The first task for the day is: "{task}".
Anticipate the next 4 tasks for the day.
Answer only as a valid python dictionary, with 2 keys: 'chain-of-thought', and 'tasks'. Keep tasks from the sample space: {master_tasks}
"""

    model = palm.GenerativeModel("gemini-pro")

    convo = model.start_chat(
        history=[
            {"role": "user", "parts": [inp1]},
            {"role": "model", "parts": [op1]},
            {"role": "user", "parts": [inp2]},
            {"role": "model", "parts": [op2]},
        ]
    )
    response = convo.send_message(prompt)
    import pdb

    while True:
        try:
            op_dict = eval(convo.last.text)
            if "tasks" not in op_dict.keys():
                raise Exception("Tasks key not found")

            while True:
                hallucination = False
                for task in op_dict["tasks"]:
                    if task not in master_tasks:
                        hallucination = True
                        response = convo.send_message(
                            f"Please provide tasks only from the sample space: {master_tasks}"
                        )
                        break
                if not hallucination:
                    break
            if len(op_dict["tasks"]) != 4:
                response = convo.send_message(
                    "Please anticipate a total of 4 next tasks."
                )
                break
        except Exception as e:
            try:
                op_string = convo.last.text
                start_index = op_string.find("{")
                end_index = op_string.rfind("}") + 1
                dict_string = op_string[start_index:end_index]

                # Using eval() to convert the string to a dictionary
                op_dict = eval(dict_string)
                break
            except Exception:
                pass

            print(e)
            import pdb

            # pdb.set_trace()
            response = convo.send_message(
                "Please provide output only as a valid python dict. When converting your output to a dict, we get the following error: "
                + str(e)
            )

    print(convo.last.text)
    return op_dict


def main():
    results = {}
    temperatures = [0.1, 0.01, 0.5, 0.9]
    for palm_temp in temperatures:
        final_tau = []
        final_missing = []
        unordered_count = 0
        hallucination_count = 0
        missing_count = 0
        task_count = 0
        ordered_count = 0
        hallucinations = []
        count = 0
        # if palm_temp == 0.2:
        #     import pdb; pdb.set_trace()
        while count < 500:
            while True:
                prompt = f"""
# The following tasks are possible in the household
tasks_sample_space = {task_sample_space}

# The following tasks were done by **User 1** and **User 2** previously:
user_tasks = {sequences}

You are serving **USER 2** today.
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
