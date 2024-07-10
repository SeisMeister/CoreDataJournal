//
//  Journal.swift
//  CoreDataJournal
//
//  Created by Cesar Fernandez on 7/2/24.
//
//

import Foundation
import SwiftData


@Model
class Journal {
    var colorHex: String?
    var createdAt: Date?
    var id: String?
    var title: String?
    @Relationship(deleteRule: .cascade) var entries: [Entry]?
    
    public init(title: String, colorHex: String?) {
        self.title = title
        self.colorHex = colorHex
        self.createdAt = createdAt
        self.id = UUID().uuidString
        self.entries = []
    }
    
}
