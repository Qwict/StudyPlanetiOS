//
// Created by Joris Van Duyse on 21/12/2023.
// Based on keychain tutorial by TODO
//

import Foundation

import Foundation
import Security

/// A service for managing secure storage of authentication tokens in the Keychain.
class KeychainService {

    /// The shared instance of the `KeychainService`.
    static let shared = KeychainService()

    /// The service identifier used for storing tokens in the Keychain.
    private let service = "com.qwict.studyplanet"

    /// Saves the authentication token to the Keychain.
    ///
    /// - Parameter token: The authentication token to be saved.
    func saveToken(_ token: String) {
        print("Saving token to Keychain: \(token)")
        guard let data = token.data(using: .utf8) else { return }

        // Create a query for the Keychain
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: "authToken",
            kSecValueData as String: data
        ]

        // Delete existing token if it exists
        SecItemDelete(query as CFDictionary)

        // Add the new token to the Keychain
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            print("Failed to save token to Keychain")
        }
    }

    /// Loads the authentication token from the Keychain.
    ///
    /// - Returns: The authentication token if found; otherwise, `nil`.
    func loadToken() -> String? {
        // Create a query for the Keychain
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: "authToken",
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]

        // Retrieve the token from the Keychain
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        if status == errSecSuccess, let existingItem = item as? [String: Any],
            let data = existingItem[kSecValueData as String] as? Data,
            let token = String(data: data, encoding: .utf8) {
                return token
            } else {
                print("Failed to load token from Keychain")
                return nil
            }
    }

    /// Deletes the authentication token from the Keychain.
    func deleteToken() {
        // Create a query for the Keychain
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: "authToken"
        ]

        // Delete the token from the Keychain
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess {
            print("Failed to delete token from Keychain")
        }
    }
}
