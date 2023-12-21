//
// Created by Joris Van Duyse on 18/12/2023.
//

import Foundation

struct LoginAction {
    var parameters: LoginRequest

    func call(completion: @escaping (Result<AuthenticatedUserDto, Error>) -> Void) {
        guard let url = URL(string: "http://localhost:9012/api/v1/users/login") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONEncoder().encode(parameters)
        } catch {
            completion(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(AuthenticatedUserDto.self, from: data)

                    // Save the token
                    AuthenticationManager.shared.authenticate(with: response.token)

                    completion(.success(response))
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