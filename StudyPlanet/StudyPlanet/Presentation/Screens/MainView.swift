//
// Created by Joris Van Duyse on 21/12/2023.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel: MainViewModel
    init() {
        _viewModel = StateObject(
                wrappedValue: MainViewModel()
        )
    }

    @FetchRequest(fetchRequest: UserEntity.active()) private var user

    var body: some View {
        VStack {
            Image("StudyPlanetLogo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 196, height: 196)
                    .padding(.vertical, 32)
            if user.isEmpty {
                ProgressView()
            } else {
                Text("Welcome back, \(user.first?.name ?? "User")!")
                    .font(.title)
                    .fontWeight(.bold)

                Text("Level \(viewModel.currentLevel)")
                        .font(.title2)
                        .fontWeight(.bold)

                ProgressView(
                        value: viewModel.experienceProgress,
                        total: 1,
                        label: { Text("Experience") },
                        currentValueLabel: {
                            Text(String(user.first?.experience ?? 0) + " xp")
                                    .foregroundColor(.gray)
                        }
                )
                        .padding()
            }


        }
                .onAppear {
                    viewModel.getLocalUser()
                }
    }

}

