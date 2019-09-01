//
//  Service.swift
//  ConversionApp
//
//  Created by Leonard Lopatic on 20/09/2018.
//  Copyright © 2018 Leonard Lopatic. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class Service {
    
    static let sharedInstance = Service()
    fileprivate init() {}
    
    func loadRates(controller: UIViewController) {
    
        print ("Web service is called!")
        
        let rateDate = Model.sharedInstance.currentDate()
        //let rateDate = getDateFromString(strDate: "1990-01-01", format: rateDateFormat)!
        let strRateDate = getStringFrom(date: rateDate, usingFormat: rateDateFormat)

        let url = "\(HNB_URL)"
        let parameters = ["date": strRateDate]
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            
            if response.result.isSuccess {
                print ("HTTP Get Request - Success!")
//                print(response.result.value)
//                let rate = response.result.value as! Array<Dictionary<String,Any>>
//                print (rate[0]["selling_rate"])
                if var rates = response.result.value as? [[String: Any]] {
                    rates.append(["rate_date":strRateDate])
                    let notification = Notification(name: Notification.Name(ratesReceivedNotification), object: nil, userInfo: ["rates": rates])
                    NotificationCenter.default.post(notification)
                } else {
                    print ("HTTP Get Request - Error: Rates not available")
                    let alert = UIAlertController(
                        title: "Today Rates not available!",
                        message: nil,
                        preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil )
                    alert.addAction(okAction)
                    alert.preferredAction = okAction
                    controller.present(alert, animated: true)                }
            } else {
                print ("HTTP Get Request - Error: \(response.result.error!)")
                let alert = UIAlertController(
                    title: "Connection issues!",
                    message: "Error occured when trying to get today's rates from the server! Rates in the app are not current!",
                    preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil )
                alert.addAction(okAction)
                alert.preferredAction = okAction
                controller.present(alert, animated: true)
                
            }
        }
        
        
//        let strUrl = "\(HNB_URL)?date=\(strRateDate)"
//        let url = URL(string: strUrl)
//        let request = URLRequest(url: url!)
        
//        let session = URLSession.shared
//
//        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
//
//            var statusCode = 200
//
//            if let httpResponse = response as? HTTPURLResponse {
//                statusCode = httpResponse.statusCode
//            }
//
//            if error == nil && statusCode == 200 {
//
//                var rates = (try! JSONSerialization.jsonObject(with: data!, options: .allowFragments)) as! [[String: Any]]
//
//                rates.append(["rate_date":strRateDate])
//
//                //print(rates)
//
//                let notification = Notification(name: Notification.Name(ratesReceivedNotification), object: nil, userInfo: ["rates": rates])
//                NotificationCenter.default.post(notification)
//
//            } else {
//
//                print("Error: HTTP Status Code = \(statusCode)")
//                let alert = UIAlertController(
//                    title: "Connection issues!",
//                    message: "Error occured when trying to get today's rates from the server! Rates in the app are not current!",
//                    preferredStyle: .alert)
//                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil )
//                    alert.addAction(okAction)
//                    alert.preferredAction = okAction
//                    controller.present(alert, animated: true)
//
//            }
//
//        }
//
//        task.resume()

        
        
    }

}
