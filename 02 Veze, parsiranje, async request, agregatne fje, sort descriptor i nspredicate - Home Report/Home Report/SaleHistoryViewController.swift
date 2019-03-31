//
//  SaleHistoryViewController.swift
//  Home Report
//
//  Created by Vuk Knezevic on 3/28/19.
//  Copyright © 2019 devhubs. All rights reserved.
//

import UIKit
import CoreData

class SaleHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK : Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    lazy var soldHistory = [SaleHistory]()
    
    var home: Home?
    
    weak var managedObjectContext: NSManagedObjectContext!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadSoldHistory()
        
        if let homeImage = home?.image {
            let image = UIImage(data: homeImage as Data)
            imageView.image = image
            imageView.layer.borderWidth = 1
            imageView.layer.cornerRadius = 4
        }
        
        // eliminisao visak linija na dnu
        tableView.tableFooterView = UIView()
    }
    

    // MARK: Tableview datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return soldHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! SaleHistoryTableViewCell
        let saleHisotry = soldHistory[indexPath.row]
        cell.configureCell(saleHistory: saleHisotry)
        return cell
    }
    
    // MARK: Private function
    private func loadSoldHistory() {
        let saleHistory = SaleHistory(context: managedObjectContext)
        soldHistory = saleHistory.getSoldHistory(home: home!, moc: managedObjectContext)
        tableView.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
