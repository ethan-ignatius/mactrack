from openai import OpenAI
#from dotenv import load_dotenv
import base64
import json
import sys


#load_dotenv()


api_key = ''

client = OpenAI(api_key=api_key)

def get_nutrition_from_image(image_path):
    with open(image_path, "rb") as image:
        base64_image = base64.b64encode(image.read()).decode("utf-8")

    response = client.chat.completions.create(
        model="gpt-4o",
        response_format={"type": "json_object"},
        messages=[
            {
                "role": "system",
                "content": """You are a dietitian. A user sends you an image of a meal and you tell them how many calories, protein, trains fat, saturated fat, and cholesterol are in it. Use the following JSON format:

{s
    "reasoning": "reasoning for the total calories, protein, trains fat, saturated fat, carbohydrates, and cholesterol",
    "food_items": [
        {
            "name": "food item name",
            "calories": "calories in the food item",
            "protein": "protein in grams",
            "trans_fat": "trans fat in grams",
            "saturated_fat": "saturated fat in grams",
            "sugar":"sugar in grams",
            "carbohydrates:" "carbohydrates in grams",
            "cholesterol:" "cholesterol in miligrams"
        }
    ],
    "total": "total calories, protein, trains fat, saturated fat, carbohydrates, and cholesterol"
}"""
            },
            {
                "role": "user",
                "content": [
                    {
                        "type": "text",
                        "text": "How many calories, protein, trains fat, saturated fat, carbohydrates, and cholesterol are in this meal?"
                    },
                    {
                        "type": "image_url",
                        "image_url": {
                            "url": f"data:image/jpeg;base64,{base64_image}"
                        }
                    }
                ]
            },
        ],
    )

    response_message = response.choices[0].message
    content = response_message.content

    return json.loads(content)

if __name__ == "__main__":
    image_path = sys.argv[1]
    nutrition = get_nutrition_from_image(image_path)
    print(json.dumps(nutrition, indent=4))