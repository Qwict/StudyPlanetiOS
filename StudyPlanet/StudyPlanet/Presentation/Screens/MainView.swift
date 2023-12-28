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
//        NavigationView {

        VStack {
            Image("StudyPlanetLogo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 196, height: 196)
                    .padding(.vertical, 32)

            Text("Welcome back, User")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 32)
            ProgressView(value: 30, total: 100)

            NavigationLink {
                TimeSelectionView(planet: PlanetDto(name: "Galaxy", id: 0))
//                        .navigationBarBackButtonHidden()
            } label: {
                Text("Discover new planets")
                   .fontWeight(.bold)
            }

            NavigationLink {
                DiscoveredPlanetsView()
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
//        }
    }
}

