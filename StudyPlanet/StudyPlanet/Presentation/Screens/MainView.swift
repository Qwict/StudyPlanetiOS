//
// Created by Joris Van Duyse on 21/12/2023.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel: AuthenticationViewModel
    init(authManager: AuthenticationManager) {
        _viewModel = StateObject(
                wrappedValue: AuthenticationViewModel(authManager: authManager)
        )
    }

    var body: some View {
        VStack {
            ProgressView(value: 30, total: 100)

            NavigationLink {
                TimeSelectionView()
//                        .navigationBarBackButtonHidden()
            } label: {
                Text("Discover new planets")
                   .fontWeight(.bold)
            }

            NavigationLink {
                TimeSelectionView()
//                        .navigationBarBackButtonHidden()
            } label: {
                Text("Explore my planets")
                        .fontWeight(.bold)
            }


            Button("Logout") {
                viewModel.signOut()
            }
                .padding()
                .foregroundColor(.white)
                .background(Color.red)
                .cornerRadius(8)
        }
    }
}

