//
//  JournalsView.swift
//  CoreDataJournal
//
//  Created by Cesar Fernandez on 6/24/24.
//

import Foundation
import SwiftData
import SwiftUI


struct JournalsView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var isShowingJournalView = false
    
    @Query(sort: \Journal.createdAt, order: .reverse) var journals: [Journal]
    
    
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
            AddEditJournalView()
        }
    }
    private func addJournal() {
        isShowingJournalView = true
    }
    
    private func deleteJournals(offsets: IndexSet) {
        withAnimation {
            offsets.map { journals[$0] }.forEach{ modelContext.delete($0) }
//            JournalController.shared.saveContext()
        }
    }
    
}

extension Journal {
    var entriesArray: [Entry] {
        entries ?? []
    }
}

