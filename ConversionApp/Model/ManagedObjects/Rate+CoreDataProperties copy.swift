//
//  Rate+CoreDataProperties.swift
//  
//
//  Created by Leonard Lopatic on 20/09/2018.
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
    @NSManaged public var sellingRate: Double
    @NSManaged public var unitValue: Int64
    @NSManaged public var relCurrency: Currency?
    @NSManaged public var relRateDate: RateDate?

}
