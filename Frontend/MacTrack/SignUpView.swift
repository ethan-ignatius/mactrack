import SwiftUI

struct SignUpView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var message: String = ""  // To show a success or failure message
    @State private var isSignedUp = false  // State to track successful sign up

    @EnvironmentObject var userSession: UserSession  // Access user session

    var body: some View {
        VStack {
            // Add the MacTrack logo at the top
            Image("logo")  // Make sure this matches the image asset name in your project
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
                .padding(.bottom, 5)

            Text("Sign Up")
                .font(.largeTitle)
                .padding(.bottom, 20)

            TextField("Username", text: $username)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .padding(.horizontal, 40)

            SecureField("Password", text: $password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .padding(.horizontal, 40)

            Button(action: {
                signUp()
            }) {
                Text("Sign Up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
            }
            .padding(.top, 20)

            Text(message)
                .foregroundColor(.red)
                .padding()

            // Navigate to DashboardView after successful sign-up
            NavigationLink(destination: DashboardView(), isActive: $isSignedUp) {
                EmptyView()
            }

            Spacer()
        }
        .padding(.top, 50)
    }

    func signUp() {
        guard let url = URL(string: "https://82ce-128-61-27-239.ngrok-free.app/signup") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = [
            "username": username,
            "password": password
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.message = "Failed to sign up. Try again."
                }
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                if let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let userId = jsonResponse["user_id"] as? String {
                    // Store the user ID in the session and navigate to the DashboardView
                    DispatchQueue.main.async {
                        self.userSession.userId = userId
                        self.isSignedUp = true
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.message = "Sign Up Failed."
                }
            }
        }.resume()
    }
}
