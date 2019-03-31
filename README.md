# CoreData

## 01 Setovanje  Persistent Container -  automatski ili manuelno

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

## 02 Podesavanja entiteta, atributa i veza

SADRZAJ:
     Entity relationships (slike), JSON (AppDelegate.uploadSampleData() - 96)
     Visestruko uklanjanje podataka (AppDelegate.deleteRecords() - 187)
     Records Searching (Home+CoreDataClass.getHomesByStatus - 23)
     Fetch One To Many (SaleHistory+CoreDataClass.getSoldHistory - 16)
     Sort Descriptor & Compound Predicate (FilterTableViewController - didSelectRowAt (57), setSortDescriptor(78),    setFilterSearchPredicate(82) | HomeListViewController - loadData(81-94), -prepare(119-120), extension HomeListViewController)
     Agregatne f-je: sum, count, min, max (Home+CoreDataClass.getTotalHomeSales - 50, Home+CoreDataClass.getNumberCondoSold - 71, Home+CoreDataClass.getNumberSingleFamilyHomeSold - 89, Home+CoreDataClass.getHomePriceSold - 107, Home+CoreDataClass.getAverageHomePrice - 129)
     Async request (Home+CoreDataClass.getHomesByStatus(19, 23) | HomeListViewController.loadDara(101))

atribut koji treba da bude slika
![image attribute](https://github.com/Vukovi/Core-Data-Projects/blob/master/02%20Veze%2C%20parsiranje%2C%20async%20request%2C%20agregatne%20fje%2C%20sort%20descriptor%20i%20nspredicate%20-%20Home%20Report/atribut%20slike.png)

roditeljski entitet
![parent entity](https://github.com/Vukovi/Core-Data-Projects/blob/master/02%20Veze%2C%20parsiranje%2C%20async%20request%2C%20agregatne%20fje%2C%20sort%20descriptor%20i%20nspredicate%20-%20Home%20Report/Roditeljski%20Entitet.png)

veze entiteta
![relationships between entities](https://github.com/Vukovi/Core-Data-Projects/blob/master/02%20Veze%2C%20parsiranje%2C%20async%20request%2C%20agregatne%20fje%2C%20sort%20descriptor%20i%20nspredicate%20-%20Home%20Report/veze%20entiteta.png)

veze 1-N
![relationship 1-N](https://github.com/Vukovi/Core-Data-Projects/blob/master/02%20Veze%2C%20parsiranje%2C%20async%20request%2C%20agregatne%20fje%2C%20sort%20descriptor%20i%20nspredicate%20-%20Home%20Report/Veza%201-N.png)

veze graficki predstavljene
![relationships graph](https://github.com/Vukovi/Core-Data-Projects/blob/master/02%20Veze%2C%20parsiranje%2C%20async%20request%2C%20agregatne%20fje%2C%20sort%20descriptor%20i%20nspredicate%20-%20Home%20Report/Veze%20Graficki.png)

podesavanje izvora entiteta
![Codegen setting](https://github.com/Vukovi/Core-Data-Projects/blob/master/02%20Veze%2C%20parsiranje%2C%20async%20request%2C%20agregatne%20fje%2C%20sort%20descriptor%20i%20nspredicate%20-%20Home%20Report/Automatic%20MO%20Subcall%20%26%20Class%20Generation%20.png)

## 03 NS Fetch Results Controller

SADRZAJ:
    TableView with Fetch Result Controller - MovieTableViewController.numberOfSections(26), numberOfRowsInSection(33),      cellForRowAt(45), loadData(82) + extension
     Delete Record - MovieTableViewController.editingStyle(88), extension(144,145)
     Batch Update - MovieTableViewController.updateRatingAction(51), extension(154)
     Results Grouping and Cashing - MovieService.swift
