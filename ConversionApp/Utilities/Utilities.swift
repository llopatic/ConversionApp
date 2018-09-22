//
//  Utilities.swift
//  ConversionApp
//
//  Created by Leonard Lopatic on 22/09/2018.
//  Copyright © 2018 Leonard Lopatic. All rights reserved.
//

import Foundation

func getStringFrom(date: Date, usingFormat format: String) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    let formattedDate = dateFormatter.string(from: date)
    return formattedDate
    
}

func getDateFromString(strDate: String, format: String) -> Date? {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    let date = dateFormatter.date(from: strDate)
    return date
    
}

