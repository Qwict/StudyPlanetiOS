//
//  ContentView.swift
//  StudyPlanet
//
//  Created by Joris Van Duyse on 21/12/2023.
//
//

import SwiftUI

struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

// A View wrapper to make the modifier easier to use
extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}

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

    /// The body of the content view.
    var body: some View {
        NavigationStack {
            if authManager.isAuthenticated {
                TabView(selection: $selectedTab) {
                    MainView(authManager: authManager)
                            .tabItem {
                                Label("Home", systemImage: "person")
                            }
                            .tag(Tabs.home)
                    DiscoveredPlanetsView()
                            .tabItem {
                                Label("Explore", systemImage: "globe")
                            }
                            .tag(Tabs.explore)
                    TimeSelectionView(planet: PlanetDto(name: "Galaxy", id: 0))
                            .tabItem {
                                Label("Discover", systemImage: "mug")
                            }
                            .tag(Tabs.discover)
                }
                        .navigationTitle(selectedTab.rawValue)
                        .accentColor(.black)
                        .toolbar {
                            if selectedTab == .home {
                                ToolbarItem(placement: .confirmationAction) {
                                    Button(action: { showingLogoutAlert = true }) {
                                        Image(systemName: "rectangle.portrait.and.arrow.right")
                                    }

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
                LoginView(authManager: authManager)
            }
        }


    }
}
