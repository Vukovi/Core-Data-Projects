//
//  Home+CoreDataClass.swift
//  Home Report
//
//  Created by Andi Setiyadi on 8/31/16.
//  Copyright © 2016 devhubs. All rights reserved.
//

import Foundation
import CoreData


public class Home: NSManagedObject {
    
    var soldPredicate: NSPredicate = NSPredicate(format: "isForSale = false")
    let request: NSFetchRequest<Home> = Home.fetchRequest()
    
    // typealias za async request
    typealias HomeByStatusHandler = (_ home: [Home]) -> Void

    // BIZNIS LOGIKOM SIRIMO OVU KLASU
    // inace je ovo pretraga podataka
    func getHomesByStatus(request: NSFetchRequest<Home>, moc: NSManagedObjectContext, completionHandler: @escaping HomeByStatusHandler)  { // -> [Home]  ovo mi vise ne treba jer ce vracanje obavljati handler
        
        // promenio sam potpis metode umesto -- isForSale: Bool -- sada stoji request
        
//        let request: NSFetchRequest<Home> = Home.fetchRequest()
        // ovde se mora biti oprezan jer naziv atributa koji se ovde trazi, ne sme da bude omasen, tj pogresno napisan
//        request.predicate = NSPredicate(format: "isForSale = %@", isForSale)
        
        
        let asyncRequest = NSAsynchronousFetchRequest(fetchRequest: request) { (results: NSAsynchronousFetchResult<Home>) in
            let homes = results.finalResult!
            completionHandler(homes)
        }
        
        do {
            // ovo ukidam zbog async requesta
//            let homes = try moc.fetch(request)
//            return homes
            
            try moc.execute(asyncRequest)
            
        } catch { fatalError("Error in getting list of homes") }
        
    }
    
    
    // Agregatne funkcije
    func getTotalHomeSales(moc: NSManagedObjectContext) -> String {
        request.predicate = soldPredicate
        request.resultType = .dictionaryResultType
        
        // sada uptreba agregatne f-je
        let sumExpressionDescription = NSExpressionDescription()
        sumExpressionDescription.name = "totalSales" // posto je podeseno da resultType bude dictionary, ovo u stvari predstavlja key tog dictionary-ja
        sumExpressionDescription.expression = NSExpression(forFunction: "sum:", arguments: [NSExpression(forKeyPath: "price")]) // ovo diktira koju vrstu agregatne fu-je hocu, a hocu da mi vraca po atributu price iz entiteta
        sumExpressionDescription.expressionResultType = .doubleAttributeType
        
        request.propertiesToFetch = [sumExpressionDescription]
        
        do {
            let results = try moc.fetch(request as! NSFetchRequest<NSFetchRequestResult>) as! [NSDictionary]
            let dictionary = results.first!
            let totalSales = dictionary["totalSales"] as! Double
            return totalSales.currencyFormatter
        } catch { fatalError("Error getting total home sales") }
    }
    
    
    func getNumberCondoSold(moc: NSManagedObjectContext) -> String {
        let typePredicate = NSPredicate(format: "homeType = 'Condo'")
        let predicate = NSCompoundPredicate(type: .and, subpredicates: [soldPredicate,typePredicate])
        
        request.resultType = .countResultType
        request.predicate = predicate
        
        var count: NSNumber!
        
        do {
            let results = try moc.fetch(request as! NSFetchRequest<NSFetchRequestResult>) as! [NSNumber]
            count = results.count as NSNumber
        } catch {fatalError("Error counting condo sold")}
        
        return count.stringValue
    }
    
    
    func getNumberSingleFamilyHomeSold(moc: NSManagedObjectContext) -> String {
        let typePredicate = NSPredicate(format: "homeType = 'Single Family'")
        let predicate = NSCompoundPredicate(type: .and, subpredicates: [soldPredicate,typePredicate])
        
        request.predicate = predicate
        
        // u odnosu na prebrojavanje u funkciji iznad, ovde ce biti koriscena drugacija tehnika
        do {
            let count = try moc.count(for: request)
            if count != NSNotFound {
                return String(count)
            } else {
                fatalError("Error counting single family sold")
            }
        } catch { fatalError("Error counting single family sold") }
    }
    
    // ovo je za minimum i maximum
    func getHomePriceSold(priceType: String, moc: NSManagedObjectContext) -> String {
        request.predicate = soldPredicate
        request.resultType = .dictionaryResultType
        
        let sumExpressionDescription = NSExpressionDescription()
        sumExpressionDescription.name = priceType // key recnika
        sumExpressionDescription.expression = NSExpression(forFunction: "\(priceType):", arguments: [NSExpression(forKeyPath: "price")])
        sumExpressionDescription.expressionResultType = .doubleAttributeType
        
        request.propertiesToFetch = [sumExpressionDescription]
        
        do {
            let results = try moc.fetch(request as! NSFetchRequest<NSFetchRequestResult>) as! [NSDictionary]
            let dictiomnary = results.first!
            let homePrice = dictiomnary[priceType] as! Double
            
            return homePrice.currencyFormatter
            
        } catch { fatalError("Error gettin \(priceType) home sales") }
    }
    
    // za prosecnu vredmost
    func getAverageHomePrice(homeType: String, moc: NSManagedObjectContext) -> String {
        let typePredicate = NSPredicate(format: "homeType = %@", homeType)
        let predicate = NSCompoundPredicate(type: .and, subpredicates: [soldPredicate,typePredicate])
        
        request.predicate = predicate
        request.resultType = .dictionaryResultType
        
        let sumExpressionDescription = NSExpressionDescription()
        sumExpressionDescription.name = homeType // key recnika
        sumExpressionDescription.expression = NSExpression(forFunction: "average:", arguments: [NSExpression(forKeyPath: "price")])
        sumExpressionDescription.expressionResultType = .doubleAttributeType
        
        request.propertiesToFetch = [sumExpressionDescription]
        
        do {
            let results = try moc.fetch(request as! NSFetchRequest<NSFetchRequestResult>) as! [NSDictionary]
            let dictiomnary = results.first!
            let homePrice = dictiomnary[homeType] as! Double
            
            return homePrice.currencyFormatter
            
        } catch { fatalError("Error gettin \(homeType) home sales") }
        
    }
    
}
