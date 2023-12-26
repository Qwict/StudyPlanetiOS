//
// Created by Joris Van Duyse on 21/12/2023.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var authManager: AuthenticationManager

    var body: some View {
        VStack {
            Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
            Text("Hello, world!")

            NavigationLink {
                TimeSelectionView()
                        .navigationBarBackButtonHidden()
            } label: {
                HStack(spacing: 3) {
                    Text("Discover new planets")
                            .fontWeight(.bold)
                }
                        .font(.system(size: 14))
                        .foregroundColor(.primary)
            }

            NavigationLink {
                TimeSelectionView()
                        .navigationBarBackButtonHidden()
            } label: {
                Button("Start exploring") {
                }
            }


            Button("Logout") {
                authManager.signOut()
            }
                .padding()
                .foregroundColor(.white)
                .background(Color.red)
                .cornerRadius(8)
        }
    }
}

