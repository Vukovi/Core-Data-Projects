//
//  CarService.swift
//  Car Inventory
//
//  Created by Andi Setiyadi on 9/3/16.
//  Copyright © 2016 devhubs. All rights reserved.
//

import Foundation
import CoreData

public class CarService {
    
    public var managedObjectContext: NSManagedObjectContext!
    
    public init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    func getCarInventory() -> [Car] {
        let request: NSFetchRequest<Car> = Car.fetchRequest()
        // ovim se podesava koicina podataka koji se uzimaju iz CoreData-a
        // ovo se zove incremental fetching
        request.fetchBatchSize = 15 // npr 15 slika da uzme iz db
        
        let results: [Car]
        
        do {
            results = try managedObjectContext.fetch(request)
        }
        catch {
            fatalError("Error getting car inventory")
        }
        
        return results
    }
    
    // **** UNIT TESTING je pokazao da je getTotalCarInInventorySlow_UPDATED brzi od getTotalCarInInventorySlow **** //
    // **** To je zato sto prva pravi objekte u vidu results, i onda prebrojava brojeve, dok drugu ne interesuju objekti vec samo koliko ih ima **** //
    
    public func getTotalCarInInventorySlow() -> Int {
        let request: NSFetchRequest<Car> = Car.fetchRequest()
        let results: [Car]
        
        do {
            results = try managedObjectContext.fetch(request)
        }
        catch {
            fatalError("Error getting car inventory")
        }
        
        return results.count
    }
    
    public func getTotalCarInInventorySlow_UPDATED() -> Int {
        let request: NSFetchRequest<Car> = Car.fetchRequest()
        request.resultType = .countResultType
        
        do {
            let results = try managedObjectContext.fetch(request as! NSFetchRequest<NSFetchRequestResult>) as! [NSNumber]
            let count = results.first!.intValue
            return count
        }
        catch {
            fatalError("Error getting car inventory")
        }
        
    }
    
    ///  metode koje daju broj automobila su uporedjene ///
    
    
    // **** UNIT TESTING je pokazao da je testGetTotalSUVbyPriceSlow_UPDATED brzi od getTotalSUVbyPriceSlow **** //
    // **** To je zato sto prva pravi objekte u vidu results, i onda prebrojava brojeve, dok drugu ne interesuju objekti vec samo koliko ih ima **** //
    
    public func getTotalSUVbyPriceSlow() -> Int {
        // ovde je upotrebljen specs.type kao kriterijum pretrage
        // specs je veza kod entiteta Car i povezuje ga sa entitetom Specification koji ima atribut type, zato je moguce specs.type
        let predicate = NSPredicate(format: "specs.type == 'suv' && price <= 30000")
        let request: NSFetchRequest<Car> = Car.fetchRequest()
        request.predicate = predicate
        
        let results: [Car]
        
        do {
            results = try managedObjectContext.fetch(request)
        }
        catch {
            fatalError("Error getting car inventory")
        }
        
        return results.count
    }
    
    public func getTotalSUVbyPriceSlow_UPDATED() -> Int {
        let predicate = NSPredicate(format: "specs.type == 'suv' && price <= 30000")
        let request: NSFetchRequest<Car> = Car.fetchRequest()
        request.predicate = predicate
        
        
        do {
            let results = try managedObjectContext.count(for: request)
            return results
        }
        catch {
            fatalError("Error getting car inventory")
        }
        
    }
    
    ///  metode koje daju broj automobila prema ceni su uporedjene ///
    
    
    // **** UNIT TESTING je pokazao da je getInventory_UPDATED brzi od getInventory **** //
    // **** To je zato sto sam predikate, tj uslove pretrage, poredjao u niz tako da se izvrsavaju od najrestriktivnijeg ka najmanje restriktivnom **** //
    
    public func getInventory(_ price: Int, condition: Int, type: String) -> [Car] {
        let pricePredicate = NSPredicate(format: "price <= %@", NSNumber(value: price))
        let conditionPredicate = NSPredicate(format: "specs.conditionRating >= %@", NSNumber(value: condition))
        
        var predicateArray = [pricePredicate, conditionPredicate]
        
        let carTypePredicate = type != "all" ? NSPredicate(format: "specs.type == %@", type) : NSPredicate()
        
        if carTypePredicate is NSComparisonPredicate {
            predicateArray.append(carTypePredicate)
        }
        
        let predicate = NSCompoundPredicate(type: .and, subpredicates: predicateArray)
        
        let request: NSFetchRequest<Car> = Car.fetchRequest()
        request.predicate = predicate
        request.fetchBatchSize = 16
        
        let results: [Car]
        
        do {
            results = try managedObjectContext.fetch(request)
        }
        catch {
            fatalError("Error getting car inventory")
        }
        
        return results
    }
    
    public func getInventory_UPDATED(_ price: Int, condition: Int, type: String) -> [Car] {
        
        var predicateArray = [NSPredicate]()
        
        let carTypePredicate = type != "all" ? NSPredicate(format: "specs.type == %@", type) : NSPredicate()
        
        if carTypePredicate is NSComparisonPredicate {
            predicateArray.append(carTypePredicate)
        }
        
        let pricePredicate = NSPredicate(format: "price <= %@", NSNumber(value: price))
        predicateArray.append(pricePredicate)
        
        let conditionPredicate = NSPredicate(format: "specs.conditionRating >= %@", NSNumber(value: condition))
        predicateArray.append(conditionPredicate)
        
        let predicate = NSCompoundPredicate(type: .and, subpredicates: predicateArray)
        
        let request: NSFetchRequest<Car> = Car.fetchRequest()
        request.predicate = predicate
        request.fetchBatchSize = 16
        
        let results: [Car]
        
        do {
            results = try managedObjectContext.fetch(request)
        }
        catch {
            fatalError("Error getting car inventory")
        }
        
        return results
    }
    
    ///  metode pretrage automobila su uporedjene ///
    
    
    // **** UNIT TESTING je pokazao da je getCarTypes_UPDATED brzi od getCarTypes **** //
    
    public func getCarTypes() -> [String] {
        let request: NSFetchRequest<Specification> = Specification.fetchRequest()
        
        var results: [Specification]
        var carTypes = ["all"]
        
        do {
            results = try managedObjectContext.fetch(request)
            for spec in results {
                if !carTypes.contains(spec.type!) {
                    carTypes.append(spec.type!)
                }
            }
        }
        catch {
            fatalError("Error getting list of car types from inventory")
        }
        
        return carTypes
    }
    
    public func getCarTypes_UPDATED() -> [String] {
        let request: NSFetchRequest<Specification> = Specification.fetchRequest()
        request.propertiesToFetch = ["type"]
        request.returnsDistinctResults = true
        request.resultType = .dictionaryResultType
        
        var results: [[String: String]]
        var carTypes = ["all"]
        
        do {
            results = try managedObjectContext.fetch(request as! NSFetchRequest<NSFetchRequestResult>) as! [[String: String]]
            for spec in results {
                carTypes.append(spec["type"]!)
            }
        }
        catch {
            fatalError("Error getting list of car types from inventory")
        }
        
        return carTypes
    }
}
