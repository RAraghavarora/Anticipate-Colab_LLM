import csv
import csv
import itertools
import json

import pandas as pd


def remove_columns(filename):
    h1_2 = pd.read_csv(filename)
    h1_2_cols = [col for col in h1_2.columns if col.startswith("Anticipated")]

    h1_2 = h1_2[h1_2_cols]
    print(h1_2.columns)
    h1_2.to_csv("data/h1_corrected_task.csv", index=False)


def divide_into_groups(lst, group_size):
    return [lst[i : i + group_size] for i in range(0, len(lst), group_size)]


def csv_to_json(csv_file):
    json_data = {}
    with open(csv_file, "r") as file:
        reader = csv.DictReader(file)
        k = 0
        for row in reader:
            col_names = divide_into_groups(list(row.keys()), 4)
            for cols in col_names:
                answers = [row[key] for key in cols]
                if f"user_{k}" in json_data.keys():
                    json_data[f"user_{k}"].append(answers)
                else:
                    json_data[f"user_{k}"] = [answers]

            k += 1
    return json_data


remove_columns("data/h1_corrected.csv")
csv_file = "data/h1_corrected_task.csv"
json_data = csv_to_json(csv_file)

with open("data/h1_corrected.json", "w") as file:
    json.dump(json_data, file, indent=2)

# breakpoint()
# # Pretty print the JSON data
# print(json.dumps(json_data, indent=2))
# print(json_data.keys())


def rearrange_json(json_file):
    h1_2 = json.load(open(json_file, "r"))
    final_data = {}
    for scn_id in range(0, 10):
        final_data[f"scene_{scn_id}"] = {"details": "lorem ipsum"}

    for scn_id in range(0, 5):
        for question_number in range(0, 4):
            for user in h1_2.keys():
                # breakpoint()
                try:
                    final_data[f"scene_{scn_id}"][user] = h1_2[user][scn_id]
                except:
                    breakpoint()

    return final_data


final_data = rearrange_json("data/h1_corrected.json")

with open("data/h1_corrected_format.json", "w") as file:
    json.dump(final_data, file, indent=2)

# breakpoint()


def find_common_tasks(scene_data):
    common_tasks = {}
    for scene, users in scene_data.items():
        common_tasks[scene] = {}
        user_tasks = users.values()
        combinations = itertools.combinations(user_tasks, 2)
        for pair in combinations:
            breakpoint()
            common = set(pair[0]).intersection(pair[1])
            common_tasks[scene][pair] = common
    return common_tasks


# with open("data/h1_corrected_format.json") as f:
#     data = json.load(f)


# def compute_overlap(scene_data):
#     user_keys = list(scene_data.keys())[1:]

#     common_tasks = set(user_tasks[0])
#     for user_task in user_tasks[1:]:
#         common_tasks &= set(user_task)

#     # Calculate percentage overlap
#     total_tasks = len(user_tasks[0])
#     overlap_percentage = (len(common_tasks) / total_tasks) * 100

#     breakpoint()
#     return overlap_percentage


# overlap_percentage_scene_0 = compute_overlap(data["scene_0"])
# print(f"Percentage overlap in scene_0: {overlap_percentage_scene_0:.2f}%")
