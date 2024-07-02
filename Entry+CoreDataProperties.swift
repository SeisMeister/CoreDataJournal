//
//  Entry+CoreDataProperties.swift
//  CoreDataJournal
//
//  Created by Cesar Fernandez on 6/26/24.
//
//

import Foundation
import CoreData


extension Entry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }

    @NSManaged public var body: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var id: String?
    @NSManaged public var imageData: Data?
    @NSManaged public var title: String?
    @NSManaged public var journal: Journal?

}

extension Entry : Identifiable {

}
