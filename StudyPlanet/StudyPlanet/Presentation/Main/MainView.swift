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