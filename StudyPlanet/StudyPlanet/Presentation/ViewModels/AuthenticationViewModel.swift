//
// Created by Joris Van Duyse on 18/12/2023.
//

import Foundation

class AuthenticationViewModel : ObservableObject {
    // Inject the AuthenticationManager
    var authManager: AuthenticationManager

    init(authManager: AuthenticationManager) {
        self.authManager = authManager
    }

    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    func login(email: String, password: String) {
        LoginAction(parameters:
                LoginRequest(
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

    func register(username: String, email: String, password: String, confirmPassword: String) {

    }
}
