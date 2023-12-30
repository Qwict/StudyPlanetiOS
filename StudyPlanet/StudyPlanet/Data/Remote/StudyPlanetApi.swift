//
// Created by Joris Van Duyse on 27/12/2023.
//

import Foundation
import SwiftyBeaver

/// A protocol defining the methods for interacting with the StudyPlanet API.
public protocol StudyPlanetApiProtocol {

    /// Authenticates the user with a given token and retrieves a list of planets.
    ///
    /// - Parameters:
    ///   - token: The authentication token.
    ///   - completion: A closure to be called with the result containing a list of planets or an error.
    func authenticate(token: String, completion: @escaping (Result<[AuthenticatedUserDto], Error>) -> Void)

    /// Logs in a user with the provided parameters and retrieves authentication information.
    ///
    /// - Parameters:
    ///   - parameters: The login request parameters.
    ///   - completion: A closure to be called with the result containing authenticated user information or an error.
    func login(parameters: LoginDto, completion: @escaping (Result<AuthenticatedUserDto, Error>) -> Void)

    func register(parameters: RegisterDto, completion: @escaping (Result<AuthenticatedUserDto, Error>) -> ())

    func startExploring(parameters: ExploreDto, completion: @escaping (Result<EmptyResponse, Error>) -> ())
    func stopExploring(parameters: ExploreDto, completion: @escaping (Result<ExploreResponseDto, Error>) -> ())

    func startDiscovering(parameters: DiscoverDto, completion: @escaping (Result<EmptyResponse, Error>) -> ())
    func stopDiscovering(parameters: DiscoverDto, completion: @escaping (Result<DiscoverResponseDto, Error>) -> ())
}

/// A class implementing the `StudyPlanetApiProtocol` for interacting with the StudyPlanet API.
final class StudyPlanetApi: StudyPlanetApiProtocol {

    private let log = SwiftyBeaver.self

    /// Authenticates the user with a given token and retrieves a list of planets.
    ///
    /// - Parameters:
    ///   - token: The authentication token.
    ///   - completion: A closure to be called with the result containing a list of planets or an error.
    func authenticate(token: String, completion: @escaping (Result<[AuthenticatedUserDto], Error>) -> Void) {
        makeRequest(
                urlEndPoint: "/users",
                method: "GET",
                headers: ["Authorization": "\(token)"],
                body: nil,
                completion: completion
        )
    }

    /// Logs in a user with the provided parameters and retrieves authentication information.
    ///
    /// - Parameters:
    ///   - parameters: The login request parameters.
    ///   - completion: A closure to be called with the result containing authenticated user information or an error.
    func login(parameters: LoginDto, completion: @escaping (Result<AuthenticatedUserDto, Error>) -> Void) {
        makeRequest(
                urlEndPoint: "/users/login",
                method: "POST",
                headers: ["Content-Type": "application/json"],
                body: parameters,
                completion: completion
        )
    }

    func register(parameters: RegisterDto, completion: @escaping (Result<AuthenticatedUserDto, Error>) -> Void) {
        makeRequest(
                urlEndPoint: "/users/register",
                method: "POST",
                headers: ["Content-Type": "application/json"],
                body: parameters,
                completion: completion
        )
    }


    func startExploring(parameters: ExploreDto, completion: @escaping (Result<EmptyResponse, Error>) -> Void) {
        let token = KeychainService.shared.loadToken() ?? ""
        makeRequest(
            urlEndPoint: "/actions/explore",
            method: "POST",
            headers: ["Content-Type": "application/json", "Authorization": token],
            body: parameters,
            completion: completion
        )
    }

    func stopExploring(parameters: ExploreDto, completion: @escaping (Result<ExploreResponseDto, Error>) -> Void) {
        let token = KeychainService.shared.loadToken() ?? ""
        makeRequest(
            urlEndPoint: "/actions/explore",
            method: "PUT",
            headers: ["Content-Type": "application/json", "Authorization": token],
            body: parameters,
            completion: completion
        )
    }

    func startDiscovering(parameters: DiscoverDto, completion: @escaping (Result<EmptyResponse, Error>) -> Void) {
        let token = KeychainService.shared.loadToken() ?? ""
        makeRequest(
            urlEndPoint: "/actions/discover",
            method: "POST",
            headers: ["Content-Type": "application/json", "Authorization": token],
            body: parameters,
            completion: completion
        )
    }

    func stopDiscovering(parameters: DiscoverDto, completion: @escaping (Result<DiscoverResponseDto, Error>) -> Void) {
        let token = KeychainService.shared.loadToken() ?? ""
        makeRequest(
            urlEndPoint: "/actions/discover",
            method: "PUT",
            headers: ["Content-Type": "application/json", "Authorization": token],
            body: parameters,
            completion: completion
        )
    }

    /// Makes an HTTP request with the specified parameters and performs decoding of the response.
    ///
    /// - Parameters:
    ///   - urlEndPoint: The URL endpoint for the request, will be appended to BASE_URL.
    ///   - method: The HTTP method for the request.
    ///   - headers: The headers for the request.
    ///   - body: The body parameters for the request.
    ///   - completion: A closure to be called with the result containing decoded response or an error.
    private func makeRequest<T: Decodable>(
            urlEndPoint: String,
            method: String,
            headers: [String: String]?,
            body: Encodable?,
            completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = URL(string: Constants.BASE_URL + urlEndPoint) else {
            completion(.failure(ApiError.badURL))
            return
        }

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
                    // Have to allow empty response for some requests, will have clean this up later
                    if T.Type.self == EmptyResponse.Type.self {
                        SPLogger.shared.debug("Returning empty response")
                        completion(.success(EmptyResponse() as! T))
                    }
                    else {
                        completion(.failure(error))
                    }
                }
            } else if let error = error {
                SPLogger.shared.debug("Failed in check response for error: \(error)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
