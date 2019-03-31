//
//  GroceryTableViewController.swift
//  Grocery List
//
//  Created by Andi Setiyadi on 8/30/16.
//  Copyright © 2016 devhubs. All rights reserved.
//

import UIKit
import CoreData

class GroceryTableViewController: UITableViewController {
    
//    var groceries = [String]()  // ovo je bez CoreData
//    var groceries = [NSManagedObject]() // ovo je pre kreiranja subklase NSManagedObject-a klikom na bazu pa na Editor/CreateNSMangaedObjects
    var groceries = [Grocery]()
    
    // potreban mi MOC koji cu da napravim kao poseban objekat
    var managedObjectContext: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // posto mi se Persistance Container nalazi u AppDelegatu treba mi njegov objekat
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // moj context se inicijalizuje preko appDelegata jer se u appDelegatu nalazi Persistance Container
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        loadData()
    }

    func loadData() {
        // napravi zahtev ka tabeli koja ti treba
//        let request: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Grocery") // ovo je pre kreiranja xc modela
        let request: NSFetchRequest<Grocery> = Grocery.fetchRequest()
        
        do {
            // ako trazeni zahtev ima rezultata
            let results = try managedObjectContext?.fetch(request)
            // predaj ih odgovarajucem Managed Objectu
            groceries = results!
            tableView.reloadData()
        }
        catch {
            fatalError("Error in retrieving Grocery item")
        }
        
        tableView.reloadData()
    }

    @IBAction func addAction(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Grocery Item", message: "What's to buy now?", preferredStyle: UIAlertController.Style.alert)
        
        alertController.addTextField { (textField: UITextField) in
            
        }
        
        let addAction = UIAlertAction(title: "ADD", style: UIAlertAction.Style.default) { [weak self] (action: UIAlertAction) in
            
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
            
            guard let itemString: String = alertController.textFields?.first?.text, itemString != "" else { return }
            // unos u tabelu
            // prvo mi treba odgovarajuca tabela
            let grocery = Grocery(context: (self?.managedObjectContext)!)
            // zatim atributu iz te tabele direktno dodaljujem vrednost
            grocery.item = itemString
            
            // zatim sve to hocu da sacuvam
            do {
                try self?.managedObjectContext?.save()
            }
            catch {
                fatalError("Error is storing to data")
            }
            // i na kraju da osvezim moj niz objekata iz tabele koji treba da prikazem na UI
            self?.loadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.groceries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groceryCell", for: indexPath)

        let grocery = self.groceries[indexPath.row]
//        ovo je bez kreiranog cd modela
//        // ovde uzimam vrednost za odgovarajuc naziv atributa iz tabele
//        cell.textLabel?.text = grocery.value(forKey: "item") as? String
        
        cell.textLabel?.text = grocery.item

        return cell
    }
}
