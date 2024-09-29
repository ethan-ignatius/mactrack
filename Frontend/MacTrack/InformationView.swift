import SwiftUI

struct InformationView: View {
    var body: some View {
        VStack(spacing: 40) {
            // 99% Accuracy Section
            VStack(spacing: 10) {
                Image(systemName: "target")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.green)

                Text("99% Accuracy")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                Text("MacTrack uses advanced machine learning algorithms to identify the macronutrients in your meal with 99% accuracy, ensuring reliable nutritional insights.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 20)
            }

            // Completely Online Section
            VStack(spacing: 10) {
                Image(systemName: "house.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.green)

                Text("Completely Online")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                Text("No need for manual logging or estimates. Simply snap a picture of your meal, and MacTrack will provide detailed macronutrient information in seconds, all online.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 20)
            }

            // Instant Results Section
            VStack(spacing: 10) {
                Image(systemName: "clock.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.green)

                Text("Instant Results")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                Text("Get macronutrient information in less than a minute. No more waiting—MacTrack delivers quick, accurate results so you can focus on your health.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 20)
            }

            Spacer()
        }
        .padding(.top, 40)
    }
}

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView()
    }
}

//
//  InformationView.swift
//  MacTrack
//
//  Created by Ethan Ignatius on 2024-09-28.
//

