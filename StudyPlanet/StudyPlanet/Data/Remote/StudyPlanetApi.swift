//
// Created by Joris Van Duyse on 27/12/2023.
//

import Foundation

/// A protocol defining the methods for interacting with the StudyPlanet API.
public protocol StudyPlanetApiProtocol {

    /// Authenticates the user with a given token and retrieves a list of planets.
    ///
    /// - Parameters:
    ///   - token: The authentication token.
    ///   - completion: A closure to be called with the result containing a list of planets or an error.
    func authenticate(token: String, completion: @escaping (Result<[PlanetDto], Error>) -> Void)

    /// Logs in a user with the provided parameters and retrieves authentication information.
    ///
    /// - Parameters:
    ///   - parameters: The login request parameters.
    ///   - completion: A closure to be called with the result containing authenticated user information or an error.
    func login(parameters: LoginRequest, completion: @escaping (Result<AuthenticatedUserDto, Error>) -> Void)
}

/// An enumeration representing errors that can occur during API interactions.
enum APIError: Error {
    /// Indicates a bad URL.
    case badURL
    /// Indicates a decoding error.
    case decodingError
}

/// A class implementing the `StudyPlanetApiProtocol` for interacting with the StudyPlanet API.
final class StudyPlanetApi: StudyPlanetApiProtocol {

    /// Authenticates the user with a given token and retrieves a list of planets.
    ///
    /// - Parameters:
    ///   - token: The authentication token.
    ///   - completion: A closure to be called with the result containing a list of planets or an error.
    func authenticate(token: String, completion: @escaping (Result<[PlanetDto], Error>) -> Void) {
        guard let url = URL(string: Constants.BASE_URL + "/users") else {
            completion(.failure(APIError.badURL))
            return
        }

        let headers = ["Authorization": "\(token)"]
        makeRequest(url: url, method: "GET", headers: headers, body: nil, completion: completion)
    }

    /// Logs in a user with the provided parameters and retrieves authentication information.
    ///
    /// - Parameters:
    ///   - parameters: The login request parameters.
    ///   - completion: A closure to be called with the result containing authenticated user information or an error.
    func login(parameters: LoginRequest, completion: @escaping (Result<AuthenticatedUserDto, Error>) -> Void) {
        guard let url = URL(string: Constants.BASE_URL + "/users/login") else {
            completion(.failure(APIError.badURL))
            return
        }

        makeRequest(url: url, method: "POST", headers: ["Content-Type": "application/json"], body: parameters, completion: completion)
    }

    /// Makes an HTTP request with the specified parameters and performs decoding of the response.
    ///
    /// - Parameters:
    ///   - url: The URL for the request.
    ///   - method: The HTTP method for the request.
    ///   - headers: The headers for the request.
    ///   - body: The body parameters for the request.
    ///   - completion: A closure to be called with the result containing decoded response or an error.
    private func makeRequest<T: Decodable>(
            url: URL,
            method: String,
            headers: [String: String]?,
            body: Encodable?,
            completion: @escaping (Result<T, Error>) -> Void
    ) {
        var request = URLRequest(url: url)
        request.httpMethod = method

        // Set headers if provided
        headers?.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }

        // Set HTTP body if a body is provided
        if let body = body {
            do {
                request.httpBody = try JSONEncoder().encode(body)
            } catch {
                completion(.failure(error))
                return
            }
        }

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedResponse))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
