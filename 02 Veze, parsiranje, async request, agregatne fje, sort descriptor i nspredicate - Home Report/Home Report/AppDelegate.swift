//
//  AppDelegate.swift
//  Home Report
//
//  Created by Andi Setiyadi on 8/30/16.
//  Copyright © 2016 devhubs. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    /*
     SADRZAJ:
     Entity relationships (slike), JSON (AppDelegate.uploadSampleData() - 96)
     Visestruko uklanjanje podataka (AppDelegate.deleteRecords() - 187)
     Records Searching (Home+CoreDataClass.getHomesByStatus - 23)
     Fetch One To Many (SaleHistory+CoreDataClass.getSoldHistory - 16)
     Sort Descriptor & Compound Predicate (FilterTableViewController - didSelectRowAt (57), setSortDescriptor(78), setFilterSearchPredicate(82) | HomeListViewController - loadData(81-94), -prepare(119-120), extension HomeListViewController)
     Agregatne f-je: sum, count, min, max (Home+CoreDataClass.getTotalHomeSales - 50, Home+CoreDataClass.getNumberCondoSold - 71, Home+CoreDataClass.getNumberSingleFamilyHomeSold - 89, Home+CoreDataClass.getHomePriceSold - 107, Home+CoreDataClass.getAverageHomePrice - 129)
     Async request (Home+CoreDataClass.getHomesByStatus(19, 23) | HomeListViewController.loadDara(101))
     */

    var window: UIWindow?
    var coreData = CoreDataStack()

    internal func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // NA APP STORE SKINI SQLITE
        // DRUGA APP JE NA SIMPHOLDERS.COM
        // treba proveriti sto ne radi pomocu ovoga iznad
        //        deleteRecords()
        checkDataStore()
        
        let managedObjectContext = coreData.persistentContainer.viewContext
        
        let tabBarController = self.window?.rootViewController as! UITabBarController
        
        // First tab - Home List
        let homeListNavigationController = tabBarController.viewControllers![0] as! UINavigationController
        let homeListViewController = homeListNavigationController.topViewController as! HomeListViewController
        homeListViewController.managedObjectContext = managedObjectContext
        
        // Second tab - Summary View
        let summaryNavigationController = tabBarController.viewControllers![1] as! UINavigationController
        let summaryController = summaryNavigationController.topViewController as! SummaryTableViewController
        summaryController.managedObjectContext = managedObjectContext
        
         return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        coreData.saveContext()
    }
    
    // PARSIRANJE JSON-a
    // ovde je ideja da se Core Data popuni podacima koji dolaze od JSON-a iz fajla homes.json
    // ako vec imamo podatke u CoreDate-i necemo opet popunjavati podacima i za to ce sluziti ova f-ja
    func checkDataStore() {
        
        let request: NSFetchRequest<Home> = Home.fetchRequest()
        
        let moc = coreData.persistentContainer.viewContext
        
        do {
            // ovde ce proveriti da li je baza prazna
            let homeCount = try moc.count(for: request)
            if homeCount == 0 {
                uploadSampleData()
            }
        } catch { fatalError("Error in counting home record") }
    }
    
    func uploadSampleData() {
        let moc = coreData.persistentContainer.viewContext

        let url = Bundle.main.url(forResource: "homes", withExtension: "json")
        let data = try? Data(contentsOf: url!)
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
            let jsonArray = jsonResult.value(forKey: "home") as! NSArray
            for json in jsonArray {
                let homeData = json as! [String: AnyObject]
                
                // Location
                guard let city = homeData["city"] else { return }
                
                // Price
                guard let price = homeData["price"] else { return }
                
                // Bed
                guard let bed = homeData["bed"] else { return }
                
                // Bath
                guard let bath = homeData["bath"] else { return }
                
                // Sqrt
                guard let sqft = homeData["sqft"] else { return }
                
                // Image
                var image: UIImage?
                if let currentImage = homeData["image"] as? String {
                    image = UIImage(named: currentImage)
                }
                
                // HomeType
                guard let homeCategory = homeData["category"] else { return }
                let homeType = (homeCategory as! NSDictionary)["homeType"] as? String
                
                // HomeStatus
                guard let status = homeData["status"] else { return }
                let isForSale = (status as! NSDictionary)["isForSale"] as? Bool
                
                // Home object inicijalizacija i to je primena polimorfizma kod CoreData-e
                let home = homeType?.caseInsensitiveCompare("condo") == .orderedSame  ? Condo(context: moc) : SingleFamily(context: moc)
                home.price = price as! Double
                home.city = city as? String
                home.bed = bed as! Int16
                home.bath = bath as! Int16
                home.sqft = sqft as! Int16
                home.image = NSData(data: image!.jpegData(compressionQuality: 1.0)!)
                home.homeType = homeType
                home.isForSale = isForSale!
                
                if let unitsPerBuilding = homeData["unitsPerBuilding"] {
                    (home as! Condo).unitsPerBuilding = unitsPerBuilding.int16Value
                }
                
                if let lotSize = homeData["lotSize"] {
                    (home as! SingleFamily).lotSize = lotSize.int16Value
                }
                
                // SaleHistories
                if let saleHistories = homeData["saleHistory"] {
                    // ovo radim sa mutabilnim setom jer ce biti promena a NSSet nije mutabilan i njega cemo popuniti iz JSON-a
                    let saleHistoryData = home.saleHistory?.mutableCopy() as! NSMutableSet
                    
                    // prolazim kroz JSON
                    for saleDetail in saleHistories as! NSArray {
                        let saleHisotry = SaleHistory(context: moc)
                        
                        let saleData = saleDetail as! [String: AnyObject]
                        saleHisotry.soldPrice = saleData["soldPrice"] as! Double
                        
                        let soldDateStr = saleData["soldDate"] as! String
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-mm-dd"
                        let soldDate = dateFormatter.date(from: soldDateStr)
                        saleHisotry.soldDate = soldDate
                        
                        saleHistoryData.add(saleHisotry)
//                        home.addToSaleHistory(saleHistoryData)
                        home.saleHistory = saleHistoryData.copy() as? NSSet
                    }
                }
            }
            
            coreData.saveContext()
            
        } catch { fatalError("Can not update sample data") }
    }
    
    
    func deleteRecords() {
        let moc = coreData.persistentContainer.viewContext
        let homeRequest: NSFetchRequest<Home> = Home.fetchRequest()
        let saleHistoryRequest: NSFetchRequest<SaleHistory> = SaleHistory.fetchRequest()
        
        // performanse NSBatchDeleteRequest su mnogo bolje nego sto je to kod pojedincanog regularnog brisanja
        var deleteRequest: NSBatchDeleteRequest
        var deleteResults: NSPersistentStoreResult
        
        do {
            // ovde brise home
            deleteRequest = NSBatchDeleteRequest(fetchRequest: homeRequest as! NSFetchRequest<NSFetchRequestResult>)
            deleteResults = try moc.execute(deleteRequest)
            
            // ovde brise saleHistory
            deleteRequest = NSBatchDeleteRequest(fetchRequest: saleHistoryRequest as! NSFetchRequest<NSFetchRequestResult>)
            deleteResults = try moc.execute(deleteRequest)
            
        } catch { fatalError("failed removing existing record") }
    }
}

