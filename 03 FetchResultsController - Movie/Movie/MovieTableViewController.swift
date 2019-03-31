//
//  MovieTableViewController.swift
//  Movie
//
//  Created by Andi Setiyadi on 9/2/16.
//  Copyright © 2016 devhubs. All rights reserved.
//

import UIKit
import CoreData

class MovieTableViewController: UITableViewController {

    var fetchedResultController: NSFetchedResultsController<Movie>!
    lazy var coreData = CoreDataStack()
    var movieToDelete: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchedResultController.sections {
            return sections.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell

        let movie = fetchedResultController.object(at: indexPath)
        cell.configureCell(movie: movie)

        return cell
    }
    
    @IBAction func updateRatingAction(_ sender: UIBarButtonItem) {
        let managedObjectCOntext = coreData.persistentContainer.viewContext
        
        // BATCH UPDATE - prvo napravi batch sa nazivom entiteta, tj tabele
        let batchUpdateRequest = NSBatchUpdateRequest(entityName: "Movie")
        // zatim podesi atribut, tj property koji ce da se menja, kao i novu vrednosat koju ce da ima (dakle userRatimng ce imati 5 zvezdica)
        batchUpdateRequest.propertiesToUpdate = ["userRating": 5]
        batchUpdateRequest.resultType = .updatedObjectIDsResultType
        
        do {
            let bacthUpdateResult = try managedObjectCOntext.execute(batchUpdateRequest) as? NSBatchUpdateResult
            print("Batch update on: \(bacthUpdateResult!.result!)")
            
            if let result = bacthUpdateResult {
                let objectIds = result.result as! [NSManagedObjectID]
                for objectId in objectIds {
                    let managedObject = managedObjectCOntext.object(with: objectId)
                    // isFault je pointer na fajl, ali nije sam fajl u pitanju, i koristi manje memorije nego sam MO jer je on ipak pointer
                    if !managedObject.isFault {
                        managedObjectCOntext.stalenessInterval = 0  // ovo cemo podesiti na nulu, za sad po automatizmu
                        managedObjectCOntext.refresh(managedObject, mergeChanges: true)
                    }
                }
            }
        } catch {
            fatalError("Error performing batch update")
        }
    }
    
    // MARK: Private function
    
    private func loadData() {
        fetchedResultController = MovieService.getMovies(managedObjectContext: coreData.persistentContainer.viewContext)
        fetchedResultController.delegate = self
    }

  
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // ovaj managed object context je razlicit u odnosu na moc koji je doneo podatke, tako da ovaj moc ovde ne moze da brise podatke drugog moc-a
        // to mora da uradi isti moc koji ih je i doneo, zato cemo promeniti moc koji salje podatke da bi se slagao sa ovim moc-om ovde
        let managedObjectContext = coreData.persistentContainer.viewContext
        
        if editingStyle == .delete {
            
            movieToDelete = fetchedResultController.object(at: indexPath)
            
            let confirmDeleteAlertController = UIAlertController(title: "RemoveMovie", message: "Are you sure you would like to delete \"\(String(describing: movieToDelete!.title))\" from your movie library?", preferredStyle: .actionSheet)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .default) { [weak self] (action) in
                managedObjectContext.delete((self?.movieToDelete)!)
                self?.coreData.saveContext()
                self?.movieToDelete = nil
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] (action) in
                self?.movieToDelete = nil
            }
            
            confirmDeleteAlertController.addAction(deleteAction)
            confirmDeleteAlertController.addAction(cancelAction)
            
            self.present(confirmDeleteAlertController, animated: true, completion: nil)
            
            // ovo mi ne treba jer nije klasicni table view
//            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = fetchedResultController.sections {
            let currentSection = sections[section]
            return currentSection.name
        }
        return ""
    }

}


extension MovieTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            print("delete type detected")
            if let deleteIndexPath = indexPath {
                tableView.deleteRows(at: [deleteIndexPath], with: .fade)
            }
        case .insert:
            print("insert type detected")
        case .move:
            print("move type detected")
        case .update:
            print("update type detected")
            // ovo je zbog batch update-a dodato
            tableView.reloadRows(at: [indexPath!], with: .fade)
        default:
            print("nothing detected")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
