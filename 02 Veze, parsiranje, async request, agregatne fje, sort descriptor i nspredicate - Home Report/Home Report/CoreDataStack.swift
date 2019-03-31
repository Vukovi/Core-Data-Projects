//
//  CoreDataStack.swift
//  Home Report
//
//

import Foundation
import CoreData


// ovo se obicno skine iz AppDelegate-a i napravi se ovaj fajl CoreDataStack

class CoreDataStack {
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Home_Report")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
