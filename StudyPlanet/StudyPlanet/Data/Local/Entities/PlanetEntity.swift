//
// Created by Joris Van Duyse on 27/12/2023.
//

import Foundation
import CoreData

@objc(PlanetEntity)
public class PlanetEntity: NSManagedObject { }

extension PlanetEntity {

    public class func fetchRequest() -> NSFetchRequest<PlanetEntity> {
        NSFetchRequest<PlanetEntity>(entityName: "Planet")
    }

    @NSManaged public var remoteId: Int
    @NSManaged public var userOwnerId: Int
    @NSManaged public var name: String
}