//
// Created by Joris Van Duyse on 28/12/2023.
//

import SwiftUI

struct PlanetListItem: View {
    let planet: PlanetDto

    var body: some View {
        if UIImage(named: planet.name) == nil {
            Image("GalaxySmall")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 90, height: 90)
                    .cornerRadius(10)
        } else {
            Image(planet.name + "Small")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 90, height: 90)
                    .cornerRadius(10)
        }
        VStack(alignment: .leading) {
            Text(planet.name)
                    .font(.title3)
                    .fontWeight(.bold)
        }
    }
}
