import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var userSession: UserSession  // Access the userSession object for user_id
    @State private var selectedImage: UIImage? = nil
    @State private var message: String = ""
    @State private var nutritionData: [String: Any] = [:]
    @State private var isImagePickerPresented = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var isActionSheetPresented = false  // For presenting options to choose between camera or gallery
    @State private var isMenuVisible = false  // Track if the side menu is visible

    var body: some View {
        ZStack {
            // Main Dashboard Content
            VStack {
                Spacer()

                ScrollView {
                    // Display selected image (if available)
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .padding()
                    }

                    Text("Welcome to MacTrack.")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding()

                    Text("Scan your meal to see a breakdown of its macronutrients.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding()

                    // Scan Button
                    Button(action: {
                        self.isActionSheetPresented = true
                    }) {
                        Text("SCAN YOUR MEAL")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(10)
                            .padding(.horizontal, 40)
                    }
                    .actionSheet(isPresented: $isActionSheetPresented) {
                        ActionSheet(
                            title: Text("Choose an option"),
                            message: Text("Select your meal scanning option."),
                            buttons: [
                                .default(Text("Camera")) {
                                    self.sourceType = .camera
                                    self.isImagePickerPresented = true
                                },
                                .default(Text("Gallery")) {
                                    self.sourceType = .photoLibrary
                                    self.isImagePickerPresented = true
                                },
                                .cancel()
                            ]
                        )
                    }
                    .sheet(isPresented: $isImagePickerPresented) {
                        ImagePicker(selectedImage: self.$selectedImage, isPresented: self.$isImagePickerPresented, sourceType: self.sourceType)
                    }

                    // Display Macronutrient Information
                    if !nutritionData.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Macronutrient Breakdown:")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.bottom, 10)

                            if let reasoning = nutritionData["reasoning"] as? String {
                                Text(reasoning)
                                    .italic()
                                    .padding(.bottom, 10)
                            }

                            if let foodItems = nutritionData["food_items"] as? [[String: Any]] {
                                ForEach(Array(foodItems.enumerated()), id: \.offset) { _, food in
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text("Food: \(food["name"] as? String ?? "N/A")")
                                            .font(.headline)
                                        Text("Calories: \(food["calories"] as? Int ?? 0)")
                                        Text("Protein: \(food["protein"] as? Double ?? 0) g")
                                        Text("Trans Fat: \(food["trans_fat"] as? Int ?? 0) g")
                                        Text("Saturated Fat: \(food["saturated_fat"] as? Int ?? 0) g")
                                        Text("Sugar: \(food["sugar"] as? Int ?? 0) g")
                                        Text("Carbohydrates: \(food["carbohydrates"] as? Int ?? 0) g")
                                        Text("Cholesterol: \(food["cholesterol"] as? Int ?? 0) mg")
                                    }
                                    .padding(.vertical, 5)
                                    Divider()
                                }
                            }

                            if let total = nutritionData["total"] as? [String: Any] {
                                Text("Total:")
                                    .font(.headline)
                                    .padding(.top, 10)
                                Text("Total Calories: \(total["calories"] as? Int ?? 0)")
                                Text("Total Protein: \(total["protein"] as? Double ?? 0) g")
                                Text("Total Trans Fat: \(total["trans_fat"] as? Int ?? 0) g")
                                Text("Total Saturated Fat: \(total["saturated_fat"] as? Int ?? 0) g")
                                Text("Total Sugar: \(total["sugar"] as? Int ?? 0) g")
                                Text("Total Carbohydrates: \(total["carbohydrates"] as? Int ?? 0) g")
                                Text("Total Cholesterol: \(total["cholesterol"] as? Int ?? 0) mg")
                            }
                        }
                        .padding(.horizontal, 40)
                    } else if !message.isEmpty {
                        Text(message)
                            .foregroundColor(.red)
                            .padding()
                    }
                }

                Spacer()
            }
            .padding()

            // Hamburger Menu Button
            VStack {
                HStack {
                    Button(action: {
                        withAnimation {
                            self.isMenuVisible.toggle()
                        }
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .resizable()
                            .frame(width: 25, height: 20)
                            .foregroundColor(.black)
                            .padding(.leading)
                    }
                    Spacer()
                }
                Spacer()
            }

            // Side Menu - Position at the left edge
            HStack(spacing: 0) {
                if isMenuVisible {
                    SideMenuView(isMenuVisible: $isMenuVisible)
                        .frame(width: 250)
                        .transition(.move(edge: .leading))  // Slide in from the left
                }
                Spacer()
            }
        }
        .onChange(of: selectedImage) { image in
            if let image = image {
                uploadImageAndAnalyze(image: image)
            }
        }
    }

    // Upload Image and Analyze for Macronutrient Information
    func uploadImageAndAnalyze(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            DispatchQueue.main.async {
                self.message = "Failed to process image."
            }
            return
        }

        guard let url = URL(string: "https://82ce-128-61-27-239.ngrok-free.app/scan-meal") else {
            DispatchQueue.main.async {
                self.message = "Invalid URL."
            }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        // Append boundary
        body.append("--\(boundary)\r\n".data(using: .utf8)!)

        // Append user_id field
        body.append("Content-Disposition: form-data; name=\"user_id\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(userSession.userId)\r\n".data(using: .utf8)!)

        // Append image field with correct key
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"meal.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)

        // Append closing boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.message = "Failed to upload image: \(error.localizedDescription)"
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                DispatchQueue.main.async {
                    self.message = "Failed to analyze meal. Status code: \((response as? HTTPURLResponse)?.statusCode ?? 0)"
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.message = "No data received from server."
                }
                return
            }

            // Parse the server's JSON response
            if let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let nutritionData = jsonResponse["nutrition_data"] as? [String: Any] {
                DispatchQueue.main.async {
                    self.nutritionData = nutritionData
                    self.message = "Meal Analysis Successful!"
                }
            } else {
                DispatchQueue.main.async {
                    self.message = "Failed to parse server response."
                }
            }
        }.resume()
    }
}
