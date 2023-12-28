//
// Created by Joris Van Duyse on 18/12/2023.
//

import Foundation
import os

/// A structure representing the action of logging in a user.
struct RegisterAction {
    var parameters: RegisterDto

    @Inject
    private var studyPlanetApi: StudyPlanetApiProtocol

    func call(completion: @escaping (Result<AuthenticatedUserDto, Error>) -> Void) {
        studyPlanetApi.register(parameters: parameters, completion: completion)
    }
}