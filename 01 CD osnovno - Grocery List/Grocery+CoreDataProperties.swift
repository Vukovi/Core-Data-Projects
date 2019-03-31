//
//  Grocery+CoreDataProperties.swift
//  Grocery List
//
//  Created by Vuk Knezevic on 3/27/19.
//
//

import Foundation
import CoreData


extension Grocery {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Grocery> {
        return NSFetchRequest<Grocery>(entityName: "Grocery")
    }

    @NSManaged public var item: String?

}
