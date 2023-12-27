//
// Created by Joris Van Duyse on 27/12/2023.
//

/// A utility class for resolving dependencies using Inversion of Control (IoC).
class Resolver {
    /// The shared instance of the resolver.
    static let shared = Resolver()

    /// The Inversion of Control (IoC) container.
    ///
    /// This container holds the registered dependencies for the app.
    private var container = buildContainer()

    /// Resolves a dependency of the specified type.
    ///
    /// - Parameter type: The type of the dependency to be resolved.
    /// - Returns: An instance of the resolved dependency.
    ///
    /// - Important: If the dependency cannot be resolved, a fatal error will be triggered.
    func resolve<T>(_ type: T.Type) -> T {
        guard let resolvedValue = container.resolve(T.self) else {
            fatalError("Could not resolve \(T.self)")
        }
        return container.resolve(T.self)!
    }
}