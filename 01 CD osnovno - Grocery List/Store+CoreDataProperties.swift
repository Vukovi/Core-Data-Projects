//
//  Store+CoreDataProperties.swift
//  Grocery List
//
//  Created by Vuk Knežević on 4/5/19.
//  Copyright © 2019 devhubs. All rights reserved.
//
//

import Foundation
import CoreData


extension Store {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Store> {
        return NSFetchRequest<Store>(entityName: "Store")
    }

    @NSManaged public var name: String?
    @NSManaged public var groceries: NSSet?

}

// MARK: Generated accessors for groceries
extension Store {

    @objc(addGroceriesObject:)
    @NSManaged public func addToGroceries(_ value: Grocery)

    @objc(removeGroceriesObject:)
    @NSManaged public func removeFromGroceries(_ value: Grocery)

    @objc(addGroceries:)
    @NSManaged public func addToGroceries(_ values: NSSet)

    @objc(removeGroceries:)
    @NSManaged public func removeFromGroceries(_ values: NSSet)

}
