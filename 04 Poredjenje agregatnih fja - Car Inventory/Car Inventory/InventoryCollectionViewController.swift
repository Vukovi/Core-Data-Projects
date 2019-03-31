//
//  InventoryCollectionViewController.swift
//  Car Inventory
//
//  Created by Andi Setiyadi on 9/3/16.
//  Copyright © 2016 devhubs. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "Cell"

class InventoryCollectionViewController: UICollectionViewController, ReportTableViewControllerDelegate, UICollectionViewDelegateFlowLayout {

    var managedObjectContext: NSManagedObjectContext!
    var request: NSFetchRequest<Car>!
    var cars: [Car] = []
    var selectedCar: Car!
    var carService: CarService!
    
    @IBOutlet weak var carCollectionViewLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        carService = CarService(managedObjectContext: managedObjectContext)
        cars = carService.getCarInventory()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return cars.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "carCell", for: indexPath) as! InventoryCollectionViewCell
    
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 5
        cell.layer.borderColor = UIColor.gray.cgColor
        
        let car = cars[(indexPath as NSIndexPath).row]
        let image = UIImage(data: car.thumbnail! as Data)
        cell.carImageView.image = image
        
        cell.carNameLabel.text = "\(car.year) \(car.make!) \(car.model!)"
        cell.carPriceLabel.text = car.price.currencyFormatter
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 10 = = spacing between cell
        // 2 = number of cell per row
        // 170 = height of cell
        return CGSize(width: (UIScreen.main.bounds.width-20)/2,height: 170); //use height whatever you wants.

    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "carDetailSegue" {
            let navController = segue.destination as! UINavigationController
            let carDetailController = navController.topViewController as! CarDetailViewController
            
            let cell = sender as! UICollectionViewCell
            let indexPath = self.collectionView!.indexPath(for: cell)
            
            carDetailController.car = cars[(indexPath! as NSIndexPath).row]
        }
        else if segue.identifier == "reportSegue" {
            let navController = segue.destination as! UINavigationController
            let reportController = navController.topViewController as! ReportTableViewController
            reportController.managedObjectContext = managedObjectContext
            
            reportController.delegate = self
        }
    }

    func updateCars(_ cars: [Car]) {
        self.cars = cars
        self.collectionView?.reloadData()
    }
}
