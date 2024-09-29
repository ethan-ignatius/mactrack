//
//  MacTrackApp.swift
//  MacTrack
//
//  Created by Ethan Ignatius on 2024-09-28.
//

import SwiftUI

@main
struct MacTrackApp: App {
    @StateObject var userSession = UserSession()  // Initialize UserSession

    var body: some Scene {
        WindowGroup {
            LoginView()  // Start with LoginView
                .environmentObject(userSession)  // Pass UserSession to all views
        }
    }
}
