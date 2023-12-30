//
// Created by Joris Van Duyse on 18/12/2023.
//

import Foundation
import os
import SwiftyBeaver

/// View model responsible for authentication-related operations.
class AuthenticationViewModel : ObservableObject {
    /// The authentication manager for handling authentication state.
    private let authManager: AuthenticationManager

    /// Initializes an authentication view model with the provided authentication manager.
    init(authManager: AuthenticationManager) {
        self.authManager = authManager
    }

    @Inject
    private var studyPlanetRepository: StudyPlanetRepositoryProtocol
    private let log = SwiftyBeaver.self


    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    @Published var loginError: String = ""
    @Published var registerError: String = ""
    @Published var loading: Bool = false

    func isAuthenticated() -> Bool {
        authManager.isAuthenticated
    }

    func logout() {
        authManager.signOut()
        studyPlanetRepository.logout()
    }

    /// Initiates the login process with the provided email and password.
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - password: The user's password.
    func login(email: String, password: String) {
        SPLogger.shared.debug("Calling login action")
        loading = true
        if email.isEmpty || password.isEmpty {
            loginError = "Please enter your email and password"
            loading = false
            return
        } else {
            LoginAction(parameters:
                LoginDto(
                    email: email,
                    password: password
                )
            ).call { result in
                switch result {
                    case .success(let authenticatedUser):
                        // Handle the authenticated user information
                        SPLogger.shared.debug("User logged in: \(authenticatedUser.user.name)")
                        self.authManager.authenticate(with: authenticatedUser.token)
                        self.loading = false
                    case .failure(let error):
                        // Handle the error
                        self.loginError = "Failed to authenticate"
                        self.loading = false
                }
            }
        }
    }

    /// Registers a new user account with the provided details.
    /// - Parameters:
    ///   - username: The desired username for the new account.
    ///   - email: The email address for the new account.
    ///   - password: The password for the new account.
    ///   - confirmPassword: The confirmation password for the new account.
    func register(username: String, email: String, password: String, confirmPassword: String) -> Bool {
        SPLogger.shared.debug("Calling register action")
        loading = true
        clearErrors()
        if username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            registerError = "Please fill in all fields"
            loading = false
        } else if password != confirmPassword {
            registerError = "Passwords do not match"
            loading = false
        } else {
            RegisterAction(parameters:
            RegisterDto(
                    name: username,
                    email: email,
                    password: password
            )
            ).call { result in
                switch result {
                case .success(let authenticatedUser):
                    // Handle the authenticated user information
                    SPLogger.shared.debug("\(authenticatedUser)")
                    self.authManager.authenticate(with: authenticatedUser.token)
                    self.loading = false
                case .failure(let error):
                    // Handle the error
                    SPLogger.shared.debug("Error: \(error)")
                    self.loading = false

                }
            }
            return true
        }

        return false
    }

    /// Clears any existing errors.
    private func clearErrors() {
        loginError = ""
        registerError = ""
    }
}
