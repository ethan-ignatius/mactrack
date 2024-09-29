import SwiftUI

struct LandingView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                Text("Welcome to MacTrack")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                // Navigate to Login View
                NavigationLink(destination: LoginView()) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                }

                // Navigate to Sign-Up View
                NavigationLink(destination: SignUpView()) {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                }

                Spacer()
            }
            .padding(.top, 50)
            .navigationBarHidden(true)  // Hide back button or navigation bar
        }
    }
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}
//
//  LandingView.swift
//  MacTrack
//
//  Created by Ethan Ignatius on 2024-09-29.
//

