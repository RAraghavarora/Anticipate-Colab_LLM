import json
import math
import random
import re
import time

import numpy as np
import openai
from scipy.stats import kendalltau
from tqdm import tqdm

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


messages = [
    {
        "role": "system",
        "content": "You are an intelligent agent common househelp agent that anticipates future tasks based on previous days' data",
    },
    {
        "role": "user",
        "content": "Without any explanation, complete the following python script by adding your reasoning and anticipation for routine_3_output as a list:\n",
    },
]

gpt_call(messages)
breakpoint()
