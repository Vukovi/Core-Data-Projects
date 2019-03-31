//
//  HomeListViewController.swift
//  Home Report
//
//  Created by Andi Setiyadi on 9/1/16.
//  Copyright © 2016 devhubs. All rights reserved.
//

import UIKit
import CoreData

class HomeListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: Outlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    // KONTROLERI KOJI TREBA DA KORISTE MOC, NE TREBA DA ZNAJU ODAKLE DOLAZI MOC, SAMO DA GA KORISTE
    // ZATO NIJE PRAVLJENA INSTANCA APPDELEGATE-A VEC JE U APPDELEGATE-U NAPRAVLJENA INSTANCE OVOG KONTROLERA I DODELJEN MU JE MOC
    weak var managedObjectContext: NSManagedObjectContext! {
        didSet {
            return home = Home(context: managedObjectContext)
        }
    }
    
    lazy var homes = [Home]()
    var home: Home? = nil
    var isForSale: Bool = true
    var selectedHome: Home?
    var sortDescriptor = [NSSortDescriptor]()
    var searchPredicate: NSPredicate?
    var request: NSFetchRequest<Home>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        request = Home.fetchRequest()
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentedAction(_ sender: UISegmentedControl) {
        let selecetdValue = sender.titleForSegment(at: sender.selectedSegmentIndex)
        isForSale = selecetdValue == "For Sale" ? true : false
        loadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homes.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeListTableViewCell
        
        let currentHome = homes[indexPath.row]
        
        cell.configureCell(home: currentHome)
        
        return cell
    }
    
    // MARK: Private function
    // KONTROLER NE TREBA DA BUDE SVESTAN BIZNIS LOGIKE, TAKO DA SE ONA MOZE NAPISATI U KLASI SAMOG ENTITETA
    private func loadData() {
        var predicates = [NSPredicate]()
        
        let statusPredicate = NSPredicate(format: "isForSale = %@", isForSale)
        predicates.append(statusPredicate)
        // ako searchPredicate ima neku vrednost unutar sebe, hocu i tu vrednost da ukljucim u ovaj niz predikata
        if let additionalPredicate = searchPredicate {
            predicates.append(additionalPredicate)
        }
        // sada cemo da koristimo compound predicate
        let predicate = NSCompoundPredicate(type: .and, subpredicates: predicates)
        // .and je zato sto hocu da ukljucim i statusPredicate i additionalPredicate
        request?.predicate = predicate
        
        if sortDescriptor.count > 0 {
            request?.sortDescriptors = sortDescriptor
        }
        
        // ovo je NE async request
//        homes = home!.getHomesByStatus(request: request!, moc: managedObjectContext)
//        tableView.reloadData()
        
        // ovo je ASYNC request
        home?.getHomesByStatus(request: request!, moc: managedObjectContext, completionHandler: { [weak self] (homesByStatus) in
            self?.homes = homesByStatus
            self?.tableView.reloadData()
        })
        
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueHistory" {
            let selectedIndexPath = tableView.indexPathForSelectedRow
            selectedHome = homes[selectedIndexPath!.row]
            
            let destinationController = segue.destination as! SaleHistoryViewController
            destinationController.home = selectedHome
            destinationController.managedObjectContext = managedObjectContext
        } else if segue.identifier == "segueToFilter" {
            sortDescriptor = []
            searchPredicate = nil
            let controller = segue.destination as! FilterTableViewController
            controller.delegate = self
        }
    }
    

}

extension HomeListViewController: FilterTableViewControllerDelegate {
    func updateHomeList(filterBy: NSPredicate?, sortBy: NSSortDescriptor?) {
        if let filter = filterBy {
            searchPredicate = filter
        }
        
        if let sort = sortBy {
            sortDescriptor.append(sort)
        }
    }
}
