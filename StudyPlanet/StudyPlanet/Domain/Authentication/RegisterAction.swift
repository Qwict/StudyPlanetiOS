//
// Created by Joris Van Duyse on 18/12/2023.
//

import Foundation
import os

/// A structure representing the action of logging in a user.
struct RegisterAction {
    var parameters: RegisterDto

    @Inject
    private var studyPlanetRepository: StudyPlanetRepositoryProtocol

    func call(completion: @escaping (Result<AuthenticatedUserDto, Error>) -> Void) {
        studyPlanetRepository.register(parameters: parameters, completion: completion)
    }
}