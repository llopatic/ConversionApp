//
//  RateDate+CoreDataProperties.swift
//  
//
//  Created by Leonard Lopatic on 20/09/2018.
//
//

import Foundation
import CoreData


extension RateDate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RateDate> {
        return NSFetchRequest<RateDate>(entityName: "RateDate")
    }

    @NSManaged public var rateDate: NSDate?
    @NSManaged public var relRates: NSSet?

}

// MARK: Generated accessors for relRates
extension RateDate {

    @objc(addRelRatesObject:)
    @NSManaged public func addToRelRates(_ value: Rate)

    @objc(removeRelRatesObject:)
    @NSManaged public func removeFromRelRates(_ value: Rate)

    @objc(addRelRates:)
    @NSManaged public func addToRelRates(_ values: NSSet)

    @objc(removeRelRates:)
    @NSManaged public func removeFromRelRates(_ values: NSSet)

}
