//
//  GroceryTableViewController.swift
//  Grocery List
//
//

import UIKit
import CoreData

class GroceryTableViewController: UITableViewController {
    
//    var groceries = [String]()  // ovo je bez CoreData
//    var groceries = [NSManagedObject]() // ovo je pre kreiranja subklase NSManagedObject-a klikom na bazu pa na Editor/CreateNSMangaedObjects
    var groceries = [Grocery]()
    var sortAscending = true
    var groceryFRC: NSFetchedResultsController<Grocery>!
    var groceryService: GroceryService?
    var item: String?
    
    // potreban mi MOC koji cu da napravim kao poseban objekat
    var managedObjectContext: NSManagedObjectContext? {
        didSet {
            groceryService = GroceryService.init(managedObjectContext: self.managedObjectContext!)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Posto sam uveo GroceryService, MOC vise necu dohvatati preko AppDelegate-a
        
//        // posto mi se Persistance Container nalazi u AppDelegatu treba mi njegov objekat
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        // moj context se inicijalizuje preko appDelegata jer se u appDelegatu nalazi Persistance Container
//        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        loadData()
    }

    func loadData() {
        
        // Posle uvodjenja GroceryService-a menjam ono sto treba da odradi loadData
        
//        // napravi zahtev ka tabeli koja ti treba
////        let request: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Grocery") // ovo je pre kreiranja xc modela
//        let request: NSFetchRequest<Grocery> = Grocery.fetchRequest()
//
//        do {
//            // ako trazeni zahtev ima rezultata
//            let results = try managedObjectContext?.fetch(request)
//            // predaj ih odgovarajucem Managed Objectu
//            groceries = results!
//            tableView.reloadData()
//        }
//        catch {
//            fatalError("Error in retrieving Grocery item")
//        }
//
//        tableView.reloadData()
        
        groceryFRC = groceryService?.getAllGroceries(withAscendingOrder: sortAscending)
        groceryFRC.delegate = self
    }

    @IBAction func addAction(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Grocery Item", message: "What's to buy now?", preferredStyle: UIAlertController.Style.alert)
        
        alertController.addTextField { (textField: UITextField) in
            textField.placeholder = "Item"
        }
        
        alertController.addTextField { (textField: UITextField) in
            textField.placeholder = "Store"
        }
        
        let addAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default) { [weak self] (action: UIAlertAction) in
            
//            Zakomentarisano jer je ovo varijanta bez kreiranog cd modela
            /*
            let textField = alertController.textFields?.first
            // bez CoreData
//            self?.groceries.append(textField!.text!)
//            self?.tableView.reloadData()
            
            // unos u tabelu
            // prvo mi treba odgovarajuca tabela
            let entity = NSEntityDescription.entity(forEntityName: "Grocery", in: (self?.managedObjectContext)!)
            // zatim mi treba atribut iz te tabele
            let grocery = NSManagedObject(entity: entity!, insertInto: self?.managedObjectContext)
            // onda dodeljujem vrednost u tom atributu za key koji odgovara nazivu tog atributa u tabeli
            grocery.setValue(textField!.text!, forKey: "item")
            */
            
            guard let itemString: String = alertController.textFields?[0].text, itemString != "", let store = alertController.textFields?[1].text, store != "" else { return }
            
            // Opet ovo ide u komentar jer sam uveo GroceryService
            
//            // unos u tabelu
//            // prvo mi treba odgovarajuca tabela
//            let grocery = Grocery(context: (self?.managedObjectContext)!)
//            // zatim atributu iz te tabele direktno dodaljujem vrednost
//            grocery.item = itemString
//
//            // zatim sve to hocu da sacuvam
//            do {
//                try self?.managedObjectContext?.save()
//            }
//            catch {
//                fatalError("Error is storing to data")
//            }
//            // i na kraju da osvezim moj niz objekata iz tabele koji treba da prikazem na UI
//            self?.loadData()
            
            self?.groceryService?.add(groceryItem: itemString, forStore: store)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func sortAction(_ sender: UIBarButtonItem) {
        sortAscending = !sortAscending
        
        loadData()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.groceries.count
        if let sections = groceryFRC.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groceryCell", for: indexPath)

        // Opet ovo ide u komentar jer sam uveo GroceryService
        
//        let grocery = self.groceries[indexPath.row]
////        ovo je bez kreiranog cd modela
////        // ovde uzimam vrednost za odgovarajuc naziv atributa iz tabele
////        cell.textLabel?.text = grocery.value(forKey: "item") as? String
        
        let grocery = groceryFRC.object(at: indexPath)
        
        cell.textLabel?.text = grocery.item

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let itemToDelete = self.groceryFRC.object(at: indexPath)
            self.groceryService?.delete(groceryItem: itemToDelete)
            
        default:
            break
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Grocery Item", message: "", preferredStyle: UIAlertController.Style.alert)
        
        let itemToUpdate = self.groceryFRC.object(at: indexPath)
        
        alertController.addTextField { (textField: UITextField) in
            textField.text = itemToUpdate.item
        }
        
        alertController.addTextField { (textField: UITextField) in
            textField.text = itemToUpdate.store?.name
        }
        
        let updateAction = UIAlertAction(title: "UPDATE", style: UIAlertAction.Style.default) { [weak self] (action: UIAlertAction) in
            
            guard let item = alertController.textFields?.first?.text, !item.isEmpty else {
                // delete item
                return
            }
            
            let store = alertController.textFields?[1].text
            
            self?.groceryService?.update(currentGroceryItem: itemToUpdate, withNewItem: item, forStore: store!)
            self?.tableView.reloadData()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil)
        
        alertController.addAction(updateAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - FetchedResultsController delegate

extension GroceryTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .delete:
            if let deleteIndexPath = indexPath {
                tableView.deleteRows(at: [deleteIndexPath], with: UITableView.RowAnimation.fade)
            }
            
        case .insert:
            if let newItemIndexPath = newIndexPath {
                tableView.insertRows(at: [newItemIndexPath], with: UITableView.RowAnimation.fade)
            }
            
        default:
            break
        }
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
