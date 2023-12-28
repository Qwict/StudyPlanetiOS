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
                }.navigationTitle(selectedTab.rawValue)
                        .accentColor(.black)
            } else {
                LoginView(authManager: authManager)
            }
        }

    }
}
