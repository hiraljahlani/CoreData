//
//  DatabaseHelper.swift
//  Hiral_CoreData
//
//  Created by Hiral Jahlani on 15/09/21.
//

import Foundation
import CoreData
import UIKit

class DatabaseHelper {
    
   //Single Tone
   static var shareInstance = DatabaseHelper()
    
   let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
   func save(object:[String:String]) -> Users? {
    
        let user = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context!) as! Users
        user.fullname = object["fullname"]
        user.email = object["email"]
        user.mobile = object["mobile"]
        user.bio = object["bio"]
        user.profilepic = object["profilepic"]
        user.pin = object["pin"]
        do {
            try context!.save()
            return user
        } catch {
            print("Data is not save")
            return nil
        }
    }
    
    
    func getUsersData() -> [Users] {
        var user:[Users] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Users")
        do{
            user = try context!.fetch(fetchRequest) as! [Users]
        }catch{
            print("Not get data")
        }
        return user
    }
}
