//
// Created by Joris Van Duyse on 27/12/2023.
//

import SwiftUI

struct DiscoveredPlanetsView: View {
    @StateObject private var viewModel: DiscoveredPlanetsViewModel
    init() {
        _viewModel = StateObject(
                wrappedValue: DiscoveredPlanetsViewModel()
        )
    }

    @FetchRequest(fetchRequest: PlanetEntity.all()) private var planets

    var body: some View {
        VStack {
//            Text("My Discovered Planets")
//                    .font(.title)
//                    .fontWeight(.bold)
            if planets.isEmpty {
                Image(
                        systemName: "questionmark.circle"
                )
                        .resizable()
                        .foregroundColor(.secondary)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 90, height: 90)
                Text("No Planets discovered yet.")
                        .font(.title3)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                Text("Discover new planets in the Discover tab.")
                        .multilineTextAlignment(.center)
            } else {
                VStack {
                    List(planets) { planet in
                        NavigationLink(destination: TimeSelectionView(planet: planet.toPlanet())) {
                            PlanetListItem(planet: planet)
                        }
                    }
//                    List {
//                        ForEach(planets) { planet in
//                        NavigationLink(destination: TimeSelectionView(planet: planet)) {
//                            PlanetListItem(planet: planet)
//                        }
//                    }
                }
            }


        }
//                .onAppear() {
//                    viewModel.getLocalDiscoveredPlanets()
//                }
    }
}
