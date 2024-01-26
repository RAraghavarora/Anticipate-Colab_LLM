import json
import numpy as np
import math
from scipy.stats import kendalltau
from keyconfig import gemini as palm_api
import pprint
import google.generativeai as palm
import random

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

from IPython.display import display
from IPython.display import Markdown
import textwrap


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
                import pdb

                pdb.set_trace()

                completion = palm.generate_text(
                    model=model,
                    prompt=prompt,
                    temperature=palm_temp,
                    # The maximum length of the response
                    max_output_tokens=1000,
                    # candidate_count = 8
                )

                if completion.result:
                    # import pdb; pdb.set_trace()
                    print("Working temp = ", palm_temp)
                    break
                else:
                    print("Not working temp = ", palm_temp)
            import pdb

            pdb.set_trace()
            for candidate in completion.candidates[:1]:
                task_count += len(final_combined_lists_op) + len(
                    final_combined_lists_ip
                )
                code_to_execute = candidate["output"].strip()  # Removing triple quotes

                env = {}
                try:
                    exec(code_to_execute, env)
                except Exception as e:
                    print(e)
                    print("why bro?")
                    continue

                try:
                    routine_3_output = env["routine_3_output"]
                except:
                    print("Error in execution?")
                    try:
                        routine_3_output = eval(code_to_execute)
                    except:
                        print("Error in execution.")
                        import pdb

                        pdb.set_trace()
                        continue
                import pdb

                pdb.set_trace()
                tau, missing = kendal_tau(
                    routine_3_output, final_combined_lists_op, final_seq
                )
                final_tau.append(tau)
                final_missing.append(missing)
                all_sequences = [
                    sequence
                    for sub_sequence in sequences.values()
                    for sequence in sub_sequence
                ]

                temp = [x for x in routine_3_output if x not in set(all_sequences)]

                if len(temp) > 0:
                    hallucination_count += 1
                    hallucinations.extend(temp)

                sanity = sanity_check(routine_3_output, sequences)
                if sanity:
                    ordered_count += 1
                else:
                    unordered_count += 1

                count += 1

                print(count)

        results[palm_temp] = {
            "Average Ordered count": ordered_count / count,
            "Average Hallucination count": hallucination_count / count,
            "Average Missing count": missing_count / count,
            "Average Unordered count": unordered_count / count,
            "Average Hallucinations": len(hallucinations) / count,
            "Average tau per prompt": np.mean(final_tau),
            "Average missing per prompt": np.mean(final_missing),
            "Total missing": np.sum(final_missing),
            "Average task count": task_count / count,
        }

    for temp, result in results.items():
        print(f"Temperature: {temp}")
        for key, value in result.items():
            print(f"{key}: {value}")
        print("\n")


if __name__ == "__main__":
    main()
