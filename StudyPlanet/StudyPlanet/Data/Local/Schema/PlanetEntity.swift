//
// Created by Joris Van Duyse on 27/12/2023.
//

import Foundation
import CoreData

@objc(PlanetEntity)
public class PlanetEntity: NSManagedObject, Identifiable { }

extension PlanetEntity {

    public class func fetchRequest() -> NSFetchRequest<PlanetEntity> {
        NSFetchRequest<PlanetEntity>(entityName: "PlanetEntity")
    }

    @NSManaged public var remoteId: Int32
    @NSManaged public var name: String

    @NSManaged public var users: NSSet

    public func toPlanet() -> Planet {
        Planet(
                remoteId: Int(remoteId),
                name: name
        )
    }
}

extension PlanetEntity {
    private static var planetsFetchRequest: NSFetchRequest<PlanetEntity> {
        let request: NSFetchRequest<PlanetEntity> = PlanetEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return request
    }

    static func all() -> NSFetchRequest<PlanetEntity> {
        planetsFetchRequest
    }
}