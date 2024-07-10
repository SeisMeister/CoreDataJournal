//
//  JournalController.swift
//  CoreDataJournal
//
//  Created by Cesar Fernandez on 6/19/24.
//

import Foundation
import SwiftUI
import SwiftData

struct JournalController {
    
    static var shared = JournalController()
        
    func createNewEntry(in journal: Journal, title: String, body: String, image: UIImage?, modelContext: ModelContext) {
        let entry = Entry(journal: journal, title: title, body: body, imageData: image?.jpegData(compressionQuality: 1.0))
        modelContext.insert(entry)
    }
    
    func createNewJournal(title: String, color: Color, modelContext: ModelContext) {
        let journal = Journal(title: title, colorHex: color.toHexString() ?? "")
        journal.id = UUID().uuidString
        journal.title = title
        journal.createdAt = Date()
//        journal.colorHex = colorHex // colorHex not found in scope
        journal.colorHex = journal.colorHex
        modelContext.insert(journal)
        try? modelContext.save()
    }
    
    func updateEntry(entry: Entry, title: String, body: String, image: UIImage?, modelContext: ModelContext) {
        entry.title = title
        entry.body = body
        
        if let image = image {
            entry.imageData = image.pngData()
        }
        do {
            try modelContext.save()
        } catch {
            print("Error updating Entry in view context: \(error)")
        }
    }
    
    func updateJournal(journal: Journal, title: String, modelContext: ModelContext) {
        journal.title = title
        do {
            try modelContext.save()
        } catch {
            print("Error saving Journal: \(error)")
        }
    }
    
//    func saveContext() {
//        try? modelContext.save()
//    }
}
