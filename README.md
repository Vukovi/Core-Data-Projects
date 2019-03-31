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

# Podesavanja entiteta, atributa i veza

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


