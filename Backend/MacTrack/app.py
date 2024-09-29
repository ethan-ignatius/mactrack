from flask import Flask, request, jsonify
from flask_cors import CORS
import certifi
from pymongo import MongoClient
from dotenv import load_dotenv
from MacTrack import get_nutrition_from_image
import bcrypt
import os
from datetime import datetime

app = Flask(__name__)
CORS(app)
# Load environment variables from .env file
load_dotenv()

# MongoDB connection
MONGO_URI = os.getenv("MONGO_URI")
client = MongoClient(
    "ENTER CONNECTION STRING",
    tlsCAFile=certifi.where()  # This ensures proper SSL certificate verification
)
db = client["MacTrack"]
users_collection = db["Users"]
nutrition_collection = db["Nutrition"]

@app.route('/')
def home():
    return "Flask server is running!"

### User Registration (Sign-Up)
@app.route('/signup', methods=['POST'])
def signup():
    data = request.json
    username = data['username']
    password = data['password']

    # Check if the username is already taken
    if users_collection.find_one({ "username": username }):
        return jsonify({"error": "Username already taken"}), 400

    # Hash the password
    password_hash = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())

    # Store the new user in MongoDB
    user_record = {
        "username": username,
        "password_hash": password_hash,
        "date_joined": datetime.now()
    }
    users_collection.insert_one(user_record)

    return jsonify({"message": "User created successfully"}), 201


### User Login
@app.route('/login', methods=['POST'])
def login():
    data = request.json
    username = data['username']
    password = data['password']

    # Find the user by username
    user = users_collection.find_one({ "username": username })

    if user:
        # Check if the provided password matches the stored hashed password
        if bcrypt.checkpw(password.encode('utf-8'), user['password_hash']):
            return jsonify({"message": "Login successful", "user_id": str(user['_id'])}), 200
        else:
            return jsonify({"error": "Invalid password"}), 401
    else:
        return jsonify({"error": "User not found"}), 404


### Save Nutrition Data
@app.route('/save-nutrition', methods=['POST'])
def save_nutrition():
    data = request.json
    user_id = data['user_id']
    nutrition_data = data['nutrition_data']

    # Store the nutrition data with the user ID
    nutrition_record = {
        "user_id": user_id,
        "date_scanned": datetime.now(),
        "nutrition_data": nutrition_data
    }
    nutrition_collection.insert_one(nutrition_record)

    return jsonify({"message": "Nutrition data saved successfully"}), 201


### Get User's Nutrition Data
@app.route('/get-nutrition/<user_id>', methods=['GET'])
def get_nutrition(user_id):
    user_nutrition = nutrition_collection.find({ "user_id": user_id })
    nutrition_list = []

    for record in user_nutrition:
        nutrition_list.append({
            "date_scanned": record["date_scanned"],
            "nutrition_data": record["nutrition_data"]
        })

    return jsonify(nutrition_list), 200


### Handle Meal Scanning (Image Upload)
@app.route('/scan-meal', methods=['POST'])
def scan_meal():
    # Get the image file and user ID from the request
    image_file = request.files['image']
    user_id = request.form['user_id']

    # Save the image temporarily
    image_path = f"./uploads/{image_file.filename}"
    image_file.save(image_path)

    # Process the image using OpenAI to get nutrition data
    nutrition_data = get_nutrition_from_image(image_path)

    # Save the nutrition data along with the user ID
    nutrition_record = {
        "user_id": user_id,
        "date_scanned": datetime.now(),
        "nutrition_data": nutrition_data
    }
    nutrition_collection.insert_one(nutrition_record)

    return jsonify({"message": "Meal processed and nutrition data saved", "nutrition_data": nutrition_data}), 200


@app.route('/daily-summary', methods=['POST'])
def daily_summary():
    data = request.json
    user_id = data.get("user_id")

    if not user_id:
        return jsonify({"error": "User ID is required"}), 400

    # Get today's date
    today = datetime.now().date()

    # Find all nutrition entries for the user for the current day
    meals = nutrition_collection.find({
        "user_id": user_id,
        "date_scanned": {"$gte": datetime(today.year, today.month, today.day)}
    })

    total_nutrients = {
        "calories": 0,
        "protein": 0,
        "trans_fat": 0,
        "saturated_fat": 0,
        "sugar": 0,
        "carbohydrates": 0,
        "cholesterol": 0
    }

    # Sum up the nutrients for each meal
    for meal in meals:
        meal_nutrition = meal.get("nutrition_data", {}).get("total", {})

        # Check if meal_nutrition is a dictionary before calling .get()
        if isinstance(meal_nutrition, dict):
            total_nutrients["calories"] += int(meal_nutrition.get("calories", 0))
            total_nutrients["protein"] += float(meal_nutrition.get("protein", 0))
            total_nutrients["trans_fat"] += int(meal_nutrition.get("trans_fat", 0))
            total_nutrients["saturated_fat"] += int(meal_nutrition.get("saturated_fat", 0))
            total_nutrients["sugar"] += int(meal_nutrition.get("sugar", 0))
            total_nutrients["carbohydrates"] += int(meal_nutrition.get("carbohydrates", 0))
            total_nutrients["cholesterol"] += int(meal_nutrition.get("cholesterol", 0))
        else:
            # Log or handle the case where the total nutrients is not in the expected format
            print(f"Unexpected format for meal_nutrition: {meal_nutrition}")

    return jsonify({"total_nutrients": total_nutrients}), 200


if __name__ == '__main__':
    # Create 'uploads' directory if it doesn't exist to store the images temporarily
    if not os.path.exists('uploads'):
        os.makedirs('uploads')

    app.run(debug=True)
