//
// Created by Joris Van Duyse on 28/12/2023.
//

import Foundation

public struct ExploreDto: Encodable {
    let planetId: Int
    let selectedTime: Int
}

public struct ExploreResponseDto: Decodable {
    let experience: Int
}