//
// Created by Joris Van Duyse on 18/12/2023.
//

import Foundation

class AuthenticationViewModel : ObservableObject {

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
            case .failure(let error):
                // Handle the error
                print("Error: \(error)")
            }
        }
    }

    func register(username: String, email: String, password: String, confirmPassword: String) {

    }
}