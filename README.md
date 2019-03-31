### CoreData

Persistent Container se lazy inicijalizuje u AppDelegate
```
lazy var persistanceContainer: NSPersistanceContainer = {
  let container = NSPersistanceContainer(name: “NAZIV BAZE”) container.loadPersistentStrores(completionHandler: { (stroreDescription, error) in
    if let error = error as NSError? { 
      fatalError(“Unresolved error \(error)”)
    } 
  })
return container 
}
```
kao i funkcija saveContext()
```
func saveContext() {
  let context = persistanceContainer.viewContext 
  if context.hasChanges {
    do {
      try context.save()
    } catch {
      let nsError = error as NSError
    } 
  }
}
```
Ovo se automatski dobija ako se stiklira CoreData na pocetku projekta, 
ali ako je potrebno naknadno dodati CoreData u projekat onda ubaci ovo u AppDelegate sam. 
I ukoliko nije vec ubaceno potrebno je self.saveContext() ubaciti u applicationWillTerminate()
