//
// Created by Joris Van Duyse on 18/12/2023.
//

import Foundation

public struct PlanetDto: Decodable, Identifiable {
    let name: String
    public let id: Int
}

public struct MockData {
    static let planets = [
        PlanetDto(name: "Earth", id: 1),
        PlanetDto(name: "Mars", id: 2),
        PlanetDto(name: "Jupiter", id: 3),
        PlanetDto(name: "Saturn", id: 4),
        PlanetDto(name: "Uranus", id: 5),
        PlanetDto(name: "Neptune", id: 6),
        PlanetDto(name: "Pluto", id: 7),
        PlanetDto(name: "Mercury", id: 8),
        PlanetDto(name: "Venus", id: 9)
    ]
}