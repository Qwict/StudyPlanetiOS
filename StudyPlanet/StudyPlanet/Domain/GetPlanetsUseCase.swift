//
// Created by Joris Van Duyse on 27/12/2023.
//

import Foundation

struct GetPlanetsUseCase {

    @Inject
    private var studyPlanetRepository: StudyPlanetRepositoryProtocol

    func call(completion: @escaping (Result<AuthenticatedUserDto, Error>) -> Void) {
//        StaticLogger.log.debug("Calling login action")
//        studyPlanetApi.authenticate(parameters: parameters, completion: completion)
    }
}