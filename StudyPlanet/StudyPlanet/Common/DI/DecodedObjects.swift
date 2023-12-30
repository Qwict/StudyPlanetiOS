//
// Created by Joris Van Duyse on 30/12/2023.
//

import Foundation

public struct DecodedPayload {
    let remoteId: Int
    let email: String
    let iat: Int
    let exp: Int

}

public struct DecodedHeader {
    let alg: String
    let typ: String
}
