//
//  CoreDataManger.swift
//  ConversionApp
//
//  Created by Leonard Lopatic on 20/09/2018.
//  Copyright © 2018 Leonard Lopatic. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let sharedInstance = CoreDataManager()
    fileprivate init() {}
    
    func getRates() -> Array<Rate>? {
        
        let context = self.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Rate>(entityName: "Rate")
        do {
            let ratesArray = try context.fetch(fetchRequest)
            return ratesArray
        } catch let error as NSError{
            print ("Error getting rates from database: \(error.userInfo)")
            return nil
        }
    }
    
    func getCurrencies() -> Array<Currency>? {
        
        let context = self.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Currency>(entityName: "Currency")
        do {
            let currencyArray = try context.fetch(fetchRequest)
            return currencyArray
        } catch let error as NSError{
            print ("Error getting currencies from database: \(error.userInfo)")
            return nil
        }
    }
    
    func getRateDate() -> RateDate? {
        
        let context = self.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<RateDate>(entityName: "RateDate")
        do {
            let rateDates = try context.fetch(fetchRequest)
            if rateDates.count > 0 {
                return rateDates[0]
            } else {
                return nil
            }
        } catch let error as NSError{
            print ("Error getting rate date from database: \(error.userInfo)")
            return nil
        }
    }
    
    func deleteObjectsFromContext(_ objects: Array<NSManagedObject>) {
        for obj in objects {
            self.persistentContainer.viewContext.delete(obj)
        }
    }
    
    func addRate(currencyCode: String, unitValue: Int, sellingRate: Double, medianRate: Double, buyingRate: Double) -> Rate {
        
        let entityDescription = NSEntityDescription.entity(forEntityName: "Rate", in: self.persistentContainer.viewContext)!
        
        let rate = NSManagedObject(entity: entityDescription, insertInto: self.persistentContainer.viewContext) as! Rate
        
        rate.currencyCode = currencyCode
        rate.unitValue = Int64(unitValue)
        rate.sellingRate = sellingRate
        rate.medianRate = medianRate
        rate.buyingRate = buyingRate
        
        return rate
    }
    
    func addCurrency(currencyCode: String) -> Currency {
        
        let entityDescription = NSEntityDescription.entity(forEntityName: "Currency", in: self.persistentContainer.viewContext)!
        
        let currency = NSManagedObject(entity: entityDescription, insertInto: self.persistentContainer.viewContext) as! Currency
        
        currency.currencyCode = currencyCode
        
        return currency
    }
    
    func addRateDate(date: Date) -> RateDate {
        
        let entityDescription = NSEntityDescription.entity(forEntityName: "RateDate", in: self.persistentContainer.viewContext)!
        
        let rateDate = NSManagedObject(entity: entityDescription, insertInto: self.persistentContainer.viewContext) as! RateDate
        
        rateDate.rateDate = date as NSDate
        
        return rateDate
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "ConversionApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
