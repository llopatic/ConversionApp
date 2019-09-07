//
//  RateDateViewController.swift
//  ConversionApp
//
//  Created by Leonard Lopatic on 03/09/2019.
//  Copyright © 2019 Leonard Lopatic. All rights reserved.
//

import UIKit

class RateDateViewController: UIViewController {

    @IBOutlet weak var rateDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func todayButtonClicked(_ sender: UIButton) {
        rateDatePicker.date = Date()
    }
    
    @IBAction func doneButtonClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "toCurrencyConversionSegue", sender: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! CurrencyConversionViewController
        
        // Solving a bug:
        rateDatePicker.setDate(rateDatePicker.date + 1, animated: false)
        rateDatePicker.setDate(rateDatePicker.date - 1, animated: false)
       
        destinationVC.chosenRateDate = Calendar.current.startOfDay(for: rateDatePicker.date)
        
    }
    

}
