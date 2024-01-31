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

f = open("./new_task.json", "r")
task_dict = json.load(f)
f.close()

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

# The following tasks were done in the last week:
task_last_week = {task_dict}

# For this week, these are the resources available:
Objects available: {objects}

Today is Wednesday
User Preference: All the dishes are dirty please clean them.
"""

op1 = """
{
    'chain of thought': "Following last Wednesday's routine. Add 'wash the dishes' as the 1st task to the task list, and keeping everything else the same.",
    'tasks' = [
        "Wash dirty dishes",
        "Wash dirty clothes",
        "Prepare breakfast (banana smoothie)",
        "Make the bed",
        "Clean the Room (Pantry Room)",
        "Prepare lunch (sandwich)",
        "Prepare dinner (veg stew)",
        "Clean the room (bedroom)",
        "Prepare medicines"
    ],
}
"""

with open("./prompt_try_llama.txt", "w") as f:
    f.write(inp1)


def main():
    results = {}
    temperatures = [0.1, 0.01, 0.5, 0.9]
    for palm_temp in temperatures:
        final_tau = []
        final_missing = []
        unordered_count = 0
        hallucination_count = 0
        missing_count = 0
        spot_on = 0
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

# The following tasks were done in the last week:
task_last_week = {task_dict}

# For this week, these are the resources available:
Objects available: {objects}

# Input: Today is Thursday. User Preference: I want to eat *seafood* for *dinner*.
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
