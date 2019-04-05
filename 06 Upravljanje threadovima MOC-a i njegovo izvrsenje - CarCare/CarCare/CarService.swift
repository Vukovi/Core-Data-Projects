//
//  CarService.swift
//  CarCare
//
//

import Foundation
import CoreData

class CarService {
    
    internal var managedObjectContext: NSManagedObjectContext!
    
    internal init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    deinit {
        self.managedObjectContext = nil
    }
    
    func loadVehicleData() {
        // da aplikacija ne bi imala problema, pa cak i pucala, zbog koriscenja jednog konteksta i za cuvanje i za dovlacenje podataka
        // napravicemo privatni kontekst
        
        // novi nacin:
        let privateContext = CoreDataStack().persistentContainer.newBackgroundContext()
        
        // stari nacin:
        // koriscenjem onog istog MOC-a, tj jednog jedinog sa njegovim blokom PERFORM
        
        // i zamenicu prethodni kontekst
        
        let url = URL(string: "https://api.edmunds.com/api/vehicle/v2/makes?fmt=json$api_key=wyu4qhu7wm97kvk86ph9bs3n")!
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            let httpResponse = response as! HTTPURLResponse
            if httpResponse.statusCode == 200 {
                
                // stari nacin
                // PERFORM ili PERDFORM_AND_WAIT, GA TERA NA DRUGI THREAD TAKO DA MOZE DA SE KORISTI ISTI MOC
                // PERFORM_AND_WAIT se ponasa kao dispacth_semaphore
                self.managedObjectContext.perform {
                    do {
                        let josnResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                        let jsonArray = josnResult.value(forKey: "makes") as! NSArray
                        for json in jsonArray {
                            let carData = json as! [String: AnyObject]
                            
                            guard let makeName = carData["name"] else { return }
                            
                            // stari nacin
                            let autoMaker = AutoMaker(context: self.managedObjectContext)
                            // novi nacin
                            //                        let autoMaker = AutoMaker(context: privateContext)
                            
                            autoMaker.make = makeName as? String
                            
                            // veza 1-N autoMaker-a prema autoModel-u
                            let autoModels = autoMaker.autoModel?.mutableCopy() as! NSMutableSet
                            
                            guard let arrModelNames = carData["models"] as? [NSArray] else { return }
                            for modelName in arrModelNames {
                                let jsonModel = modelName as! [String: AnyObject]
                                let modelName = jsonModel["name"] as? String
                                
                                // stari nacin
                                let autoModel = AutoModel(context: self.managedObjectContext)
                                // novi nacin
                                //                            let autoModel = AutoModel(context: privateContext)
                                
                                autoModel.model = modelName
                                
                                // veza 1-N autoModel-a prema autoYear-u
                                let autoYears = autoModel.autoYear?.mutableCopy() as! NSMutableSet
                                
                                guard let arrModelYears = jsonModel["years"] as? NSArray else { return }
                                for modelYear in arrModelYears {
                                    let jsonYear = modelYear as! [String: AnyObject]
                                    let year = jsonYear["year"] as? NSNumber
                                    
                                    // stari nacin
                                    let autoYear = AutoYear(context: self.managedObjectContext)
                                    // novi nacin
                                    //                                let autoYear = AutoYear(context: privateContext)
                                    
                                    autoYear.year = year!.int16Value
                                    
                                    autoYears.add(autoYear)
                                }
                                // Setovanje AutoYear-a u AutoModel u CoreData-i
                                autoModel.autoYear = autoYears.copy() as? NSSet
                                
                                autoModels.add(autoModel)
                            }
                            // Setovanje AutoModel-a u AutoMaker-a u CoreData-i
                            autoMaker.autoModel = autoModels.copy() as? NSSet
                        }
                        
                        // stari nacin
                        try self.managedObjectContext.save()
                        // novi nacin
                        //                    try privateContext.save()
                        
                    } catch let error as NSError { print("Error in parsing json data: \(error.localizedDescription)") }
                }
                // pre nego sto se blok PERFORM zavrsi poziva se showVehicle
                // tek posto se PERFORANDWAIT zavrsi poziva se showVehicle
                self.showVehicle()
            }
        }.resume()
    }
    
    // stari nacin threadovanja
    func showVehicle() {
        // provera upisa u bazu
        let request: NSFetchRequest<AutoMaker> = AutoMaker.fetchRequest()
        request.predicate = NSPredicate(format: "make = 'Subaru'")
        do{
            let result = try managedObjectContext.fetch(request)
            let autoMaker = result.first
            print("AutoMaker: \(String(describing: autoMaker?.make))")
        } catch { fatalError() }
    }
    
    
}

