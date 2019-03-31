//
//  ReportTableViewController.swift
//  Car Inventory
//
//  Created by Andi Setiyadi on 9/3/16.
//  Copyright © 2016 devhubs. All rights reserved.
//

import UIKit
import CoreData

protocol ReportTableViewControllerDelegate {
    func updateCars(_ cars: [Car])
}

class ReportTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    // MARK: Properties
    var managedObjectContext: NSManagedObjectContext!
    var delegate: ReportTableViewControllerDelegate!
    var carService: CarService!
    var pickerDatasource = [String]()
    var selectedCarType = "all"
    
    // MARK: Outlets
    @IBOutlet weak var totalCarLabel: UILabel!
    @IBOutlet weak var suvUnder30Label: UILabel!
    @IBOutlet weak var priceMaxField: UITextField!
    @IBOutlet weak var conditionTextField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        
        carService = CarService(managedObjectContext: managedObjectContext)
        let totalCar = carService.getTotalCarInInventorySlow()
        let totalSuvUnder30K = carService.getTotalSUVbyPriceSlow()
        
        pickerDatasource = carService.getCarTypes()
        
        totalCarLabel.text = String(totalCar)
        suvUnder30Label.text = String(totalSuvUnder30K)
        priceMaxField.text = "30000"
        conditionTextField.text = "9"        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: Picker View delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDatasource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDatasource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCarType = pickerDatasource[row]
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        else if section == 1 {
            return 3
        }
        return 0
    }

    @IBAction func setFilterAction(_ sender: UIBarButtonItem) {
        let cars = carService.getInventory(Int(priceMaxField.text!)!, condition: Int(conditionTextField.text!)!, type: selectedCarType)
        
        delegate.updateCars(cars)
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        let cars = carService.getCarInventory()
        
        delegate.updateCars(cars)
        
        dismiss(animated: true, completion: nil)
    }
    
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
}
