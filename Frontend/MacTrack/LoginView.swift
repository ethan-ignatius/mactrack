import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var message: String = ""
    @State private var isLoggedIn = false  // State to track if user is logged in

    @EnvironmentObject var userSession: UserSession  // Access the userSession object

    var body: some View {
        NavigationView {
            VStack {
                // Add the MacTrack logo at the top
                Image("logo")  // Make sure this matches the image asset name in your project
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .padding(.bottom, 5)

                Text("Login")
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
                    login()
                }) {
                    Text("Login")
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

                // Add Sign-Up Button
                NavigationLink(destination: SignUpView()) {
                    Text("Don't have an account? Sign up")
                        .foregroundColor(.blue)
                        .padding(.top, 20)
                }

                // NavigationLink to DashboardView after successful login
                NavigationLink(destination: DashboardView(), isActive: $isLoggedIn) {
                    EmptyView()
                }

                Spacer()
            }
            .padding(.top, 50)
        }
    }

    func login() {
        guard let url = URL(string: "https://82ce-128-61-27-239.ngrok-free.app/login") else { return }

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
                    self.message = "Login Failed."
                }
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                if let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let userId = jsonResponse["user_id"] as? String {
                    // Save the user ID in the user session
                    DispatchQueue.main.async {
                        self.userSession.userId = userId
                        self.isLoggedIn = true  // Set to true to navigate to DashboardView
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.message = "Invalid credentials."
                }
            }
        }.resume()
    }
}
