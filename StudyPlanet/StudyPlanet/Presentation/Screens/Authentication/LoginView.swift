//
// Created by Joris Van Duyse on 18/12/2023.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""

    @EnvironmentObject var authManager: AuthenticationManager
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
                        .padding(.top, 32)

                Text(viewModel.loginError)
                        .foregroundColor(.red)
                        .padding(12)
                        .frame(width: UIScreen.main.bounds.width - 32, alignment: .center)

                VStack(spacing: 24) {
                    InputView(
                            text: $email,
                            title: "Email",
                            placeholder: "name@example.com"
                    )
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)

                    InputView(
                            text: $password,
                            title: "Password",
                            placeholder: "Enter your password",
                            isSecureField: true
                    )
                            .autocapitalization(.none)
                            .keyboardType(.default)
                            .textContentType(.password)
                            .disableAutocorrection(true)
                }
                        .padding(.horizontal)
                        .padding(.top, 12)


                Button {
                    viewModel.login(email: email, password: password)
                } label: {
                    HStack {
                        Text("Login")
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

                NavigationLink {
                    RegistrationView(authManager: authManager)
                            .navigationBarBackButtonHidden()
                } label: {
                    HStack(spacing: 3) {
                        Text("Don't have an account?")
                        Text("Sign Up")
                                .fontWeight(.bold)
                    }
                            .font(.system(size: 14))
                            .foregroundColor(.primary)
                }
            }
        }
    }
}
