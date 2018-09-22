//
//  Model.swift
//  ConversionApp
//
//  Created by Leonard Lopatic on 20/09/2018.
//  Copyright © 2018 Leonard Lopatic. All rights reserved.
//

import Foundation

class Model {
    
    static let sharedInstance = Model()
    fileprivate init() {
        registerForServiceNotifications()
    }

    var rates = Array<Rate>()
    var currencies = Array<Currency>()
    var rateDate: RateDate?
    
    func registerForServiceNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(Model.ratesReceived(_:)), name: NSNotification.Name(rawValue: ratesReceivedNotification), object: nil)
    }
    
    @objc func ratesReceived(_ notification: Notification) {
        
        var receivedRates = (notification as NSNotification).userInfo!["rates"] as! [[String: Any]]
        
        appendRatesForKunaInReceived(rates: &receivedRates)
       
        CoreDataManager.sharedInstance.deleteObjectsFromContext(self.rates)
        CoreDataManager.sharedInstance.deleteObjectsFromContext(self.currencies)
       
        if let date = self.rateDate {
            CoreDataManager.sharedInstance.deleteObjectsFromContext([date])
        }
        
        self.rates = [Rate]()
        self.currencies = [Currency]()
        self.rateDate = nil

        for rate in receivedRates {
            
            let currencyCode = rate["currency_code"]! as! String
            let unitValue = rate["unit_value"]! as! Int
            let sellingRate = Double(rate["selling_rate"] as! String)!
            let medianRate = Double(rate["median_rate"]! as! String)!
            let buyingRate = Double(rate["buying_rate"]! as! String)!
            
            let insertedRate = CoreDataManager.sharedInstance.addRate(currencyCode: currencyCode, unitValue: unitValue, sellingRate: sellingRate, medianRate: medianRate, buyingRate: buyingRate)
            self.rates.append(insertedRate)
            
            let insertedCurrency = CoreDataManager.sharedInstance.addCurrency(currencyCode: currencyCode)
            self.currencies.append(insertedCurrency)
        }
        
        let insertedRateDate = CoreDataManager.sharedInstance.addRateDate(date: Date())
        self.rateDate = insertedRateDate
            

        CoreDataManager.sharedInstance.saveContext()
        
        let queue = DispatchQueue.main
        queue.async {
            let notification = Notification(name: Notification.Name(rawValue: ratesModelUpdated), object: nil)
            NotificationCenter.default.post(notification)
        }
        
    }
    
    func appendRatesForKunaInReceived(rates: inout Array<Dictionary<String,Any>>) {
        
        let HRKDict: [String: Any] = [
            "unit_value": 1,
            "median_rate": "1.0",
            "currency_code": "HRK",
            "selling_rate": "1.0",
            "buying_rate": "1.0"
        ]
        
        rates.insert(HRKDict, at: 0)
        
    }
    
    func loadRatesFromDatabase() -> Bool {
    
        if let rates = CoreDataManager.sharedInstance.getRates() {
            if rates.count == 0 {
                return false
            } else {
                if rateDateIsNotCurrentDate() {
                    
                    return false
                    
                } else {
                    Model.sharedInstance.rates = rates
                    currencies = CoreDataManager.sharedInstance.getCurrencies()!
                    rateDate = CoreDataManager.sharedInstance.getRateDate()!
                    return true
                }
            }
        } else {
            return false
        }

    }
    
    func rateDateIsNotCurrentDate() -> Bool {
        
        guard let rateDateInDatabaseAsNSDate = CoreDataManager.sharedInstance.getRateDate()?.rateDate
        else {return true}
        
        let rateDateInDatabase = rateDateInDatabaseAsNSDate as Date
        let todayDate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        let rateDateInDatabaseString = dateFormatter.string(from: rateDateInDatabase )
        
        let todayDateString = dateFormatter.string(from: todayDate )

        return rateDateInDatabaseString != todayDateString
        
    }
    
    func calculateRates(fromCurrency: Currency, toCurrency: Currency) -> String {
        //return fromCurrency.currencyCode! + " " + toCurrency.currencyCode!
        
        var fromBuyingRate: Double = 0.0
        var fromSellingRate: Double = 0.0
        var fromUnitValue: Double = 0.0
        var toBuyingRate: Double = 0.0
        var toSellingRate: Double = 0.0
        var toUnitValue: Double = 0.0
        
        for rate in Model.sharedInstance.rates {
            if rate.currencyCode == fromCurrency.currencyCode {
                fromBuyingRate = rate.buyingRate
                fromSellingRate = rate.sellingRate
                fromUnitValue = Double(rate.unitValue)
            }
        }
        
        for rate in Model.sharedInstance.rates {
            if rate.currencyCode == toCurrency.currencyCode {
                toBuyingRate = rate.buyingRate
                toSellingRate = rate.sellingRate
                toUnitValue = Double(rate.unitValue)
            }
        }
        
        let buyingRate = String(format: "%.8f", fromBuyingRate/fromUnitValue * toUnitValue/toBuyingRate)
        let sellingRate = String(format: "%.8f", fromSellingRate/fromUnitValue * toUnitValue/toSellingRate)

        
        return "Buying R: \(buyingRate)  Selling R: \(sellingRate)"
        
    }
}

