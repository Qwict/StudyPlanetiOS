//
// Created by Joris Van Duyse on 27/12/2023.
//

import Foundation
import CoreData

@objc(UserEntity)
public class UserEntity: NSManagedObject { }

extension UserEntity {

    public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    public class func fetchRequest(withRemoteId remoteId: Int) -> NSFetchRequest<UserEntity> {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "remoteId == %d", remoteId)
        return request
    }

    public class func fetchRequest(withEmail email: String) -> NSFetchRequest<UserEntity> {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@", email)
        return request
    }

    @NSManaged public var remoteId: Int32
    @NSManaged public var email: String
    @NSManaged public var name: String
    @NSManaged public var experience: Int32

    @NSManaged public var planets: NSSet
}

extension UserEntity {
    static func active() -> NSFetchRequest<UserEntity> {
        let email = AuthenticationManager.shared.getEmail()

        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "email", ascending: true)]
        return fetchRequest
    }
}