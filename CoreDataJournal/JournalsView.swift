//
//  JournalsView.swift
//  CoreDataJournal
//
//  Created by Cesar Fernandez on 6/24/24.
//

import Foundation
import CoreData
import SwiftUI


struct JournalsView: View {
    @Environment(\.`managedObjectContext`) private var viewContext
    @State private var isShowingJournalView = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Journal.createdAt, ascending: true)],
        animation: .default)
    private var journals: FetchedResults<Journal>
    private var entries: FetchedResults<Entry>?
    
    
    var body: some View{
        NavigationStack {
            List {
                ForEach(journals) { journal in
                    NavigationLink(destination: EntriesView(journal: journal)) {
                        HStack {
                            if let hex = journal.colorHex, let color = Color(hex: hex) {
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundColor(color)
                                    .frame(width: 40, height: 40)
                            VStack(alignment: .leading) {
                                if let title = journal.title {
                                    Text(title)
                                        .font(.headline)
                                    Text("\(journal.entriesArray.count) entries")
                                        .font(.subheadline)
                                        .foregroundStyle(Color(.secondaryLabel))
                                }
                                }
                            }
                        }
                    }
                }
                .onDelete(perform: deleteJournals(offsets:))
            }
            .toolbar {
                ToolbarItem {
                    Button(action: addJournal) {
                        Label("New Journal", systemImage: "text.badge.plus")
                    }
                }
            }
            .navigationTitle("Journals")
        }
        .sheet(isPresented: $isShowingJournalView) {
            AddEditJournalView(journal: Journal())
        }
    }
    private func addJournal() {
        isShowingJournalView = true
    }
    
    private func deleteJournals(offsets: IndexSet) {
        withAnimation {
            offsets.map { journals[$0]}.forEach(viewContext.delete)
            JournalController.shared.saveContext()
        }
    }
    
}

extension Journal {
    var entriesArray: [Entry] {
        guard let all = entries?.allObjects as? [Entry] else { return [] }
        return Array(all)
    }
}

