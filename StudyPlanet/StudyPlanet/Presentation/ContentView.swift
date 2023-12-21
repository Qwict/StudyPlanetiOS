//
//  ContentView.swift
//  StudyPlanet
//
//  Created by Joris Van Duyse on 21/12/2023.
//
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthenticationManager

    var body: some View {
        NavigationView {
            if authManager.isAuthenticated {
                MainView()
            } else {
                LoginView()
            }
        }
        .navigationTitle("Study Planet")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
