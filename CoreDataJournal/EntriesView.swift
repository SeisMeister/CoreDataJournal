//
//  ContentView.swift
//  CoreDataJournal
//
//  Created by Cesar Fernandez on 6/18/24.
//

import SwiftUI
import CoreData

var relativeDateFormatter: RelativeDateTimeFormatter = {
    let formatter = RelativeDateTimeFormatter()
    formatter.dateTimeStyle = .numeric
    return formatter
}()

struct EntriesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    

    private var entries: [Entry] {  journal.entriesArray }
    
    @ObservedObject var journal: Journal
    
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
            offsets.map { entries[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
    
}
#Preview {
    EntriesView(journal: Journal()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
