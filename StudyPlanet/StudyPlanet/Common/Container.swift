//
// Created by Joris Van Duyse on 27/12/2023.
// Partially based on Medium article by Paul Allies
//

import Swinject

/// Builds and configures the dependency injection container for the StudyPlanet app.
///
/// This function initializes a Swinject container and registers the necessary dependencies
/// to be used throughout the app.
///
/// - Returns: The configured Swinject container.
func buildContainer() -> Container {
    let container = Container()

    // Injected in data layer to talk to the API
    container.register(StudyPlanetApiProtocol.self) { _  in
        StudyPlanetApi()
    }.inObjectScope(.container)

    // Injected in domain layer to talk to the data layer
    container.register(StudyPlanetRepositoryProtocol.self) { _  in
        StudyPlanetRepository()
    }.inObjectScope(.container)

    return container
}