//
// Created by Joris Van Duyse on 28/12/2023.
//

import SwiftUI

struct PlanetCard: View {
    let planet: Planet

    var body: some View {
            Text(planet == nil ? "Discover new planet" : "Explore \(planet.name)")
                    .font(.title)
            Text("Select the time you want to study on \(planet.name)")
                    .font(.subheadline)
            PlanetImage(planet: planet)
    }
}