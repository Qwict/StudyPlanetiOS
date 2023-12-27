//
// Created by Joris Van Duyse on 21/12/2023.
//

import Foundation

public struct LoginRequest: Encodable {
    let email: String
    let password: String
}

public struct LoginDecode: Decodable {
    let email: String
    let password: String
}