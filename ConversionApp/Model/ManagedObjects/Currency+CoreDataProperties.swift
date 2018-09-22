//
//  Currency+CoreDataProperties.swift
//  
//
//  Created by Leonard Lopatic on 22/09/2018.
//
//

import Foundation
import CoreData


extension Currency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Currency> {
        return NSFetchRequest<Currency>(entityName: "Currency")
    }

    @NSManaged public var currencyCode: String?
    @NSManaged public var seqNo: Int64
    @NSManaged public var relRate: Rate?

}
