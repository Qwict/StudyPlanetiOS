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

    var body: some View {
        VStack {
            Image("StudyPlanetLogo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 196, height: 196)
                    .padding(.vertical, 32)

            Text("Welcome back, \(viewModel.user.name)")
                    .font(.title)
                    .fontWeight(.bold)

            Text("Level \(viewModel.currentLevel)")
                    .font(.title2)
                    .fontWeight(.bold)

            ProgressView(value: viewModel.experienceProgress, total: 1)
                    .padding()
        }
                .onAppear() {
                    viewModel.getLocalUser()
                }
    }

}

