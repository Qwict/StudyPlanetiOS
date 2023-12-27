//
// Created by Joris Van Duyse on 21/12/2023.
//


//
// Created by Joris Van Duyse on 18/12/2023.
//

import Foundation

struct GetVersionAction {
    func call(completion: @escaping (VersionDto) -> Void) {

//        guard let url = URL(string: "https://sp.qwict.com/api/v1/health/version") else {
//            print("Error: Invalid URL")
//            return
//        }

        guard let url = URL(string: "http://localhost:9012/api/v1/health/version") else {
            print("Error: Invalid URL")
            return
        }
//        components.url else {
//            return
//        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")


        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                let response = try? JSONDecoder().decode(VersionDto.self, from: data)
                print(response)
                if let response = response {
                    completion(response)
                } else {
                    // Error: Unable to decode response JSON
                }
            } else {
                // Error: API request failed

                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
}


