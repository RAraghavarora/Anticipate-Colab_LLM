import json
import os
import re

from json_files.master_task import master_tasks
from utils import count_folders, extract_op_string, prompt_gemini, prompt_gpt


def compare_llm_responses(llm, household_responses):
    scenes = list(household_responses.keys())
    llm_overlap = list()
    llm_overlap_value = list()
    expts = count_folders("llm_cache/" + scenes[0])
    expts = 25
    scene_counter = 0
    for expt in range(expts):
        for scn in scenes:
            cache_dir = f"llm_cache/{scn}/{expt}"
            if llm == "gemini":
                cache_file = cache_dir + "/gemini_response"
            elif llm == "gpt":
                cache_file = cache_dir + "/gpt_response"
            elif llm == "gemini_nocot":
                cache_file = cache_dir + "/gemini_response_nocot"
            elif llm == "claude_cot":
                cache_file = cache_dir + "/claude_cot_response"
            elif llm == "claude":
                cache_file = cache_dir + "/claude_response"
            with open(cache_file, "r") as f:
                llm_response = f.read()

            llm_response = llm_response.replace("living_room", "livingroom")
            with open(cache_file, "w") as f:
                f.write(llm_response)
            op_dict = extract_op_string(llm_response)
            llm_tasks = op_dict["tasks"]
            llm_tasks = [
                (
                    "prepare food"
                    if "breakfast" in task.lower()
                    or "lunch" in task.lower()
                    or "dinner" in task.lower()
                    else task
                )
                for task in llm_tasks
            ]

            valid_tasks = True
            for task in llm_tasks:
                if task not in master_tasks:
                    valid_tasks = False

            # if len(llm_tasks) == 0 or not valid_tasks:
            #     op_dict, convo = prompt_gemini(
            #         household_responses[scn]["details"],
            #         f"scene_{scene_counter}/{expt}",
            #         user=1,
            #     )
            #     llm_response = convo.last.text
            #     llm_tasks = op_dict["tasks"]
            #     if len(llm_tasks) < 4:
            #         convo.send_message(
            #             "Please provide exactly 4 tasks from the sample space! Provide output as a dict with 2 keys: chain-of-thought' and 'tasks'."
            #         )
            #         llm_response = convo.last.text

            #     valid_tasks = True
            #     for task in op_dict["tasks"]:
            #         if task not in master_tasks:
            #             valid_tasks = False
            #             break
            #     if not valid_tasks:
            #         convo.send_message(
            #             f"Please output tasks from the possible task lists only: {master_tasks}"
            #         )
            #         llm_response = convo.last.text
            #     with open(cache_file, "w") as f:
            #         f.write(llm_response)
            #     op_dict = extract_op_string(llm_response)
            #     llm_tasks = op_dict["tasks"]

            scene_counter += 1
            response_users = [
                key
                for key in list(household_responses[scn].keys())
                if key.startswith("user")
            ]
            for user in response_users:
                user_tasks = household_responses[scn][user]
                overlap = set(user_tasks).intersection(set(llm_tasks))
                llm_overlap.append(overlap)
                llm_overlap_value.append(len(overlap) / 4)
                if len(overlap) <= 1:
                    print(scn)

    print(len(llm_overlap_value))
    print("Total overlap:", sum(llm_overlap_value) / len(llm_overlap_value))
    print(
        "Over 50% overlap:",
        sum([1 for x in llm_overlap if len(x) >= 2]) / len(llm_overlap),
    )
    print(
        "Over 75% overlap:",
        sum([1 for x in llm_overlap if len(x) >= 3]) / len(llm_overlap),
    )
    print("Over 100% overlap:", sum([1 for x in llm_overlap if len(x) == 4]) / len(llm_overlap))
    breakpoint()


if __name__ == "__main__":
    llm = "claude"  # 'gemini' or 'gpt'
    with open("data/h1_corrected_fabri_1.json") as f:
        household_responses = json.load(f)
    scenes = list(household_responses.keys())
    compare_llm_responses(llm, household_responses)
