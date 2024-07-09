//
//  Entry.swift
//  CoreDataJournal
//
//  Created by Cesar Fernandez on 7/2/24.
//
//

import Foundation
import SwiftData


@Model public class Entry {
    var body: String?
    var createdAt: Date?
    var id: String?
    var imageData: Data?
    var title: String?
    var journal: Journal?
    public init() {

    }
    
}
