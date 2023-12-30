//
//  StudyPlanetApp.swift
//  StudyPlanet
//
//  Created by Joris Van Duyse on 21/12/2023.
//
//

import SwiftUI

/// The main entry point for the Study Planet application.
@main
struct StudyPlanetApp: App {
    /// State object for managing authentication within the app.
    @StateObject private var authManager = AuthenticationManager.shared

    /// The body of the main scene, displaying the content of the app.
    var body: some Scene {
        WindowGroup {
            ContentView(authManager: authManager)
                    .environmentObject(authManager)
                    .environment(\.managedObjectContext, StudyPlanetDatabase.shared.viewContext)
        }
    }
}
