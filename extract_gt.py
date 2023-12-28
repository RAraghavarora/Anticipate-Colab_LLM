import json
import re
# FILEPATH: /home2/raghav.arora/rearrange/RRC-HRC-Task-Anticipation/extract_gt.py

def load_json(path):
    with open(path) as file:
        json_data = json.load(file)
    return json_data

def get_approx_time_for_task(tasks, given_task):
    for task in tasks.values():
        task_name_words = task["task_name"].lower().split()

        if all(word in given_task.lower() for word in task_name_words):
            return task['approx_time'].split()[0]
    return None

def get_tasks_for_day(timetable, tasks):
    for day in timetable.keys():
        given_tasks = timetable[day]['steps']
        total_time = 0
        day_tasks = []
        for given_task in given_tasks:
            try:
                time = int(get_approx_time_for_task(tasks, given_task))
            except Exception as e:
                import pdb; pdb.set_trace()
            total_time += time
            day_tasks.append(given_task)
            store_match = re.search(r'\bserve\b', given_task, flags=re.IGNORECASE)
            if store_match:
            


        print(day)
        print(day_tasks)
        print(total_time)




tasks = load_json('new_task.json')
timetable = load_json('try_gt.json')

get_tasks_for_day(timetable, tasks)