//
//  SummaryTableViewController.swift
//  Home Report
//
//  Created by Vuk Knezevic on 3/28/19.
//

import UIKit
import CoreData

class SummaryTableViewController: UITableViewController {
    
    @IBOutlet weak var totalSalesDollarLabel: UILabel!
    @IBOutlet weak var numCondoSoldLabel: UILabel!
    @IBOutlet weak var numSFSoldLabel: UILabel!
    
    @IBOutlet weak var minPriceHomeLabel: UILabel!
    @IBOutlet weak var maxPriceHomeLabel: UILabel!
    
    @IBOutlet weak var avgPriceCondoLabel: UILabel!
    @IBOutlet weak var avgpriceSFLabel: UILabel!
    
    var home: Home? = nil
    weak var managedObjectContext: NSManagedObjectContext! {
        didSet {
            return home = Home(context: managedObjectContext)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        totalSalesDollarLabel.text = home?.getTotalHomeSales(moc: managedObjectContext)
        numCondoSoldLabel.text = home?.getNumberCondoSold(moc: managedObjectContext)
        numSFSoldLabel.text = home?.getNumberSingleFamilyHomeSold(moc: managedObjectContext)
        minPriceHomeLabel.text = home?.getHomePriceSold(priceType: "min", moc: managedObjectContext)
        maxPriceHomeLabel.text = home?.getHomePriceSold(priceType: "max", moc: managedObjectContext)
        avgPriceCondoLabel.text = home?.getAverageHomePrice(homeType: HomeType.Condo.rawValue, moc: managedObjectContext)
        avgpriceSFLabel.text = home?.getAverageHomePrice(homeType: HomeType.SingleFamily.rawValue, moc: managedObjectContext)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var rowCount = 0
        switch section {
        case 0:
            rowCount = 3
        case 1, 2:
            rowCount = 2
        default:
            rowCount = 0
        }
        
        return rowCount
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
