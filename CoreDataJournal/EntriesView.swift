//
//  ContentView.swift
//  CoreDataJournal
//
//  Created by Cesar Fernandez on 6/18/24.
//

import SwiftUI
import SwiftData

var relativeDateFormatter: RelativeDateTimeFormatter = {
    let formatter = RelativeDateTimeFormatter()
    formatter.dateTimeStyle = .numeric
    return formatter
}()


struct EntriesView: View {
    @Environment(\.modelContext) var context

    private var entries: [Entry] {  journal.entriesArray }

    @State var journal: Journal
    
    @State private var isShowingAddEditView = false
    @State private var selectedEntry: Entry?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(entries) { entry in
                    Button(
                        action: {
                            selectedEntry = entry
                        },
                        label: {
                            VStack {
                                if let title = entry.title {
                                    Text(title)
                                }
                                
                                if let relativeString = relativeDateFormatter.string(for: entry.createdAt) {
                                    Text(relativeString)
                                        .font(.subheadline)
                                        .foregroundStyle(Color(.secondaryLabel))
                                }
                            }
                        }
                    )
                }
                .onDelete(perform: deleteItems)
                .navigationTitle("\(journal.title ?? "Journal")")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
        .sheet(isPresented: $isShowingAddEditView, content: {
            AddEditEntryView(journal: journal, entry: nil)
        })
        // Update an Entry section in the readMe file
        .sheet(item: $selectedEntry) { entry in
            AddEditEntryView(journal: journal, entry: entry)
        }
    }
    
    private func addItem() {
        isShowingAddEditView = true
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { entries[$0] }.forEach{ context.delete($0) }
        }
    }
    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
    
}
//#Preview {
//    EntriesView(journal: Journal()).environment(\.managedObjectContext, preview.container.modelContext)
//}

