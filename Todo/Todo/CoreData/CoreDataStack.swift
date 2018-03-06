//
//  CoreDataStack.swift
//  Todo
//
//  Created by Hasan on 5.03.2018.
//  Copyright © 2018 Hasan. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack
{
    var container: NSPersistentContainer{
        let container = NSPersistentContainer(name: "Todos")
        
        container.loadPersistentStores{(description, error) in
            guard error == nil else {
                print("Error: \(error!)")
                return
            }
        }
        
        return container
    }
    
    var managedContext: NSManagedObjectContext
    {
        return container.viewContext
    }
}
