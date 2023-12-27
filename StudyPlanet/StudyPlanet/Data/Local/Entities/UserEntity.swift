//
// Created by Joris Van Duyse on 27/12/2023.
//

import Foundation
import CoreData

@objc(User)
public class UserEntity: NSManagedObject { }

extension UserEntity {

    public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        NSFetchRequest<UserEntity>(entityName: "User")
    }

    @NSManaged public var remoteId: Int
    @NSManaged public var email: String
    @NSManaged public var name: String
    @NSManaged public var experience: Int
}