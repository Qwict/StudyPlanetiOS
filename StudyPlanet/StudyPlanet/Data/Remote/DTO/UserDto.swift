//
// Created by Joris Van Duyse on 21/12/2023.
//

import Foundation

public struct UserDto: Decodable {
    let discoveredPlanets: [PlanetDto]
    let name: String
    let id, experience: Int
    let email: String
}