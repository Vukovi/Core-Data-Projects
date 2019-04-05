//
//  AppDelegate.swift
//  CarCare
//
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    /*
     www.edmunds.com
     Upravljanje thread-ovima
     CoreData background process - regulise uzimanje podataka sa servera i njihovo skladistenje u CD dok je UI blokiran
     
     Aplikacija moze da pukne kada se koristi samo jedan MOC za preuzimanje i za cuvanje podataka,
     zato cu koristiti novi background proces -> PersistentContainer.newBackgroundContext
     
     ili stari nacin sa perform metodom ili metodom performAndWait, gde se performAndWait ponasa kao disptchSemaphore
     
     */

    var window: UIWindow?
    let coreData = CoreDataStack()
    var managedObjectContext: NSManagedObjectContext!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        managedObjectContext = coreData.persistentContainer.viewContext
        
        let sourceController = self.window?.rootViewController as! HomeViewController
        sourceController.managedObjectContext = managedObjectContext
        
        // ovde cu odmah da pozovem API
        let carService = CarService(managedObjectContext: managedObjectContext)
        carService.loadVehicleData()
        
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
    }


}

