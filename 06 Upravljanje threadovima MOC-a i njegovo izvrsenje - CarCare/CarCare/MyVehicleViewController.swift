//
//  MyVehicleViewController.swift
//  CarCare
//
//

import UIKit
import CoreData

class MyVehicleViewController: UIViewController { //, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        showVehicle()
        // zbog starog nacina threadovanja
        let carService = CarService(managedObjectContext: managedObjectContext)
        carService.showVehicle()
    }
    
//    func showVehicle() {
//        // provera upisa u bazu
//        let request: NSFetchRequest<AutoMaker> = AutoMaker.fetchRequest()
//        request.predicate = NSPredicate(format: "make = 'Subaru'")
//        do{
//            let result = try managedObjectContext.fetch(request)
//            let autoMaker = result.first
//            print("AutoMaker: \(String(describing: autoMaker?.make))")
//        } catch { fatalError() }
//    }
    
    @IBAction func homeAction(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}
