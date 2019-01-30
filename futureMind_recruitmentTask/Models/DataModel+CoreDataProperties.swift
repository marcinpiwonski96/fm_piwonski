//
//  DataModel+CoreDataProperties.swift
//  futureMind_recruitmentTask
//
//  Created by Marcin Piwoński on 30/01/2019.
//  Copyright © 2019 Marcin Piwoński. All rights reserved.
//
//

import Foundation
import CoreData


extension DataModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DataModel> {
        return NSFetchRequest<DataModel>(entityName: "DataModel")
    }

    @NSManaged public var fullDescription: String
    @NSManaged public var title: String
    @NSManaged public var modificationDate: String
    @NSManaged public var orderId: Int32
    @NSManaged public var imageUrlString: String

}
