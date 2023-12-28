//
// Created by Joris Van Duyse on 28/12/2023.
//

import SwiftUI

struct PlanetCard: View {
    let planet: PlanetDto

    var body: some View {
            Text(planet.name == "Galaxy" ? "Discover new planet" : "Explore \(planet.name)")
                    .font(.title)
            Text("Select the time you want to study on \(planet.name)")
                    .font(.subheadline)
            PlanetImage(planet: planet)
    }
}