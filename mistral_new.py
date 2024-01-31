import replicate

# Read the prompt from a file
with open('prompt.txt', 'r') as file:
    prompt = file.read()

# The mistralai/mistral-7b-v0.1 model can stream output as it's running.
for event in replicate.stream(
    "mistralai/mistral-7b-v0.1",
    input={
        "debug": False,
        "top_k": -1,
        "top_p": 0.95,
        "prompt": "prompt = f'''\n# The following tasks are possible in the household\ntasks_sample_space = {task_sample_space}\n\n# The following tasks were done in the last week:\ntask_last_week = {task_dict}\n\n# For this week, these are the resources available:\nObjects available: {objects}\n\n# Input: Today is Thursday. User Preference: I want to eat *seafood* for *dinner*.\n'''\n",
        "temperature": 0.7,
        "max_new_tokens": 50000,
        "min_new_tokens": -1,
        "prompt_template": "{prompt}",
        "repetition_penalty": 1.15
    },
):
    print(str(event), end="")