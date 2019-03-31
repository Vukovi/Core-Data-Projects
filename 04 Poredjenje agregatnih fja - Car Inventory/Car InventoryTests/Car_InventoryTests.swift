//
//  Car_InventoryTests.swift
//  Car InventoryTests
//
//  Created by Vuk Knezevic on 3/29/19.
//  Copyright © 2019 devhubs. All rights reserved.
//

import XCTest
import Car_Inventory

class Car_InventoryTests: XCTestCase {

    var carService: CarService!
    var coreData: CoreDataStack!
    
    override func setUp() {
        coreData = CoreDataStack()
        carService = CarService(managedObjectContext: coreData.persistentContainer.viewContext)
        
        carService.managedObjectContext = coreData.persistentContainer.viewContext
        carService.managedObjectContext.stalenessInterval = 0 // opet sam sa ovim siguran da dobija sveze podatke
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    // poredim metode koje prebrojavaju
    
    /*
    func testGetTotalCarInInventory() {
        self.measure {
            _ = self.carService.getTotalCarInInventorySlow()
        }
    }
    
    func testGetTotalCarInInventory_UPDATED() {
        self.measure {
            _ = self.carService.getTotalCarInInventorySlow_UPDATED()
        }
    }
    */
    
    
    // poredim metode koje prebrojavaju po ceni
    
    /*
    func testGetTotalSUVbyPriceSlow() {
        self.measure {
            _ = self.carService.getTotalSUVbyPriceSlow()
        }
    }
    
    func testGetTotalSUVbyPriceSlow_UPDATED() {
        self.measure {
            _ = self.carService.getTotalSUVbyPriceSlow_UPDATED()
        }
    }
 */
    
    
    // poredim metode koje prebrojavaju sve elemente
    
    /*
    func testGetInventory() {
        self.measure {
            _ = self.carService.getInventory(30000, condition: 8, type: "all")
        }
    }
    
    func testGetInventory_UPDATED() {
        self.measure {
            _ = self.carService.getInventory_UPDATED(30000, condition: 8, type: "all")
        }
    }
    */
    
    func testGetCarTypes() {
        self.measure {
            _ = self.carService.getCarTypes()
        }
    }
    
    func testGetCarTypes_UPDATED() {
        self.measure {
            _ = self.carService.getCarTypes_UPDATED()
        }
    }
    
}
