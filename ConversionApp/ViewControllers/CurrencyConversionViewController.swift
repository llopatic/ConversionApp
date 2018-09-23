//
//  CurrencyConversionViewController.swift
//  ConversionApp
//
//  Created by Leonard Lopatic on 20/09/2018.
//  Copyright © 2018 Leonard Lopatic. All rights reserved.
//

import UIKit

class CurrencyConversionViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var fromPickerView: UIPickerView!
    
    @IBOutlet weak var toPickerView: UIPickerView!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var rateDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForNotifications()
        loadRates()

        // Do any additional setup after loading the view.
    }

    func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(CurrencyConversionViewController.ratesUpdated), name: NSNotification.Name(rawValue: ratesModelUpdated), object: nil)
    }
    
    func loadRates() {
        
        if Model.sharedInstance.loadRatesFromDatabase() == false {
            Service.sharedInstance.loadRates(controller: self)
        } else {
            rateDateLabel.text = Model.sharedInstance.getRateDateFromDatabase(format: "MM/dd/yyyy")
            resultLabel.text = "Rates've just loaded from database!"
            
        }
        
    }
    
    @objc func ratesUpdated() {
        
        rateDateLabel.text = Model.sharedInstance.getRateDateFromDatabase(format: "MM/dd/yyyy")
        fromPickerView.reloadAllComponents()
        toPickerView.reloadAllComponents()
       
//        let fromCurrency = Model.sharedInstance.currencies[fromPickerView.selectedRow(inComponent: 0)]
//        let toCurrency = Model.sharedInstance.currencies[toPickerView.selectedRow(inComponent: 0)]
//
//        resultLabel.text = Model.sharedInstance.calculateRates(fromCurrency: fromCurrency, toCurrency: toCurrency)
        
        resultLabel.text = "Rates've just synchronized with the server!"
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Model.sharedInstance.currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Model.sharedInstance.currencies[row].currencyCode
        
        }
    
    @IBAction func submitButtonClicked(_ sender: UIButton) {
        
        if Model.sharedInstance.rateDateIsNotCurrentDate() {
            
            Service.sharedInstance.loadRates(controller: self)
            
        } else {
            
            let fromCurrency = Model.sharedInstance.currencies[fromPickerView.selectedRow(inComponent: 0)]
            let toCurrency = Model.sharedInstance.currencies[toPickerView.selectedRow(inComponent: 0)]
            
            resultLabel.text = Model.sharedInstance.calculateRates(fromCurrency: fromCurrency, toCurrency: toCurrency)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
