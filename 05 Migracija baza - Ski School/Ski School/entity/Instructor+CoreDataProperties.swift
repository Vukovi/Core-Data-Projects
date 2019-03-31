//
//  Instructor+CoreDataProperties.swift
//  Ski School
//
//  Created by Vuk Knezevic on 3/31/19.
//
//

import Foundation
import CoreData


extension Instructor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Instructor> {
        return NSFetchRequest<Instructor>(entityName: "Instructor")
    }

    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var lesson: Lesson?

}
