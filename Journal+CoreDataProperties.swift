//
//  Journal+CoreDataProperties.swift
//  CoreDataJournal
//
//  Created by Cesar Fernandez on 6/26/24.
//
//

import Foundation
import CoreData


extension Journal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Journal> {
        return NSFetchRequest<Journal>(entityName: "Journal")
    }

    @NSManaged public var title: String?
    @NSManaged public var id: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var colorHex: String?
    @NSManaged public var entries: NSSet?

}

// MARK: Generated accessors for entries
extension Journal {

    @objc(addEntriesObject:)
    @NSManaged public func addToEntries(_ value: Entry)

    @objc(removeEntriesObject:)
    @NSManaged public func removeFromEntries(_ value: Entry)

    @objc(addEntries:)
    @NSManaged public func addToEntries(_ values: NSSet)

    @objc(removeEntries:)
    @NSManaged public func removeFromEntries(_ values: NSSet)

}

extension Journal : Identifiable {
//    var entriesArray: [Entry] {
//        guard let all = entries?.allObjects as? [Entry] else { return [] }
//        return Array(all)
//    }
}
