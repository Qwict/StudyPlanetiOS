//
// Created by Joris Van Duyse on 21/12/2023.
//

import Foundation

struct LoginRequest: Encodable {
    let email: String
    let password: String
}

struct LoginDecode: Decodable {
    let email: String
    let password: String
}