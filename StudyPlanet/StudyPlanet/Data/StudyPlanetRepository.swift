//
// Created by Joris Van Duyse on 27/12/2023.
// Based on Mediuam article "SwiftUI MVVM clean architecture" by Michał Ziobro
//

import Foundation
import CoreData
import SwiftyBeaver

public protocol StudyPlanetRepositoryProtocol {
    func authenticate(token: String, completion: @escaping (Result<[AuthenticatedUserDto], Error>) -> Void)
    func login(parameters: LoginDto, completion: @escaping (Result<AuthenticatedUserDto, Error>) -> Void)
    func logout()
    func register(parameters: RegisterDto, completion: @escaping (Result<AuthenticatedUserDto, Error>) -> Void)
    func getLocalDiscoveredPlanets(completion: @escaping (Result<[PlanetEntity], Error>) -> Void)
    func getLocalUser(completion: @escaping (Result<UserEntity, Error>) -> Void)

    func startExploring(exploreDto: ExploreDto, completion: @escaping (Result<EmptyResponse, Error>) -> Void)
    func stopExploring(exploreDto: ExploreDto, completion: @escaping (Result<ExploreResponseDto, Error>) -> Void)

    func startDiscovering(discoverDto: DiscoverDto, completion: @escaping (Result<EmptyResponse, Error>) -> Void)
    func stopDiscovering(discoverDto: DiscoverDto, completion: @escaping (Result<DiscoverResponseDto, Error>) -> Void)
}

public final class StudyPlanetRepository: StudyPlanetRepositoryProtocol {
    @Inject private var apiService: StudyPlanetApiProtocol
    @Inject private var databaseService: StudyPlanetDatabase

    private let log = SwiftyBeaver.self

    public func authenticate(token: String, completion: @escaping (Result<[AuthenticatedUserDto], Error>) -> Void) {
        apiService.authenticate(token: token, completion: completion)
    }

    public func login(parameters: LoginDto, completion: @escaping (Result<AuthenticatedUserDto, Error>) -> Void) {
        apiService.login(parameters: parameters) { result in
            switch result {
                case .success(let authenticatedUser):
                    // Save the user to the database
                    self.saveAuthenticatedUserToDatabase(authenticatedUser: authenticatedUser)
                    completion(.success(authenticatedUser))
                case .failure(let error):
                    completion(.failure(error))
            }
        }

    }

    public func logout() {
//        studyPlanetDatabase.deleteAuthenticatedUser()
        databaseService.wipeDatabase()
    }

    private func saveAuthenticatedUserToDatabase(authenticatedUser: AuthenticatedUserDto) {
        SPLogger.shared.debug("Saving authenticated user to database: \(1 + 1)")
        databaseService.saveAuthenticatedUser(authenticatedUser: authenticatedUser) { result in
            switch result {
                case .success(let user):
                    SPLogger.shared.debug("User saved to database: \(user.name)")
                case .failure(let error):
                    SPLogger.shared.debug("Error saving user to database: \(error)")
            }
        }
            
    }

    public func register(parameters: RegisterDto, completion: @escaping (Result<AuthenticatedUserDto, Error>) -> Void) {
        apiService.register(parameters: parameters) { result in
            switch result {
                case .success(let authenticatedUser):
                    // Save the user to the database
                    self.saveAuthenticatedUserToDatabase(authenticatedUser: authenticatedUser)
                    completion(.success(authenticatedUser))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }

    public func getLocalDiscoveredPlanets(completion: @escaping (Result<[PlanetEntity], Error>) -> Void) {
//        studyPlanetDatabase.getPlanets(completion: completion)
    }

    public func getLocalUser(completion: @escaping (Result<UserEntity, Error>) -> Void) {
        databaseService.getLocalUser(completion: completion)
    }

    public func startExploring(exploreDto: ExploreDto, completion: @escaping (Result<EmptyResponse, Error>) -> Void) {
        apiService.startExploring(parameters: exploreDto, completion: completion)
    }

    public func stopExploring(exploreDto: ExploreDto, completion: @escaping (Result<ExploreResponseDto, Error>) -> Void) {
        apiService.stopExploring(parameters: exploreDto) { result in
            switch result {
                case .success(let exploreResponse):
                    self.addExperienceToUser(selectedTime: exploreDto.selectedTime)
                    completion(.success(exploreResponse))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }

    public func startDiscovering(discoverDto: DiscoverDto, completion: @escaping (Result<EmptyResponse, Error>) -> Void) {
        apiService.startDiscovering(parameters: discoverDto, completion: completion)
    }

    public func stopDiscovering(discoverDto: DiscoverDto, completion: @escaping (Result<DiscoverResponseDto, Error>) -> Void) {
        apiService.stopDiscovering(parameters: discoverDto) { result in
            switch result {
                case .success(let discoverResponse):
                    // Save the discovered planet to the database
                    if (discoverResponse.hasFoundNewPlanet) {
                        self.saveDiscoveredPlanetToDatabase(remoteId: discoverResponse.planet.id, name: discoverResponse.planet.name)
                    }
                    self.addExperienceToUser(selectedTime: discoverDto.selectedTime)
                    completion(.success(discoverResponse))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }

    private func addExperienceToUser(selectedTime: Int) {
        databaseService.addExperience(experience: selectedTime / 1000 / 60)
    }

    public func saveDiscoveredPlanetToDatabase(remoteId: Int, name: String) {
        databaseService.saveDiscoveredPlanet(remoteId: remoteId, name: name) { result in
            switch result {
                case .success(let planet):
                    SPLogger.shared.debug("Planet saved to database: \(planet)")
                case .failure(let error):
                    SPLogger.shared.debug("Error saving planet to database: \(error)")
            }
        }
    }

}
