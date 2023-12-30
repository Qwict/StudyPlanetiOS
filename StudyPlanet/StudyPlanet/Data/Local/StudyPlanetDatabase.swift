//
// Created by Joris Van Duyse on 29/12/2023.
//

import Foundation
import CoreData

final class StudyPlanetDatabase {
    public static let shared = StudyPlanetDatabase()

    private let persistentContainer: NSPersistentContainer

    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    

    private init() {
        SPLogger.shared.debug("StudyPlanetDatabase init")
        persistentContainer = NSPersistentContainer(name: "StudyPlanetDatabaseModel")
        persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to start database: \(error)")
            }
        }
    }
    
    private lazy var userEntity: NSEntityDescription = {
        return NSEntityDescription.entity(forEntityName: "UserEntity", in: viewContext)!
    }()

    private lazy var planetEntity: NSEntityDescription = {
        return NSEntityDescription.entity(forEntityName: "PlanetEntity", in: viewContext)!
    }()

    func wipeDatabase() {
        let entities = self.persistentContainer.managedObjectModel.entities
        entities.flatMap({ $0.name }).forEach(clearDeepObjectEntity)
    }

    private func clearDeepObjectEntity(_ entity: String) {
        let context = self.persistentContainer.viewContext

        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("Failed to clear deep object entity \(entity): \(error)")
        }
    }


    func saveAuthenticatedUser(authenticatedUser: AuthenticatedUserDto, completion: @escaping (Result<UserEntity, Error>) -> Void) {
        let userEntity = UserEntity(context: viewContext)
        userEntity.name = authenticatedUser.user.name
        userEntity.email = authenticatedUser.user.email
        userEntity.remoteId = Int32(authenticatedUser.user.id)
        userEntity.experience = Int32(authenticatedUser.user.experience)

        let planets = authenticatedUser.user.discoveredPlanets.map { planetDto in
            let planetEntity = PlanetEntity(context: viewContext)
            planetEntity.name = planetDto.name
            planetEntity.remoteId = Int32(planetDto.id)
            planetEntity.users = NSSet(array: [userEntity])
            viewContext.insert(planetEntity)
            return planetEntity
        }
        if (!planets.isEmpty) {
            userEntity.planets = NSSet(array: planets)
        }


        do {
            viewContext.insert(userEntity)
            try viewContext.save()
            completion(.success(userEntity))
        } catch {
            completion(.failure(error))
        }
    }

    func deleteAuthenticatedUser() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "UserEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try viewContext.execute(deleteRequest)
        } catch let error as NSError {
            SPLogger.shared.error("\(error)")
        }
    }

    func getLocalUser(completion: @escaping (Result<UserEntity, Error>) -> Void) {
        let email = AuthenticationManager.shared.getEmail()

        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)

        do {
            let users = try viewContext.fetch(fetchRequest)
            if let user = users.first {
                completion(.success(user))
            } else {
                completion(.failure(NSError(domain: "StudyPlanetDatabase", code: 404, userInfo: nil)))
            }
        } catch {
            SPLogger.shared.error("\(error)")
            completion(.failure(error))
        }
    }

    func saveDiscoveredPlanet(remoteId: Int, name: String, completion: @escaping (Result<PlanetEntity, Error>) -> Void) {
        let email = AuthenticationManager.shared.getEmail()

        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)

        do {
            let users = try viewContext.fetch(fetchRequest)
            if let user = users.first {
                let planetEntity = PlanetEntity(context: viewContext)
                planetEntity.name = name
                planetEntity.remoteId = Int32(remoteId)
                planetEntity.users = NSSet(array: [user])
                viewContext.insert(planetEntity)
                try viewContext.save()
                completion(.success(planetEntity))
            } else {
                completion(.failure(NSError(domain: "StudyPlanetDatabase", code: 404, userInfo: nil)))
            }
        } catch {
            completion(.failure(error))
        }
    }

    func addExperience(experience: Int) -> Void {
        getLocalUser { result in
            switch result {
                case .success(let user):
                    user.experience += Int32(experience)
                    do {
                        try self.viewContext.save()
                    } catch {
                        SPLogger.shared.debug("Error saving experience to user: \(error)")
                    }
                case .failure(let error):
                    SPLogger.shared.debug("Error getting user: \(error)")
            }
        }
    }


}
