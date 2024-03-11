import os

base_dir = 'llm_cache'

for root, dirs, files in os.walk(base_dir):
    for file in files:
        if file == 'gemini_prompt':
            os.rename(os.path.join(root, file), os.path.join(root, 'gemini_cot_prompt'))
        elif file == 'gemini_response':
            os.rename(os.path.join(root, file), os.path.join(root, 'gemini_cot_response'))
        elif file == 'gpt_prompt':
            os.rename(os.path.join(root, file), os.path.join(root, 'gpt35_cot_prompt'))
        elif file == 'gpt_response':
            os.rename(os.path.join(root, file), os.path.join(root, 'gpt35_cot_response'))
        elif file == 'gemini_nocot_prompt':
            os.rename(os.path.join(root, file), os.path.join(root, 'gemini_icl_prompt'))
        elif file == 'gemini_nocot_response':
            os.rename(os.path.join(root, file), os.path.join(root, 'gemini_icl_response'))
print("Done")
