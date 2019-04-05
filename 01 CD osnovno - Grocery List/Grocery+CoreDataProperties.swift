//
//  Grocery+CoreDataProperties.swift
//  Grocery List
//
//  Created by Vuk Knežević on 4/5/19.
//  Copyright © 2019 devhubs. All rights reserved.
//
//

import Foundation
import CoreData


extension Grocery {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Grocery> {
        return NSFetchRequest<Grocery>(entityName: "Grocery")
    }

    @NSManaged public var item: String?
    @NSManaged public var store: Store?

}
