import SwiftUI

struct DailySummaryView: View {
    @EnvironmentObject var userSession: UserSession  // Access the userSession object for user_id
    @State private var totalNutrients: [String: Any] = [:]  // Store total nutrients
    @State private var message: String = ""  // For error or status messages

    var body: some View {
        VStack {
            Text("Daily Macronutrient Summary")
                .font(.largeTitle)
                .padding()

            if !totalNutrients.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Total Macronutrients for Today:")
                        .font(.headline)

                    Text("Total Calories: \(totalNutrients["calories"] as? Int ?? 0)")
                    Text("Total Protein: \(totalNutrients["protein"] as? Double ?? 0) g")
                    Text("Total Trans Fat: \(totalNutrients["trans_fat"] as? Int ?? 0) g")
                    Text("Total Saturated Fat: \(totalNutrients["saturated_fat"] as? Int ?? 0) g")
                    Text("Total Sugar: \(totalNutrients["sugar"] as? Int ?? 0) g")
                    Text("Total Carbohydrates: \(totalNutrients["carbohydrates"] as? Int ?? 0) g")
                    Text("Total Cholesterol: \(totalNutrients["cholesterol"] as? Int ?? 0) mg")
                }
                .padding()
            } else if !message.isEmpty {
                Text(message)
                    .foregroundColor(.red)
                    .padding()
            } else {
                Text("Fetching your macronutrient summary...")
                    .italic()
                    .padding()
            }

            Spacer()
        }
        .onAppear {
            fetchDailySummary()
        }
    }

    // Function to make API call
    func fetchDailySummary() {
        guard let url = URL(string: "https://82ce-128-61-27-239.ngrok-free.app/daily-summary") else {
            DispatchQueue.main.async {
                self.message = "Invalid URL."
            }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Prepare the body with user ID
        let body: [String: Any] = ["user_id": userSession.userId]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        // Perform the API call
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.message = "Failed to fetch data: \(error.localizedDescription)"
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                DispatchQueue.main.async {
                    self.message = "Failed to fetch data. Status code: \((response as? HTTPURLResponse)?.statusCode ?? 0)"
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
               let totalNutrients = jsonResponse["total_nutrients"] as? [String: Any] {
                DispatchQueue.main.async {
                    self.totalNutrients = totalNutrients
                    self.message = ""  // Clear any error message
                }
            } else {
                DispatchQueue.main.async {
                    self.message = "Failed to parse server response."
                }
            }
        }.resume()
    }
}

struct DailySummaryView_Previews: PreviewProvider {
    static var previews: some View {
        DailySummaryView().environmentObject(UserSession())
    }
}
