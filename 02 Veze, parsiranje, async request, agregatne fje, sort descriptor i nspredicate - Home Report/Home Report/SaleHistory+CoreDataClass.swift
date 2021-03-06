//
//  SaleHistory+CoreDataClass.swift
//  Home Report
//
//

import Foundation
import CoreData


public class SaleHistory: NSManagedObject {
    
    // ovde je fetch one to many
    func getSoldHistory(home: Home, moc: NSManagedObjectContext) -> [SaleHistory] {
        let request: NSFetchRequest<SaleHistory> = SaleHistory.fetchRequest()
        // ne mora samo property da se proverava, moze i ceo objekat
        request.predicate = NSPredicate(format: "home = %@", home)
        
        do{
            let soldHistory = try moc.fetch(request)
            return soldHistory
        } catch { fatalError("Error in getting sold hisotry")}
    }
}
