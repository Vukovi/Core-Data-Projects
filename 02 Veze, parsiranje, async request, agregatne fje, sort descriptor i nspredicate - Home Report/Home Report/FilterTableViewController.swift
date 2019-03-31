//
//  FilterTableViewController.swift
//  Home Report
//
//  Created by Andi Setiyadi on 9/1/16.
//  Copyright © 2016 devhubs. All rights reserved.
//

import UIKit

protocol FilterTableViewControllerDelegate: class {
    func updateHomeList(filterBy: NSPredicate?, sortBy: NSSortDescriptor?)
}

class FilterTableViewController: UITableViewController {
    
    // Sort
    @IBOutlet weak var sortByLocationCell: UITableViewCell!
    @IBOutlet weak var sortByPriceLowHighCell: UITableViewCell!
    @IBOutlet weak var sortByPriceHighLowCell: UITableViewCell!
    
    // Filter
    @IBOutlet weak var filterByCondoCell: UITableViewCell!
    @IBOutlet weak var filterBySingleFamilyCell: UITableViewCell!
    
    // MARK: Properties
    var sortDescriptor: NSSortDescriptor?
    var searchPredicate: NSPredicate?
    weak var delegate: FilterTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return section == 0 ? 3 : 2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)!
        switch selectedCell {
        case sortByLocationCell:
            // sortira se prema nazivima atributa u entitetima
            setSortDescriptor(sortBy: "city", isAscending: true)
        case sortByPriceLowHighCell:
            setSortDescriptor(sortBy: "price", isAscending: true)
        case sortByPriceHighLowCell:
            setSortDescriptor(sortBy: "price", isAscending: false)
        case filterByCondoCell, filterBySingleFamilyCell:
            setFilterSearchPredicate(filterBy: selectedCell.textLabel!.text!)
        default:
            print("No Cell Selected")
        }
        
        selectedCell.accessoryType = .checkmark
        delegate?.updateHomeList(filterBy: searchPredicate, sortBy: sortDescriptor)
    }
    
    // MARK: Private function
    private func setSortDescriptor(sortBy: String, isAscending: Bool) {
        sortDescriptor = NSSortDescriptor(key: sortBy, ascending: isAscending)
    }
    
    private func setFilterSearchPredicate(filterBy: String) {
        searchPredicate = NSPredicate(format: "homeType = %@", filterBy)
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
