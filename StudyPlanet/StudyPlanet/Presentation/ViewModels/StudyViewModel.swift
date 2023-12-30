//
// Created by Joris Van Duyse on 28/12/2023.
//

import Foundation
class StudyViewModel: ObservableObject {
    @Inject
    private var studyPlanetRepository: StudyPlanetRepositoryProtocol
    @Published var discoveredPlanet: Planet = Planet(remoteId: 0, name: "Galaxy")
    @Published var isActionFinished: Bool = false

    func startExploring(remoteId: Int, selectedTime: Int) {
        studyPlanetRepository.startExploring(
                exploreDto: ExploreDto(
                        planetId: remoteId,
                        selectedTime: selectedTime
                )
        ) { result in
            switch result {
            case .success(let emptyResponse):
                print("Started exploring")
            case .failure(let error):
                print(error)
            }
        }
    }

    func stopExploring(remoteId: Int, selectedTime: Int) {
        studyPlanetRepository.stopExploring(
                exploreDto: ExploreDto(
                        planetId: remoteId,
                        selectedTime: selectedTime
                )
        ) { result in
            switch result {
            case .success(let exploreResponse):
                print(exploreResponse)
            case .failure(let error):
                print(error)
            }
        }
    }

    func startDiscovering(selectedTime: Int) {
        studyPlanetRepository.startDiscovering(
                discoverDto: DiscoverDto(selectedTime: selectedTime)
        ) { result in
            switch result {
            case .success(let emptyResponse):
                print("Started discovering")

            case .failure(let error):
                print(error)
            }
        }
    }

    func stopDiscovering(selectedTime: Int) {
        studyPlanetRepository.stopDiscovering(
                discoverDto: DiscoverDto(selectedTime: selectedTime)
        ) { result in
            switch result {
            case .success(let discoverResponse):
                print(discoverResponse.discovered != 0 ? "Discovered" : "Not discovered")
                if discoverResponse.discovered != 0  {
                    self.discoveredPlanet = Planet(
//                                TODO: Fix this
                            remoteId: discoverResponse.id ?? 0,
                            name: discoverResponse.name ?? "Galaxy"
                    )
                    self.isActionFinished = true
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
