//
//  CoreDataJournalApp.swift
//  CoreDataJournal
//
//  Created by Cesar Fernandez on 6/18/24.
//

import SwiftUI

@main
struct CoreDataJournalApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
