//
//  Condo+CoreDataProperties.swift
//  Home Report
//
//

import Foundation
import CoreData

extension Condo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Condo> {
        return NSFetchRequest<Condo>(entityName: "Condo");
    }

    @NSManaged public var unitsPerBuilding: Int16

}
