//
// Created by Joris Van Duyse on 18/12/2023.
//

import SwiftUI

struct RegistrationView : View {
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @StateObject private var viewModel: AuthenticationViewModel
    init(authManager: AuthenticationManager) {
        _viewModel = StateObject(
                wrappedValue: AuthenticationViewModel(authManager: authManager)
        )
    }

    var body: some View {
        if viewModel.loading {
            Image("StudyPlanetLogo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 196, height: 196)
                    .padding(.top, 32)
            ProgressView()
        } else {
            VStack {
                Image("StudyPlanetLogo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 196, height: 196)
                        .padding(.vertical, 32)

                VStack(spacing: 24) {
                    InputView(
                            text: $username,
                            title: "Username",
                            placeholder: "username"
                    )
                    InputView(
                            text: $email,
                            title: "Email",
                            placeholder: "name@example.com")
                            .autocapitalization(.none)
                    InputView(
                            text: $password,
                            title: "Password",
                            placeholder: "Enter your password",
                            isSecureField: true)
                            .autocapitalization(.none)
                    InputView(
                            text: $password,
                            title: "Confirm Password",
                            placeholder: "Confirm your password",
                            isSecureField: true)
                            .autocapitalization(.none)
                }
                        .padding(.horizontal)
                        .padding(.top, 12)

                Button {
                    viewModel.register(username: username, email: email, password: password, confirmPassword: confirmPassword)
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack {
                        Text("Register")
                                .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                        .background(Color(.systemBlue))
                        .cornerRadius(10)
                        .padding(.top, 24)

                Spacer()

                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack(spacing: 3) {
                        Text("Already have an account?")
                        Text("Login")
                                .fontWeight(.bold)
                    }
                            .font(.system(size: 14))
                            .foregroundColor(.primary)
                }
            }
        }
    }
}
