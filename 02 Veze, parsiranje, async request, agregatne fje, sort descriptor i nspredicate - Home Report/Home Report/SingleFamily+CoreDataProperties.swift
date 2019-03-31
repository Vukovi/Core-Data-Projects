//
//  SingleFamily+CoreDataProperties.swift
//  Home Report
//
//

import Foundation
import CoreData

extension SingleFamily {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SingleFamily> {
        return NSFetchRequest<SingleFamily>(entityName: "SingleFamily");
    }

    @NSManaged public var lotSize: Int16

}
