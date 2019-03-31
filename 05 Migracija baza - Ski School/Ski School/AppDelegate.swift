//
//  AppDelegate.swift
//  Ski School
//
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    /*
     Leightweight migracija - automatska migracija - slike LW
     Heavyweight migracija - maualna migracija - slike HW + svi komentari u kodu
     */

    var window: UIWindow?
    var coreData = CoreDataStack()
    var managedObjectContext: NSManagedObjectContext!

    internal func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        managedObjectContext = coreData.persistentContainer.viewContext
        
        let navController = window?.rootViewController as! UINavigationController
        let studentViewController = navController.topViewController as! StudentViewController
        studentViewController.coreData = coreData
        
        checkDataStore()
        
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
    
    func checkDataStore() {
        let request: NSFetchRequest<Student> = Student.fetchRequest()
        
        do {
            let count = try managedObjectContext.count(for: request)
            print("Total students: \(count)")
            
            if count == 0 {
                uploadSampleData()
            }
        }
        catch {
            fatalError("Error getting student count")
        }
    }
    
    func uploadSampleData() {
        let url = Bundle.main.url(forResource: "sample", withExtension: "json")
        let data = try? Data(contentsOf: url!)
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            let jsonArray = jsonResult.value(forKey: "student") as! NSArray
            
            for jsonData in jsonArray {
                let json = jsonData as! [String: AnyObject]
                
                let student = Student(context: managedObjectContext)
                student.name = json["name"] as? String
                student.age = ((json["age"])?.int16Value)!
                student.parentName = json["parentName"] as? String
                student.parentContact = json["parentContact"] as? String
                
                // Posle mapiranja, tj migracije baze ovo moram promeniti
//                student.sport = json["sport"] as? String
//                student.level = json["level"] as? String
                // i to ovako:
                let lesson = Lesson(context: managedObjectContext)
                lesson.sport = json["sport"] as? String
                lesson.level = json["level"] as? String
                student.lesson = lesson
            }
            
            coreData.saveContext()
        }
        catch {
            fatalError("Cannot upload sample data")
        }
    }
}

