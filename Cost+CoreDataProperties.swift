//
//  Cost+CoreDataProperties.swift
//  ToControlBudet
//
//  Created by Арсен Хачатрян on 18.12.2023.
//
//

import Foundation
import CoreData


extension Cost {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cost> {
        return NSFetchRequest<Cost>(entityName: "Cost")
    }

    @NSManaged public var describe: String?
    @NSManaged public var value: Double
    @NSManaged public var sign: String?

}

extension Cost : Identifiable {

}
