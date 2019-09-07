//
//  CurrencyConversionViewController.swift
//  ConversionApp
//
//  Created by Leonard Lopatic on 20/09/2018.
//  Copyright © 2018 Leonard Lopatic. All rights reserved.
//

import UIKit

class CurrencyConversionViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    var chosenRateDate: Date = getDateFromString(strDate: "2000-01-01", format: rateDateFormat)!
    
    @IBOutlet weak var fromPickerView: UIPickerView!
    
    @IBOutlet weak var toPickerView: UIPickerView!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var rateDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rateDateLabel.text = getStringFrom(date: chosenRateDate, usingFormat: rateDateFormat)
        registerForNotifications()
        loadRates()
    }

    
    func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(CurrencyConversionViewController.ratesUpdated), name: NSNotification.Name(rawValue: ratesModelUpdatedNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CurrencyConversionViewController.ratesNotAvailable), name: NSNotification.Name(rawValue: ratesNotAvailableNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CurrencyConversionViewController.connectionIssues), name: NSNotification.Name(rawValue: connectionIssuesNotification), object: nil)
    }
    
    
    func loadRates() {
        Model.sharedInstance.loadRatesFromDatabase(rateDate: chosenRateDate)
        if Model.sharedInstance.rates.count == 0 {
            showActivityIndicator(uiView: self.view)
            Service.sharedInstance.loadRates(rateDate: chosenRateDate)
        }  else {
            print("Rates've just loaded from database!")
            fromPickerView.reloadAllComponents()
            toPickerView.reloadAllComponents()
            initializePickerViews()
            convert()
        }
        
    }
    
    
    @objc func ratesNotAvailable() {
        let alert = UIAlertController(
            title: "Rates not available!",
            message: nil,
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {
            action in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        alert.preferredAction = okAction
        self.present(alert, animated: true)
        hideActivityIndicator(uiView: self.view)
    }
    
    
    @objc func connectionIssues() {
        let alert = UIAlertController(
            title: "Connection issues!",
            message: "Error occured when trying to get rates from the server!",
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {
            action in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        alert.preferredAction = okAction
        self.present(alert, animated: true)
        hideActivityIndicator(uiView: self.view)
    }
    

    
    @objc func ratesUpdated() {
        hideActivityIndicator(uiView: self.view)
        fromPickerView.reloadAllComponents()
        toPickerView.reloadAllComponents()
        initializePickerViews()
        convert()
        print("Rates've just synchronized with the server!")
    }
    

    func initializePickerViews () {
        
        var fromRow = 0
        for (index, rate) in Model.sharedInstance.rates.enumerated() {
            if rate.currencyCode == INITIAL_FROM_CURRENCY {
                fromRow = index
                break
            }
        }
        
        var toRow = 0
        for (index, rate) in Model.sharedInstance.rates.enumerated() {
            if rate.currencyCode == INITIAL_TO_CURRENCY {
                toRow = index
                break
            }
        }
                
        fromPickerView.selectRow(fromRow, inComponent: 0, animated: false)
        toPickerView.selectRow(toRow, inComponent: 0, animated: false)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Model.sharedInstance.rates.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Model.sharedInstance.rates[row].currencyCode
        }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //The next line solves problem of displaying wrong row in Picker View
        pickerView.selectRow(row, inComponent: 0, animated: true)
        //resultLabel.text = "Buying R:    Selling R:"
//        if pickerView == fromPickerView {
//            print("fromPickerView selected row = \(row)")
//        } else if pickerView == toPickerView {
//            print("toPickerView selected row = \(row)")
//        }
        convert()

    }

    
    func convert() {
        let fromCurrency = Model.sharedInstance.rates[fromPickerView.selectedRow(inComponent: 0)].currencyCode
        let toCurrency = Model.sharedInstance.rates[toPickerView.selectedRow(inComponent: 0)].currencyCode
        resultLabel.text = Model.sharedInstance.calculateRates(fromCurrency: fromCurrency!, toCurrency: toCurrency!)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
