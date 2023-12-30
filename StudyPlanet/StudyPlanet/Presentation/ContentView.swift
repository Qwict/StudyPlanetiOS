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
    @State var selectedTab: Tabs = .home
    @State var orientation = UIDeviceOrientation.unknown
    @State private var showingLogoutAlert = false

    @StateObject private var viewModel: AuthenticationViewModel
    init(authManager: AuthenticationManager) {
        _viewModel = StateObject(
                wrappedValue: AuthenticationViewModel(authManager: authManager)
        )
    }

    enum Tabs: String {
        case home = "Home"
        case explore = "Explore a Planet"
        case discover = "Discover a new Planet"
    }

//    private func thisStupidGalaxy() -> PlanetEntity {
//        let emptyPlanet = PlanetEntity(context: StudyPlanetDatabase.shared.viewContext)
//        emptyPlanet.name = "Galaxy"
//        return emptyPlanet
//    }

    /// The body of the content view.
    var body: some View {
        NavigationStack {
            if authManager.isAuthenticated {
                TabView(selection: $selectedTab) {
                    MainView()
                            .tabItem {
                                Label("Home", systemImage: "person")
                            }
                            .tag(Tabs.home)
                    DiscoveredPlanetsView()
                            .tabItem {
                                Label("Explore", systemImage: "globe")
                            }
                            .tag(Tabs.explore)
                    TimeSelectionView(planet: Planet(remoteId: 0, name: "Galaxy"))
                            .tabItem {
                                Label("Discover", systemImage: "sparkle.magnifyingglass")
                            }
                            .tag(Tabs.discover)
                }
                        .navigationTitle(selectedTab.rawValue)
                        .accentColor(.black)
                        .toolbar {
                            if selectedTab == .home {
                                ToolbarItem(placement: .confirmationAction) {
                                    Button(action: { showingLogoutAlert = true }) {
                                        Image(systemName: "door.left.hand.open")
                                    }
                                        .accentColor(.black)
                                }
                            }
                        }
                        .alert(isPresented: $showingLogoutAlert) {
                            Alert(
                                    title: Text("Logout"),
                                    message: Text("Are you sure you want to logout?"),
                                    primaryButton: .destructive(Text("Yes"),
                                    action: {
                                        viewModel.logout()
                                    }),
                                    secondaryButton: .default(Text("No"))
                            )
                        }
            } else {
                NavigationStack {
                    LoginView(authManager: authManager)
                            .navigationTitle("Login")
                }
            }
        }


    }
}

