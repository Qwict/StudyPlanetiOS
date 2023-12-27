//
//  ContentView.swift
//  StudyPlanet
//
//  Created by Joris Van Duyse on 21/12/2023.
//
//

import SwiftUI

/// The main content view of the Study Planet app.
struct ContentView: View {
    /// The authentication manager provided by the environment.
    @EnvironmentObject var authManager: AuthenticationManager

    /// The body of the content view.
    var body: some View {
        NavigationStack {
            if authManager.isAuthenticated {
                MainView(authManager: authManager)
            } else {
                LoginView(authManager: authManager)
            }
//        .navigationTitle("Study Planet")
        }
    }
}
