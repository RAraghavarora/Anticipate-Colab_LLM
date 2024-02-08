import json
import math
import pprint
import random

import google.generativeai as palm
import numpy as np
from scipy.stats import kendalltau

from keyconfig import gemini as palm_api

palm.configure(api_key=palm_api)

models = [
    m for m in palm.list_models() if "generateText" in m.supported_generation_methods
]
model = models[0].name

f = open("./object_2.json", "r")
objects = json.load(f)
f.close()

f = open("./receptacle.json", "r")
receptacles = json.load(f)
f.close()

f = open("./task.json", "r")
task_sample_space = json.load(f)
f.close()

f = open("./sequence.json", "r")
sequences = json.load(f)
f.close()

import textwrap

from IPython.display import Markdown, display


def to_markdown(text):
    text = text.replace("•", "  *")
    return Markdown(textwrap.indent(text, "> ", predicate=lambda _: True))


inp1 = f"""
# The following tasks are possible in the household
tasks_sample_space = {task_sample_space}

# The following tasks were done by **User 1** and **User 2** previously:
user_tasks = {sequences}

You are serving **user 1** today. You see the user pick up the vacuum cleaner. Anticipate the next 3 tasks for the day.
"""

op1 = """
{
    'chain-of-thought': "We see that the **USER 1** cleans the living room in the morning. He must be using the vacuum cleaner to clean the room. After cleaning the room, he sets up the office table, and serves a healthy breakfast with coffee to the office table.",
    'tasks' = [
        "Clean the room (living room) (using vacuum cleaner)",
        "prepare breakfast (boiled eggs)",
        "set up the office table",
    ],
}
"""


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
