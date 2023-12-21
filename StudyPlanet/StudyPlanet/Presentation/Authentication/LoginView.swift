//
// Created by Joris Van Duyse on 18/12/2023.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""

    @ObservedObject var authenticationViewModel: AuthenticationViewModel = AuthenticationViewModel()

    var body: some View {
        NavigationStack{
            VStack{
                Image("StudyPlanetLogo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 196, height: 196)
                        .padding(.vertical, 32)

                VStack(spacing: 24) {
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
                }
                .padding(.horizontal)
                .padding(.top, 12)

                Button{
                    authenticationViewModel.login(email: email, password: password)

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
                    RegistrationView()
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
