# MacTrack

**MacTrack** is a mobile application that helps users track the macronutrient content of their meals by scanning images of their food. The app uses image recognition technology to break down the calories, protein, carbohydrates, and fat in meals and displays this information in a user-friendly dashboard. Additionally, the app provides users with a daily summary of their macronutrient intake. 

## Features

- **User Sign-Up and Login**: Users can create accounts and securely log in to the app.
- **Meal Scanning**: Users can take a picture of their meal using the camera or upload one from the gallery. The app processes the image through a server and returns detailed macronutrient information for the meal.
- **Daily Summary**: A breakdown of the total macronutrients consumed during the day, based on all meals scanned.
- **Hamburger Menu Navigation**: Easy-to-use side menu for navigating between the dashboard, daily summary, information page, and login options.
- **Persistent User Sessions**: The app saves the user’s session and tracks individual user data for meal history and summaries.

## Technologies Used

- **SwiftUI**: The app is built with SwiftUI for the frontend, offering a smooth and modern user interface.
- **MongoDB**: Stores user information and meal data for retrieval and daily summaries.
- **Flask (Python)**: Backend server handles requests for meal scanning, user authentication, and the daily macronutrient summary.
- **RESTful API**: Facilitates communication between the frontend and backend to process meal images and handle user interactions.
- **Firebase**: Authentication and session management are powered by Firebase.

## Installation and Setup

### Prerequisites

- **Xcode**: The app is built with SwiftUI, so Xcode is required for development.
- **CocoaPods**: If using external dependencies, ensure that CocoaPods is installed.
- **Backend Server**: A Flask-based Python server is needed to handle the processing of meal images and user data. Ensure MongoDB is set up and Flask is running.

### Steps to Run

1. Clone the repository:

    ```bash
    git clone https://github.com/your-username/mactrack.git
    ```

2. Navigate to the project directory:

    ```bash
    cd mactrack
    ```

3. Open the project in Xcode:

    ```bash
    open MacTrack.xcodeproj
    ```

4. Install any dependencies using CocoaPods (if applicable):

    ```bash
    pod install
    ```

5. Set up the backend Flask server by following the instructions in the `server/README.md` file. Make sure MongoDB is running.

6. Run the app on the iOS Simulator or a physical device through Xcode.

### Backend Setup

To set up the backend:

1. Clone the backend repository (if separate) or navigate to the `server` folder in this repository.
   
2. Install dependencies and start the Flask server.

    ```bash
    pip install -r requirements.txt
    flask run
    ```

### API Endpoints

- **User Signup**: `POST /signup`
- **User Login**: `POST /login`
- **Meal Scan**: `POST /scan-meal`
- **Daily Summary**: `GET /daily-summary`

For more details about how to set up and run the server, refer to the `server/README.md` file.

## How it Works

1. **User Login**: After signing up, users log in to the app using their credentials. Upon successful login, they are taken to the dashboard.
2. **Meal Scanning**: From the dashboard, users can upload an image of their meal (or capture one using the camera), which is sent to the backend for analysis.
3. **Nutrient Breakdown**: The app retrieves detailed macronutrient information for the meal and displays it on the dashboard.
4. **Daily Summary**: Users can navigate to the daily summary page via the hamburger menu to see a total of all macronutrients for that day.

## Contributing

If you want to contribute to this project, feel free to fork the repository and submit a pull request with your proposed changes.

## License

MacTrack is released under the MIT License. See `LICENSE` for more information.
