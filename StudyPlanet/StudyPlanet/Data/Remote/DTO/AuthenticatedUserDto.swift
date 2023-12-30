//
// Created by Joris Van Duyse on 21/12/2023.
//

import Foundation

public struct AuthenticatedUserDto: Decodable {
    let validated: Bool
    let user: UserDto
    let token: String
}
