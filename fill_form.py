import requests

# Pre-filled URL
prefilled_url = "https://docs.google.com/forms/d/e/1FAIpQLSdxkgtxwyKRvZtDdFUnHzEftukxY4LwkourM1sFZSWznNX1KA/formResponse"

# Pre-filled values
prefilled_values = [
    {
        "entry.2002209823": "do the laundry",
        "entry.469090603": "prepare office clothes",
        "entry.362487312": "prepare food",
        "entry.1493893009": "serve the food",
        "entry.703942533": "boiled eggs",
        "entry.558524365": "clean the room (kitchen)",
        "entry.406494981": "prepare food",
        "entry.275074734": "serve the food",
        "entry.766556375": "prepare medicines",
        "entry.727983683": "rice",
        "entry.572264686": "clean the room (livingroom)",
        "entry.2022372840": "clean the room (kitchen)",
        "entry.625053570": "wash the dishes",
        "entry.191239155": "dust electronic surfaces",
        "entry.895951198": "prepare food",
        "entry.230544255": "serve the food",
        "entry.763490937": "wash the dishes",
        "entry.994245127": "put remaining food in the fridge",
        "entry.63329724": "cereal",
        "entry.1356387271": "prepare gym clothes",
        "entry.50310746": "clean the room (livingroom)",
        "entry.480372629": "serve the food",
        "entry.154898115": "prepare medicines",
        "entry.1948053379": "rice",
    },
    # Repeat this dictionary structure with your pre-filled values as needed
]


# Function to submit the form
def submit_form(prefilled_values):
    for values in prefilled_values:
        response = requests.post(prefilled_url, data=values)
        if response.status_code == 200:
            print("Form submitted successfully")
        else:
            print(f"Failed to submit form. Status code: {response.status_code}")


# Submit the form 10 times
for _ in range(10):
    submit_form(prefilled_values)
