//
// Created by Joris Van Duyse on 27/12/2023.
//

import SwiftUI

struct DiscoveredPlanetsView: View {

    var body: some View {
        VStack {
//            Text("My Discovered Planets")
//                    .font(.title)
//                    .fontWeight(.bold)
            if MockData.planets.isEmpty {
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
                    List(MockData.planets) { planet in
                        NavigationLink(destination: TimeSelectionView(planet: planet)) {
                            PlanetListItem(planet: planet)
                        }
                    }
                }
            }


        }
    }
}
