//
//  UsersService.swift
//  Suzuki
//
//  Created by Reynald Marquez-Gragasin on 7/9/25.
//

import Foundation
import CoreData
import UIKit

class UsersService {

    static var viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
    static func save() throws {
        try viewContext.save()
    }
        
    static func saveUser(_ fullname: String, _ emailadd: String, _ mobileno: String, _ username: String, _ password: String) throws {
        do {
            let users = UsersEntity(context: viewContext)
            let id = UUID()
            users.idno = id.uuidString
            users.fullname = fullname
            users.emailadd = emailadd
            users.mobileno = mobileno
            users.username = username
            users.password = password
            users.role = "User"
            users.createdAt = Date()
            users.updatedAt = Date()
            try viewContext.save()
        } catch {
            print("Error! Unable to save user.")
        }
    }
    
    static func updateUser(_ idno: String, _ fullname: String, _ emailadd: String, _ mobileno:       String, _ username: String, _ password: String) throws {
        let key = idno
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "UsersEntity")
        fetchRequest.predicate = NSPredicate(format: "idno = %@", key)
        do {
            let test = try viewContext.fetch(fetchRequest)
            let userUpdate = test[0] as! NSManagedObject
            userUpdate.setValue(fullname, forKey: "fullname")
            userUpdate.setValue(mobileno, forKey: "mobileno")
        } catch {
            print("error...")
        }
        

    }

    
    
}
