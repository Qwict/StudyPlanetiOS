//
// Created by Joris Van Duyse on 27/12/2023.
//

import Foundation
import CoreData
import SwiftyBeaver

class DiscoveredPlanetsViewModel: ObservableObject {
    @Inject
    private var studyPlanetRepository: StudyPlanetRepositoryProtocol

    private let log = SwiftyBeaver.self

    @Published var loading: Bool = false
    @Published var planets: [PlanetEntity] = []

    init() {
        loading = true
        getLocalDiscoveredPlanets()
    }

    func getLocalDiscoveredPlanets() {
        SPLogger.shared.debug("Getting local discovered planets")
        studyPlanetRepository.getLocalDiscoveredPlanets { result in
            switch result {
            case .success(let planets):
                self.planets = planets
            case .failure(let error):
                SPLogger.shared.debug("\(error)")
            }
        }
    }
}