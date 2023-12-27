//
// Created by Joris Van Duyse on 27/12/2023.
//

import Foundation

public struct RegisterRequestDto: Encodable {
    let name: String
    let email: String
    let password: String
}