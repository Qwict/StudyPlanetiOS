//
// Created by Joris Van Duyse on 27/12/2023.
// Based on Mediuam article "SwiftUI MVVM clean architecture" by Michał Ziobro
//

public protocol StudyPlanetRepositoryProtocol {
    func authenticate(token: String, completion: @escaping (Result<[AuthenticatedUserDto], Error>) -> Void)
    func login(parameters: LoginDto, completion: @escaping (Result<AuthenticatedUserDto, Error>) -> Void)
    func register(parameters: RegisterDto, completion: @escaping (Result<AuthenticatedUserDto, Error>) -> Void)
}

public final class StudyPlanetRepository: StudyPlanetRepositoryProtocol {
    @Inject private var apiService: StudyPlanetApiProtocol
//    @Inject private var dao: PlanetDaoProtocol

    public func authenticate(token: String, completion: @escaping (Result<[AuthenticatedUserDto], Error>) -> Void) {
        apiService.authenticate(token: token, completion: completion)
    }

    public func login(parameters: LoginDto, completion: @escaping (Result<AuthenticatedUserDto, Error>) -> Void) {
        apiService.login(parameters: parameters, completion: completion)
    }

    public func register(parameters: RegisterDto, completion: @escaping (Result<AuthenticatedUserDto, Error>) -> Void) {
        apiService.register(parameters: parameters, completion: completion)
    }

//    public func insertWordsetCategory() -> AnyPublisher<WordsetCategory, Error> {
//
//        dao.insertReplacing(WordsetCategoryDTO(categoryId: "1", foreignName: "Test", nativeName: "Test", image: nil))
//                .eraseToAnyPublisher()
//    }
}