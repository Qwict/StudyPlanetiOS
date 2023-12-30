//
// Created by Joris Van Duyse on 28/12/2023.
//

import Foundation

public struct DiscoverDto: Encodable {
    let selectedTime: Int
}

public struct DiscoverResponseDto: Decodable {
    let id: Int?
    let name: String?
    let discovered: Int
}