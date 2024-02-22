import json
import random


def replace_options(tasks, food_options):

    for task_id, task_description in tasks.items():
        if "(options =" in task_description:
            start_index = task_description.find("(options = ") + len("(options = ")
            end_index = task_description.find(")")
            options = task_description[start_index:end_index].split(", ")
            print(options)
            print("\n\n")
            for i in range(len(options)):
                option = options[i]
                if option in food_options:
                    task_description = task_description.replace(
                        option, str(food_options[option])
                    )
                    tasks[task_id] = task_description

    return tasks


f = open("./json_files/task.json", "r")
task_sample_space = json.load(f)
f.close()

f = open("./json_files/food.json", "r")
food = json.load(f)
f.close()

task_sample_space = replace_options(task_sample_space, food)
print(task_sample_space)
