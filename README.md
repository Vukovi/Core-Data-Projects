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
     
## 04 Poredjenje agregatnih funkcija pretrage

Kada postoje velike slike, to ce za njihovo ucitavnje i prikazivanje trositi i mnogo memorije telefona i mnogo vremena.
To ce se poporaviti tako sto ce se enitiet koji sadrzi atribut koji je zaduzen za slike malo promeniti, za pocetak preimenovati u npr thumbnails.
Napravicemo novi entitet koji ce imati samo jedan atribut i to ce biti ta velika slika koja je prethodno bila u "glavnom" entitetu.
Napravicemo inverzne veze izmedju novog i polaznog entiteta.
Izmenjeni atribut polaznog entiteta ce dobiti takodje podatak o slici, ali ce ta slika biti umanjena slika originalne slike. 
Zatim, i dalje ce se sve slike ucitavati odjednom i zato cemo se pozabaviti Incremental-nim fetching-om - CarService.getCarInventory() batchSize
Ovim je podeseno koliko podataka ce se preuzeti iz baze
     
Poredjenje upotrebe agregatnih f-ja pretrage u bazi je uradjeno u CarService.swift i Unit Testing fajlu

pokretanje Instruments-a radi otkrivanja koliko memorije i vremena trosi ucitavanje iz CoreData-e : KORAK 1
![instruments start](https://github.com/Vukovi/Core-Data-Projects/blob/master/04%20Poredjenje%20agregatnih%20fja%20-%20Car%20Inventory/Pokretanje%20Instruments.png)

pokretanje Instruments-a radi otkrivanja koliko memorije i vremena trosi ucitavanje iz CoreData-e : KORAK 2
![instruments start](https://github.com/Vukovi/Core-Data-Projects/blob/master/04%20Poredjenje%20agregatnih%20fja%20-%20Car%20Inventory/Pokretanje%20Instruments%20radi%20CoreData-e.png)

pokretanje Instruments-a radi otkrivanja koliko memorije i vremena trosi ucitavanje iz CoreData-e : KORAK 3
![instruments start](https://github.com/Vukovi/Core-Data-Projects/blob/master/04%20Poredjenje%20agregatnih%20fja%20-%20Car%20Inventory/Instruments%20analiza.png)


## 05 Migracije i izmene baza u CoreData-i

Leightweight migracija - automatska migracija - slike LW
Heavyweight migracija - maualna migracija - slike HW + svi komentari u kodu

automatska Lightweight migracija kada Codegen nije podesen na Manual : KORAK 1
![instruments start](https://github.com/Vukovi/Core-Data-Projects/blob/master/05%20Migracija%20baza%20-%20Ski%20School/Lightweight%20migration%20-%20promena%20baze%201.png)

automatska Lightweight migracija kada Codegen nije podesen na Manual : KORAK 2
![instruments start](https://github.com/Vukovi/Core-Data-Projects/blob/master/05%20Migracija%20baza%20-%20Ski%20School/Lightweight%20migration%20-%20promena%20baze%202.png)

automatska Lightweight migracija kada Codegen nije podesen na Manual : KORAK 3
![instruments start](https://github.com/Vukovi/Core-Data-Projects/blob/master/05%20Migracija%20baza%20-%20Ski%20School/Lightweight%20migration%20-%20promena%20baze%203.png)

automatska Lightweight migracija kada Codegen nije podesen na Manual : KORAK 4
![instruments start](https://github.com/Vukovi/Core-Data-Projects/blob/master/05%20Migracija%20baza%20-%20Ski%20School/Lightweight%20migration%20-%20promena%20baze%204.png)

manualna (uobicajena) Heavyweight migracija : KORAK 1
![instruments start](https://github.com/Vukovi/Core-Data-Projects/blob/master/05%20Migracija%20baza%20-%20Ski%20School/Manual%20migration%201.png)

manualna (uobicajena) Heavyweight migracija : KORAK 2
![instruments start](https://github.com/Vukovi/Core-Data-Projects/blob/master/05%20Migracija%20baza%20-%20Ski%20School/Manual%20migration%202.png)

manualna (uobicajena) Heavyweight migracija : KORAK 3
![instruments start](https://github.com/Vukovi/Core-Data-Projects/blob/master/05%20Migracija%20baza%20-%20Ski%20School/Manual%20migration%203.png)

manualna (uobicajena) Heavyweight migracija : KORAK 4
![instruments start](https://github.com/Vukovi/Core-Data-Projects/blob/master/05%20Migracija%20baza%20-%20Ski%20School/Manual%20migration%204.png)

manualna (uobicajena) Heavyweight migracija : KORAK 5
![instruments start](https://github.com/Vukovi/Core-Data-Projects/blob/master/05%20Migracija%20baza%20-%20Ski%20School/Manual%20migration%205.png)

manualna (uobicajena) Heavyweight migracija : KORAK 6
![instruments start](https://github.com/Vukovi/Core-Data-Projects/blob/master/05%20Migracija%20baza%20-%20Ski%20School/Manual%20migration%206.png)

manualna (uobicajena) Heavyweight migracija : KORAK 7
![instruments start](https://github.com/Vukovi/Core-Data-Projects/blob/master/05%20Migracija%20baza%20-%20Ski%20School/Manual%20migration%207.png)

manualna (uobicajena) Heavyweight migracija : KORAK 8
![instruments start](https://github.com/Vukovi/Core-Data-Projects/blob/master/05%20Migracija%20baza%20-%20Ski%20School/Manual%20migration%208.png)

manualna (uobicajena) Heavyweight migracija : KORAK 9
![instruments start](https://github.com/Vukovi/Core-Data-Projects/blob/master/05%20Migracija%20baza%20-%20Ski%20School/Manual%20migration%209.png)

manualna (uobicajena) Heavyweight migracija : KORAK 10
![instruments start](https://github.com/Vukovi/Core-Data-Projects/blob/master/05%20Migracija%20baza%20-%20Ski%20School/Manual%20migration%2010.png)

manualna (uobicajena) Heavyweight migracija : KORAK 11
![instruments start](https://github.com/Vukovi/Core-Data-Projects/blob/master/05%20Migracija%20baza%20-%20Ski%20School/Manual%20migration%2011.png)
