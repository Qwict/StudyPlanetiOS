//
// Created by Joris Van Duyse on 18/12/2023.
//

import Foundation
import os

/// View model responsible for authentication-related operations.
class AuthenticationViewModel : ObservableObject {
    /// The authentication manager for handling authentication state.
    private let authManager: AuthenticationManager

    /// Initializes an authentication view model with the provided authentication manager.
    init(authManager: AuthenticationManager) {
        self.authManager = authManager
    }


    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    func isAuthenticated() -> Bool {
        authManager.isAuthenticated
    }

    func signOut() {
        authManager.signOut()
    }

    /// Initiates the login process with the provided email and password.
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - password: The user's password.
    func login(email: String, password: String) {
        StaticLogger.log.debug("Calling login action")
        LoginAction(parameters:
                LoginDto(
                        email: email,
                        password: password
                )
        ).call { result in
            switch result {
                case .success(let authenticatedUser):
                    // Handle the authenticated user information
                    print(authenticatedUser)
                    self.authManager.authenticate(with: authenticatedUser.token)
                case .failure(let error):
                    // Handle the error
                    print("Error: \(error)")
            }
        }
    }

    /// Registers a new user account with the provided details.
    /// - Parameters:
    ///   - username: The desired username for the new account.
    ///   - email: The email address for the new account.
    ///   - password: The password for the new account.
    ///   - confirmPassword: The confirmation password for the new account.
    func register(username: String, email: String, password: String, confirmPassword: String) {

    }
}
