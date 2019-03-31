//
//  SaleHistory+CoreDataProperties.swift
//  Home Report
//
//

import Foundation
import CoreData

extension SaleHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SaleHistory> {
        return NSFetchRequest<SaleHistory>(entityName: "SaleHistory");
    }

    @NSManaged public var soldDate: Date?
    @NSManaged public var soldPrice: Double
    @NSManaged public var home: Home?

}
