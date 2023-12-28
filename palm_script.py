import json
import numpy as np
import math
from scipy.stats import kendalltau
from keyconfig import gemini as palm_api
import pprint
import google.generativeai as palm
import random
palm.configure(api_key=palm_api)

models = [m for m in palm.list_models() if 'generateText' in m.supported_generation_methods]
model = models[0].name

import random

f = open('./new.json', 'r')
task_dict = json.load(f)
f.close()

f = open('./object.json', 'r')
objects = json.load(f)
f.close()

f = open('./receptacle.json', 'r')
receptacles = json.load(f)
f.close()

from IPython.display import display
from IPython.display import Markdown
import textwrap

def to_markdown(text):
  text = text.replace('•', '  *')
  return Markdown(textwrap.indent(text, '> ', predicate=lambda _: True))


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
        while count<500:
            while True:
                
                prompt = f'''
# These are the tasks in the last week:
tasks_sample_space = {task_dict}

# For this week, these are the resources available:
Resources:
Objects available: {objects}
Receptacles available: {receptacles}

# Example input: Today is wednesday, all the clothes are clean
# Example output:
tasks = [
    "Wash dirty dishes",
    "Prepare banana smoothie",
    "Clean the Pantry Room",
    "Prepare soup",
    "Tend to the garden",
    "Prepare veg stew",
    "Clean the bedroom"
  ]

# Input: Today is Thursday, we are out of tea
Anticipate the tasks for today
'''
                model = palm.GenerativeModel('gemini-pro')
                response = model.generate_content(prompt)
                print(response.text)
                import pdb; pdb.set_trace()

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
            import pdb; pdb.set_trace()
            for candidate in completion.candidates[:1]:
                task_count += len(final_combined_lists_op) + len(final_combined_lists_ip)
                code_to_execute = candidate['output'].strip()  # Removing triple quotes

                env = {}
                try:
                    exec(code_to_execute, env)
                except Exception as e:
                    print(e)
                    print('why bro?')
                    continue
                
                try:
                    routine_3_output = env['routine_3_output']
                except:
                    print('Error in execution?')
                    try:
                        routine_3_output = eval(code_to_execute)
                    except:
                        print('Error in execution.')
                        import pdb; pdb.set_trace()
                        continue
                import pdb; pdb.set_trace()
                tau, missing = kendal_tau(routine_3_output, final_combined_lists_op, final_seq)
                final_tau.append(tau)
                final_missing.append(missing)
                all_sequences = [sequence for sub_sequence in sequences.values() for sequence in sub_sequence]

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
            'Average Ordered count': ordered_count / count,
            'Average Hallucination count': hallucination_count / count,  
            'Average Missing count': missing_count / count,  
            'Average Unordered count': unordered_count / count,  
            'Average Hallucinations': len(hallucinations) / count,  
            'Average tau per prompt': np.mean(final_tau),  
            'Average missing per prompt': np.mean(final_missing),  
            'Total missing': np.sum(final_missing),  
            'Average task count': task_count / count  
        }

    for temp, result in results.items():  
        print(f'Temperature: {temp}')  
        for key, value in result.items():  
            print(f'{key}: {value}')  
        print('\n')  

if __name__ == '__main__':
    main()