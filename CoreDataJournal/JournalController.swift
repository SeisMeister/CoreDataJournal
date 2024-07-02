//
//  JournalController.swift
//  CoreDataJournal
//
//  Created by Cesar Fernandez on 6/19/24.
//

import Foundation
import SwiftUI
import CoreData

struct JournalController {
    
    static var shared = JournalController()
    
    private var viewContext: NSManagedObjectContext {
        PersistenceController.shared.container.viewContext
    }
    
    func createNewEntry(in journal: Journal, title: String, body: String, image: UIImage?) {
        let entry = Entry(context: viewContext)
        entry.id = UUID().uuidString
        entry.title = title
        entry.body = body
        entry.createdAt = Date()
        entry.imageData = image?.pngData()
        entry.journal = journal
        
        do {
            try viewContext.save()
        } catch {
            print("Error saving Entry to view context: \(error)")
        }
    }
    
    func createNewJournal(title: String, color: Color) {
        let journal = Journal(context: viewContext)
        journal.id = UUID().uuidString
        journal.title = title
        journal.createdAt = Date()
        journal.colorHex = color.toHexString()
        saveContext()
    }
    
    func updateEntry(entry: Entry, title: String, body: String, image: UIImage?) {
        entry.title = title
        entry.body = body
        
        if let image = image {
            entry.imageData = image.pngData()
        }
        do {
            try viewContext.save()
        } catch {
            print("Error updating Entry in view context: \(error)")
        }
    }
    
    func updateJournal(journal: Journal, title: String) {
        journal.title = title
        do {
            try viewContext.save()
        } catch {
            print("Error saving Journal: \(error)")
        }
    }
    
    func saveContext() {
        try? viewContext.save()
    }
}
