//
//  GroceryService.swift
//  Grocery List
//
//

import Foundation
import CoreData

class GroceryService {
    var managedObjectContext: NSManagedObjectContext!
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    // MARK: - CRUD
    
    // READ
    func getAllGroceries(withAscendingOrder ascending: Bool) -> NSFetchedResultsController<Grocery> {
        let request: NSFetchRequest<Grocery> = Grocery.fetchRequest()
        var sortDescriptors = [NSSortDescriptor]()
        
        let sort = NSSortDescriptor(key: "item", ascending: ascending)
        sortDescriptors.append(sort)
        
        request.sortDescriptors = sortDescriptors
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        }
        catch let error as NSError {
            print("Get items failed: \(error.localizedDescription)")
        }
        
        return fetchedResultsController
    }
    
    // ADD / CREATE
    func add(groceryItem item: String?, forStore store: String) {
        let grocery = Grocery(context: self.managedObjectContext)
        grocery.item = item
        
        if let store = storeExists(store) {
            add(grocery, forStore: store)
        }
    }
    
    // UPDATE
    func update(currentGroceryItem currentItem: Grocery, withNewItem newItem: String, forStore name: String) {
        currentItem.item = newItem
        let currentStore = currentItem.store
        
        if let store = storeExists(name) {
            add(currentItem, forStore: store)
            checkGrocery(forStore: currentStore!)
        }
    }
    
    // DELETE
    func delete(groceryItem item: Grocery) {
        self.managedObjectContext.delete(item)
        
        do {
            try self.managedObjectContext.save()
        }
        catch let error as NSError {
            print("Delete item failed: \(error.localizedDescription)")
        }
    }
    
    
    // MARK: - Private
    
    private func add(_ item: Grocery, forStore store: Store) {
        let groceries = store.groceries?.mutableCopy() as! NSMutableSet
        groceries.add(item)
        
        store.groceries = groceries.copy() as? NSSet
        
        do {
            try self.managedObjectContext.save()
        }
        catch let error as NSError {
            print("Add item to store failed: \(error.localizedDescription)")
        }
    }
    
    private func storeExists(_ name: String) -> Store? {
        let request: NSFetchRequest<Store> = Store.fetchRequest()
        request.predicate = NSPredicate(format: "name = %@", name)
        
        do {
            let result = try self.managedObjectContext.fetch(request)
            if result.count > 0 {
                return result.first
            }
        }
        catch let error as NSError {
            print("Error checking store existence: \(error.localizedDescription)")
        }
        
        return addNew(store: name)
    }
    
    private func addNew(store name: String) -> Store? {
        let store = Store(context: self.managedObjectContext)
        store.name = name.isEmpty ? "UNKNOWN" : name
        
        do {
            try self.managedObjectContext.save()
        }
        catch let error as NSError {
            print("Add item failed: \(error.localizedDescription)")
            return nil
        }
        
        return store
    }
    
    private func checkGrocery(forStore store: Store) {
        if store.groceries?.count == 0 {
            self.managedObjectContext.delete(store)
            
            do {
                try self.managedObjectContext.save()
            }
            catch let error as NSError {
                print("Delete store failed: \(error.localizedDescription)")
            }
        }
    }
}
