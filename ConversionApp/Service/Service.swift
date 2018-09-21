//
//  Service.swift
//  ConversionApp
//
//  Created by Leonard Lopatic on 20/09/2018.
//  Copyright © 2018 Leonard Lopatic. All rights reserved.
//

import Foundation
import UIKit
//import Alamofire
//import SwiftyJSON


class Service {
    
    static let sharedInstance = Service()
    fileprivate init() {}
    
    func loadRates(controller: UIViewController) {
        
        let strUrl = "\(HNB_URL)"
        let url = URL(string: strUrl)
        let request = URLRequest(url: url!)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error == nil {
                
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                
                let rates = self.parseResponseString(responseString!)
                
                //print(rates)
                
                let notification = Notification(name: Notification.Name(ratesReceivedNotification), object: nil, userInfo: ["rates": rates])
                NotificationCenter.default.post(notification)
            } else {
                print("Error \(String(describing: error.debugDescription))")
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
        
        task.resume()
    }
    
    func parseResponseString(_ responseString: NSString) -> [[String: Any]] {
        
        let jsonData = responseString.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: true)
        let objectsArray = (try! JSONSerialization.jsonObject(with: jsonData!, options: .allowFragments)) as! [[String: Any]]
        
        return objectsArray
    }
}
