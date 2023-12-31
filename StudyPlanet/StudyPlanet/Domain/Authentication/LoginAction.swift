//
// Created by Joris Van Duyse on 18/12/2023.
//

import Foundation
import os

/// A structure representing the action of logging in a user.
struct LoginAction {
    /// The parameters required for the login request.
    var parameters: LoginDto

    /// The repository used to perform the login request.
    @Inject
    private var studyPlanetRepository: StudyPlanetRepositoryProtocol

    /// Performs the login action.
    ///
    /// - Parameter completion: A closure to be called with the result containing authenticated user information or an error.
    func call(completion: @escaping (Result<AuthenticatedUserDto, Error>) -> Void) {
        SPLogger.shared.debug("Calling login action")
        studyPlanetRepository.login(parameters: parameters, completion: completion)
    }
}