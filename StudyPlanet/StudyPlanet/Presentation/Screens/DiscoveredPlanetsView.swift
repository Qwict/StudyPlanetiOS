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
            List(MockData.planets) { planet in
                NavigationLink(destination: TimeSelectionView(planet: planet)) {
                    PlanetListItem(planet: planet)
                }
            }
        }
    }
}
