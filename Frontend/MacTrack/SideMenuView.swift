import SwiftUI

struct SideMenuView: View {
    @Binding var isMenuVisible: Bool

    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(destination: DashboardView()) {
                Text("Dashboard")
                    .font(.headline)
                    .padding()
            }
            .onTapGesture {
                withAnimation {
                    self.isMenuVisible = false
                }
            }
            .navigationBarBackButtonHidden(true)  // Hides the back button when navigating

            NavigationLink(destination: InformationView()) {
                Text("Information")
                    .font(.headline)
                    .padding()
            }
            .onTapGesture {
                withAnimation {
                    self.isMenuVisible = false
                }
            }
            .navigationBarBackButtonHidden(true)  // Hides the back button when navigating

            NavigationLink(destination: DailySummaryView()) {
                Text("Daily Summary")
                    .font(.headline)
                    .padding()
            }
            .onTapGesture {
                withAnimation {
                    self.isMenuVisible = false
                }
            }
            .navigationBarBackButtonHidden(true)  // Hides the back button when navigating

            NavigationLink(destination: LoginView()) {
                Text("Logout")  // Changed from "Login" to "Logout"
                    .font(.headline)
                    .padding()
            }
            .onTapGesture {
                withAnimation {
                    self.isMenuVisible = false
                }
                // You can add your logout logic here
            }
            .navigationBarBackButtonHidden(true)  // Hides the back button when navigating

            Spacer()
        }
        .padding(.top, 50)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
        .shadow(radius: 5)
    }
}
