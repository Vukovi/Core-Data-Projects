//
//  MovieService.swift
//  Movie
//
//  Created by Andi Setiyadi on 9/2/16.
//  Copyright © 2016 devhubs. All rights reserved.
//

import Foundation
import CoreData

class MovieService {
    
    internal static func getMovies(managedObjectContext: NSManagedObjectContext) -> NSFetchedResultsController<Movie> {
        // ovo mi ne treba zbog toga sto necu moci da koristim ovaj moc ni za sta drugo (za brisanje, dodavnaje, azuriranje), jedino cu moci ovde da ga koristim za ovo sto sam planirao da radim u ovoj metodi
//        let managedObjectContext = CoreDataStack().persistentContainer.viewContext
        let fetchedResultController: NSFetchedResultsController<Movie>
        
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        // neka obavi sortiranje po atributu TITLE po rastucem redosledu
        let sort = NSSortDescriptor(key: "title", ascending: true)
        
        // ovo se tice grupisanja
        let formatSort = NSSortDescriptor(key: "format", ascending: false)
        
        
        request.sortDescriptors = [sort , formatSort]
        
        // ukoliko ne zelim pretragu po section-ima ostavicu NIL, kao i ako ne zelim pretragu po kesiranom nazivu ostavicu i kod njega NIL
        // kada popunim sectionNameKeyPath to ce napraviti podelu podataka tj njihovo razvrstavanje po sekcijama, a razvrstace ih po atributu format, tj da li su u pitanju DVD-jevi ili BlueRay-ovi
        // kada popunim cacheName, nekim proizvoljnim imenom, to ce napraviti jedan cache pretrage, takoda ako podaci nisu menjani, nece obaviti celu pretragu vec ce koristiti kesiranu, a to moze biti vidljivo kod velikih podataka koji bi usporili app prilikom svake prave pretrage
        fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: "formt", cacheName: "MyMoviewCollection")
        
        do {
            try fetchedResultController.performFetch()
        }
        catch {
            fatalError("Error in fetching records")
        }
        
        return fetchedResultController
    }
}
