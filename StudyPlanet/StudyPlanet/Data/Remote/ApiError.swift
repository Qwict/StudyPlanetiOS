//
// Created by Joris Van Duyse on 28/12/2023.
//

import Foundation

/// An enumeration representing errors that can occur during API interactions.
enum ApiError: Error {
    case badURL
    case invalidResponse
    case invalidData
    case unableToComplete
}
