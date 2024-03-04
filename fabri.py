#!/usr/bin/env python
# coding: utf-8

# In[11]:


from palm_sequence import prompt_gemini
import json
from azure import prompt_gpt
import random

# In[12]:


with open("data/h1_corrected_fabri.json") as f:
    household_responses = json.load(f)


# In[13]:


scenes = list(household_responses.keys())


# In[14]:


response_users = [
    key for key in household_responses[scenes[0]].keys() if key.startswith("user")
]
users_exist = len(response_users)
users_needed = 9

# In[7]:


for scene in scenes:
    scene_details = household_responses[scene]["details"]
    response_users = [
        key for key in household_responses[scene].keys() if key.startswith("user")
    ]
    rand_user = random.randint(3, 8)
    users = ["user_1", f"user_{rand_user}"]
    for user in users:
        op_dict = prompt_gpt(scene_details)
        op_tasks = op_dict["tasks"]
        household_responses[scene][user] = op_tasks


# In[8]:


with open("data/h1_corrected_fabri.json", "w") as file:
    json.dump(household_responses, file, indent=2)


# In[ ]:
