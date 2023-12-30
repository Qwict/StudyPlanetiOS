//
// Created by Joris Van Duyse on 28/12/2023.
//

import Foundation
import SwiftyBeaver

class StudyViewModel: ObservableObject {
    @Inject
    private var studyPlanetRepository: StudyPlanetRepositoryProtocol

    private let log = SwiftyBeaver.self

    @Published var discoveredPlanet: Planet = Planet(remoteId: 0, name: "Galaxy")
    @Published var isActionFinished: Bool = false

    func startExploring(remoteId: Int, selectedTimeInSeconds: Int) {
        studyPlanetRepository.startExploring(
                exploreDto: ExploreDto(
                        planetId: remoteId,
                        selectedTime: selectedTimeInSeconds * 1000
                )
        ) { result in
            switch result {
            case .success(let emptyResponse):
                SPLogger.shared.debug("Started exploring")
            case .failure(let error):
                SPLogger.shared.debug("\(error)")
            }
        }
    }

    func stopExploring(remoteId: Int, selectedTimeInSeconds: Int) {
        studyPlanetRepository.stopExploring(
                exploreDto: ExploreDto(
                        planetId: remoteId,
                        selectedTime: selectedTimeInSeconds * 1000
                )
        ) { result in
            switch result {
            case .success(let exploreResponse):
                self.isActionFinished = true
                SPLogger.shared.debug("\(exploreResponse)")
            case .failure(let error):
                SPLogger.shared.debug("\(error)")
            }
        }
    }

    func startDiscovering(selectedTimeInSeconds: Int) {
        studyPlanetRepository.startDiscovering(
                discoverDto: DiscoverDto(selectedTime: selectedTimeInSeconds * 1000)
        ) { result in
            switch result {
            case .success(let emptyResponse):
                SPLogger.shared.debug("Started discovering")

            case .failure(let error):
                SPLogger.shared.debug("\(error)")
            }
        }
    }

    func stopDiscovering(selectedTimeInSeconds: Int) {
        studyPlanetRepository.stopDiscovering(
                discoverDto: DiscoverDto(selectedTime: selectedTimeInSeconds * 1000)
        ) { result in
            switch result {
            case .success(let discoverResponse):
                SPLogger.shared.debug("\(discoverResponse.hasFoundNewPlanet ? "Discovered" : "Not discovered")")
                if (discoverResponse.hasFoundNewPlanet) {
                    self.discoveredPlanet = Planet(
                        remoteId: discoverResponse.planet.id,
                        name: discoverResponse.planet.name
                    )
                    self.isActionFinished = true
                } else {
                    self.isActionFinished = true
                }
            case .failure(let error):
                SPLogger.shared.debug("\(error)")
            }
        }
    }
}
