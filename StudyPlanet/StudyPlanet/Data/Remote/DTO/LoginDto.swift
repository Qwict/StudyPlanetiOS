//
// Created by Joris Van Duyse on 21/12/2023.
//

import Foundation

public struct LoginDto: Encodable {
    let email: String
    let password: String
}