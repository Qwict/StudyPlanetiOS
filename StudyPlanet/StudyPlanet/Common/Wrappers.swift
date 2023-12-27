//
// Created by Joris Van Duyse on 27/12/2023.
// Partially based on Medium article by Paul Allies
//

/// A property wrapper for injecting dependencies using the Inversion of Control (IoC) pattern.
@propertyWrapper
struct Inject<I> {
    /// The wrapped value representing the injected dependency.
    let wrappedValue: I

    /// Initializes the property wrapper by resolving the interface to an implementation.
    ///
    /// The implementation is obtained using the shared instance of the IoC resolver.
    init() {
        wrappedValue = Resolver.shared.resolve(I.self)
    }
}