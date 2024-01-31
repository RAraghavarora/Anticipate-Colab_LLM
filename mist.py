from mistralai.client import MistralClient
from mistralai.models.chat_completion import ChatMessage
import os

#Read the API key from the file
def open_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as infile:
        return infile.read()

#Begin Interacting with Mistal AI to get a response
def get_mistral_response(user_content):
    #Use API Key now
    api_key = open_file("mistapikey.txt")
    model = "mistral-small"
    client = MistralClient(api_key=api_key)

    #Messages to User Content
    messages = [ChatMessage(role="user", content=user_content)]

    #Response to the asked message
    chat_response = client.chat(model=model, messages=messages)

    try:
        #Use the content from the Mistral's Response
        response_content = chat_response.choices[0].message.content if chat_response.choices else ""
    except AttributeError as e:
        print(f"An error occured while processing the response: {e}")
        response_content = ""

    #Return the content from the response
    return response_content

CYAN = '\033[96m'
YELLOW = '\033[93m'
RESET_COLOR = '\033[0m'

#USAGE
user_content = "Script to be provided here ...."

response = get_mistral_response(user_content)
print(f"{CYAN}{response}{RESET_COLOR}")

#API = MWa6fiAqftrOM5ftZ2w5buQ1VI4jmzLj