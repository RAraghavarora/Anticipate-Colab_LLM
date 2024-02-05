import replicate
from keyconfig import replicate_key
import os

os.environ["REPLICATE_API_TOKEN"] = replicate_key

# print(replicate.models.list())

models = {
    "mistral": "mistralai/mistral-7b-v0.1",
    "llama": "meta/llama-2-70b-chat:02e509c789964a7ea8736978a43525956ef40397be9033abf9fd2badfe68c9e3",
    "mistral-8": "mistralai/mixtral-8x7b-instruct-v0.1",
    "llama-70b": "meta/llama-2-70b-chat",
}

model = "mistral-8"

output = replicate.run(
    models[model],
    input={
        "debug": False,
        "top_p": 1,
        "prompt": "What is the capital of France?",
        "temperature": 0.5,
        "system_prompt": "You are a helpful, respectful and honest assistant. Always answer as helpfully as possible, while being safe. Your answers should not include any harmful, unethical, racist, sexist, toxic, dangerous, or illegal content. Please ensure that your responses are socially unbiased and positive in nature.\n\nIf a question does not make any sense, or is not factually coherent, explain why instead of answering something not correct. If you don't know the answer to a question, please don't share false information.",
        "max_new_tokens": 5000,
        "min_new_tokens": -1,
    },
)

res = "".join(j for j in output)
print(res)
