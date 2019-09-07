//
//  Rate+CoreDataProperties.swift
//  ConversionApp
//
//  Created by Leonard Lopatic on 03/09/2019.
//  Copyright © 2019 Leonard Lopatic. All rights reserved.
//
//

import Foundation
import CoreData


extension Rate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Rate> {
        return NSFetchRequest<Rate>(entityName: "Rate")
    }

    @NSManaged public var buyingRate: Double
    @NSManaged public var currencyCode: String?
    @NSManaged public var medianRate: Double
    @NSManaged public var rateDate: NSDate?
    @NSManaged public var sellingRate: Double
    @NSManaged public var seqNo: Int64
    @NSManaged public var unitValue: Int64

}
