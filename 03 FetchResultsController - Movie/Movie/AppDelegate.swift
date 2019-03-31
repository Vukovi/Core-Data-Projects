//
//  AppDelegate.swift
//  Movie
//
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    /*
     TableView with Fetch Result Controller - MovieTableViewController.numberOfSections(26), numberOfRowsInSection(33), cellForRowAt(45), loadData(82) + extension
     Delete Record - MovieTableViewController.editingStyle(88), extension(144,145)
     Batch Update - MovieTableViewController.updateRatingAction(51), extension(154)
     Results Grouping and Cashing - MovieService.swift
     */
    

    var window: UIWindow?
    var coreData = CoreDataStack()

    internal func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
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
        let moc = coreData.persistentContainer.viewContext
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
       
        do {
            let movieCount = try moc.count(for: request)
            
            if movieCount == 0 {
                uploadSampleData()
            }
        }
        catch {
            fatalError("Error in counting movie")
        }
    }
    
    func uploadSampleData() {
        let moc = coreData.persistentContainer.viewContext
        let url = Bundle.main.url(forResource: "movies", withExtension: "json")
        let data = NSData(contentsOf: url!)
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            let jsonArray = jsonResult.value(forKey: "movie") as! NSArray
            
            for json in jsonArray {
                let movieData = json as! [String: AnyObject]
                let movie = Movie(context: moc)
                
                guard let title = movieData["name"] else {
                    return
                }
                movie.title = title as? String
                
                guard let userRating = movieData["userRating"] else {
                    return
                }
                movie.userRating = userRating.int16Value
                
                guard let format = movieData["format"] else {
                    return
                }
                movie.format = format as? String
                
                var image: UIImage?
                if let movieImage = movieData["image"] {
                    let imageName = movieImage as? String
                    image = UIImage(named: imageName!)
                    movie.image = NSData(data: image!.jpegData(compressionQuality: 1)!) as Data
                }
            }
            
            coreData.saveContext()
        }
        catch {
            fatalError("Cannot upload sample data")
        }
    }
}

