//
//  UsersEntity+CoreDataProperties.swift
//  Suzuki
//
//  Created by Reynald Marquez-Gragasin on 7/10/25.
//
//

import Foundation
import CoreData


extension UsersEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UsersEntity> {
        return NSFetchRequest<UsersEntity>(entityName: "UsersEntity")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var emailadd: String?
    @NSManaged public var fullname: String?
    @NSManaged public var idno: String?
    @NSManaged public var mobileno: String?
    @NSManaged public var password: String?
    @NSManaged public var role: String?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var username: String?

}

extension UsersEntity : Identifiable {

}
