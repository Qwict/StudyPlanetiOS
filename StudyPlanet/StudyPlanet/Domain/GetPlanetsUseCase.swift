//
// Created by Joris Van Duyse on 27/12/2023.
//

import Foundation

struct GetPlanetsUseCase {
    /// The parameters required for the login request.
    var parameters: String = KeychainService.shared.loadToken() ?? ""

    /// Injected dependency for interacting with the StudyPlanet API.
    @Inject
    private var studyPlanetApi: StudyPlanetApiProtocol

    /// Performs the login action.
    ///
    /// - Parameter completion: A closure to be called with the result containing authenticated user information or an error.
    func call(completion: @escaping (Result<AuthenticatedUserDto, Error>) -> Void) {
//        StaticLogger.log.debug("Calling login action")
//        studyPlanetApi.authenticate(parameters: parameters, completion: completion)
    }
}