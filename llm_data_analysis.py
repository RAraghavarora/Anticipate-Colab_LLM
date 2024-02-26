import csv
import csv
import json

import pandas as pd


def remove_columns(filename):
    h1_2 = pd.read_csv(filename)
    h1_2_cols = [col for col in h1_2.columns if col.startswith("Anticipated")]

    h1_2 = h1_2[h1_2_cols]
    print(h1_2.columns)
    h1_2.to_csv("household1_2_task.csv", index=False)


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


# csv_file = "data/household1_2_task.csv"
# json_data = csv_to_json(csv_file)


# with open("data/h1_2.json", "w") as file:
#     json.dump(json_data, file, indent=2)

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


final_data = rearrange_json("data/h1_2.json")

with open("data/h1_2_format.json", "w") as file:
    json.dump(final_data, file, indent=2)
