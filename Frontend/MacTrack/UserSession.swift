import Foundation

class UserSession: ObservableObject {
    // The userId will be shared and accessed throughout the app
    @Published var userId: String = ""

    // You can also add other session-related properties if needed
}
//
//  UserSession.swift
//  MacTrack
//
//  Created by Ethan Ignatius on 2024-09-29.
//

