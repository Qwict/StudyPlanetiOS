//
// Created by Joris Van Duyse on 21/12/2023.
//

import SwiftUI
import JWTDecode
import SwiftyBeaver

// Authentication Manager
class AuthenticationManager: ObservableObject {
    public static let shared = AuthenticationManager()

    @Published var isAuthenticated: Bool = false
    private let log = SwiftyBeaver.self

    private init() {
        SPLogger.shared.debug("Creating AuthenticationManager")
        // Check if a valid token exists on app launch
        if let token = KeychainService.shared.loadToken(), isValidToken(token) {
            isAuthenticated = true
        } else {
            isAuthenticated = false
        }
    }

    func getEmail() -> String {
        let decodedToken: JWT
        do {
            decodedToken = try decode(jwt: KeychainService.shared.loadToken()!)
            return decodedToken.body["email"] as! String
        } catch {
            SPLogger.shared.debug("Failed to decode JWT: \(error)")
            isAuthenticated = false
            return ""
        }
    }

    func isValidToken(_ token: String) -> Bool {
        // Implement your token validation logic here
        // For example, check token expiration, etc.
        // Return true if the token is valid, otherwise false
        let decodedToken: JWT
        do {
            decodedToken = try decode(jwt: token)
//            SPLogger.shared.debug("Decoded JWT: \(decodedToken)")
            if decodedToken.expired {
                SPLogger.shared.debug("Token is expired")
                return false
            }
        } catch {
            SPLogger.shared.debug("Failed to decode JWT: \(error)")
            return false
        }
        return true
    }

    func authenticate(with token: String) {
        // Save the token to Keychain
        KeychainService.shared.saveToken(token)
        SPLogger.shared.debug("Token saved to Keychain")
        isAuthenticated = true
    }

    func signOut() {
        // Delete the token from Keychain
        KeychainService.shared.deleteToken()
        isAuthenticated = false
    }
}