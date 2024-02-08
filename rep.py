import replicate
from keyconfig import replicate_key
import os
import json
import numpy as np
import math
from scipy.stats import kendalltau
from keyconfig import gemini as palm_api
import pprint
import google.generativeai as palm
import random

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
os.environ["REPLICATE_API_TOKEN"] = replicate_key

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

models = {
    "mistral": "mistralai/mistral-7b-v0.1",
    "llama": "meta/llama-2-70b-chat:02e509c789964a7ea8736978a43525956ef40397be9033abf9fd2badfe68c9e3",
    "mistral-8": "mistralai/mixtral-8x7b-instruct-v0.1",
    "llama-70b": "meta/llama-2-70b-chat",
}

model = "mistral-8"
prompt = f"""
# The following tasks are possible in the household
tasks_sample_space = {task_sample_space}

# The following tasks were done by **User 1** and **User 2** previously:
user_tasks = {sequences}

You are serving **USER 2** today.
You see the user pick up the vacuum cleaner.
Anticipate the next 4 tasks for the day.
Provide answer as a JSON object with the following keys: 'chain-of-thought', 'tasks'.
"""

output = replicate.run(
    models[model],
    input={
        "debug": False,
        "top_p": 1,
        "prompt": prompt,
        "temperature": 0.5,
        "system_prompt": f"Provide reply to every prompt in the same format as shown in the following example output, with tasks taken only from {task_sample_space} \n\n ### Example Input: {inp1}\n\n ### Example output: {op1}",
        # "system_prompt": "You are a helpful, respectful and honest assistant. Always answer as helpfully as possible, while being safe. Your answers should not include any harmful, unethical, racist, sexist, toxic, dangerous, or illegal content. Please ensure that your responses are socially unbiased and positive in nature.\n\nIf a question does not make any sense, or is not factually coherent, explain why instead of answering something not correct. If you don't know the answer to a question, please don't share false information.",
        "max_new_tokens": 5000,
        "min_new_tokens": -1,
    },
)

res = "".join(j for j in output)
print(res)
