//
//  Users+CoreDataProperties.swift
//  Hiral_CoreData
//
//  Created by Hiral Jahlani on 15/09/21.
//
//

import Foundation
import CoreData


extension Users {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Users> {
        return NSFetchRequest<Users>(entityName: "Users")
    }

    @NSManaged public var fullname: String?
    @NSManaged public var email: String?
    @NSManaged public var mobile: String?
    @NSManaged public var bio: String?
    @NSManaged public var profilepic: String?
    @NSManaged public var pin: String?

}

extension Users : Identifiable {

}
