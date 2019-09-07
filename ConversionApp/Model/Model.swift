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
  
    func registerForServiceNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(Model.ratesReceived(_:)), name: NSNotification.Name(rawValue: ratesReceivedNotification), object: nil)
    }
    
    @objc func ratesReceived(_ notification: Notification) {
        let receivedRateDate = (notification as NSNotification).userInfo!["rateDate"] as! Date
        var receivedRates = (notification as NSNotification).userInfo!["rates"] as! [[String: Any]]
        appendRatesForKunaInReceived(rates: &receivedRates)
        for (index, rate) in receivedRates.enumerated() {
            let currencyCode = rate["currency_code"]! as! String
            let unitValue = rate["unit_value"]! as! Int
            let sellingRate = Double(rate["selling_rate"] as! String)!
            let medianRate = Double(rate["median_rate"]! as! String)!
            let buyingRate = Double(rate["buying_rate"]! as! String)!
            let insertedRate = CoreDataManager.sharedInstance.addRate(rateDate: receivedRateDate, seqNo: index, currencyCode: currencyCode, unitValue: unitValue, sellingRate: sellingRate, medianRate: medianRate, buyingRate: buyingRate)
            self.rates.append(insertedRate)
        }
        
        CoreDataManager.sharedInstance.saveContext()
        
        //print(rateDates)
        
        let queue = DispatchQueue.main
        queue.async {
            let notification = Notification(name: Notification.Name(rawValue: ratesModelUpdatedNotification), object: nil)
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
    
    func loadRatesFromDatabase(rateDate: Date) {
        if let rates = CoreDataManager.sharedInstance.getRates(rateDate: rateDate) {
            Model.sharedInstance.rates = rates
        } else {
            Model.sharedInstance.rates = [Rate]()
        }
    }
    
    
    func calculateRates(fromCurrency: String, toCurrency: String) -> String {
        //return fromCurrency.currencyCode! + " " + toCurrency.currencyCode!
        
        var fromBuyingRate: Double = 0.0
        var fromSellingRate: Double = 0.0
        var fromUnitValue: Double = 0.0
        var toBuyingRate: Double = 0.0
        var toSellingRate: Double = 0.0
        var toUnitValue: Double = 0.0
        
        for rate in Model.sharedInstance.rates {
            if rate.currencyCode == fromCurrency {
                fromBuyingRate = rate.buyingRate
                fromSellingRate = rate.sellingRate
                fromUnitValue = Double(rate.unitValue)
                break
            }
        }
        
        for rate in Model.sharedInstance.rates {
            if rate.currencyCode == toCurrency {
                toBuyingRate = rate.buyingRate
                toSellingRate = rate.sellingRate
                toUnitValue = Double(rate.unitValue)
                break
            }
        }
        
        let buyingRate = String(format: "%.8f", fromBuyingRate/fromUnitValue * toUnitValue/toBuyingRate)
        let sellingRate = String(format: "%.8f", fromSellingRate/fromUnitValue * toUnitValue/toSellingRate)

        
        return "Buying R: \(buyingRate)  Selling R: \(sellingRate)"
        
    }
    
}

