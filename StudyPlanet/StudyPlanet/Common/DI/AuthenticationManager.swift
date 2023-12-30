//
// Created by Joris Van Duyse on 21/12/2023.
//

import SwiftUI

// Authentication Manager
class AuthenticationManager: ObservableObject {
    public static let shared = AuthenticationManager()

    @Published var isAuthenticated: Bool = false

    private init() {
        print("Creating AuthenticationManager")
        // Check if a valid token exists on app launch
        if let token = KeychainService.shared.loadToken(), isValidToken(token) {
            isAuthenticated = true
        } else {
            isAuthenticated = false
        }
    }

    func isValidToken(_ token: String) -> Bool {
        // Implement your token validation logic here
        // For example, check token expiration, etc.
        // Return true if the token is valid, otherwise false
        return true
    }

    func authenticate(with token: String) {
        // Save the token to Keychain
        KeychainService.shared.saveToken(token)
        print("Token saved to Keychain")
        isAuthenticated = true
    }

    func signOut() {
        // Delete the token from Keychain
        KeychainService.shared.deleteToken()
        isAuthenticated = false
    }
}