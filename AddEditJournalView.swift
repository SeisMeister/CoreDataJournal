//
//  AddEditJournalView.swift
//  CoreDataJournal
//
//  Created by Cesar Fernandez on 6/24/24.
//

import SwiftUI

struct AddEditJournalView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var selectedColor: Color = .white
    
    var journal: Journal
    
    private var saveIsDisabled: Bool {
        title.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Title", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Spacer()
                
                ColorPicker("Set Journal Color", selection: $selectedColor, supportsOpacity: false)
                
                Spacer()
                
                Button(action: save) {
                    Text("Save")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .foregroundStyle(Color.white)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(Color.blue)
                )
                .contentShape(Rectangle())
                .opacity(saveIsDisabled ? 0.5 : 1)
                .disabled(saveIsDisabled)
            }
            .padding()
            .navigationTitle("New Journal")
        }
    }
    
    func save() {
            JournalController.shared.createNewJournal(
                title: title,
                color: selectedColor
            )
            dismiss()
    }
}
