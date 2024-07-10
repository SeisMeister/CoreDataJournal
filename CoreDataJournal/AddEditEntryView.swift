//
//  AddEdditEntryView.swift
//  CoreDataJournal
//
//  Created by Cesar Fernandez on 6/19/24.
//

import SwiftUI

struct AddEditEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var context

    var journal: Journal
    var entry: Entry? // will be `nil` if the user tapped the "+" button. Will have a value if the user tapped on a journal entry from the list.
    
    @State private var title = ""
    @State private var bodyString = ""
    @State private var isShowingImagePicker = false
    @State private var selectedImage: UIImage?
    
    private var saveIsDisabled: Bool {
        title.isEmpty || bodyString.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                HStack {
                    TextField("Title", text: $title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    imageButton()
                        .fixedSize()
                }
                
                TextEditor(text: $bodyString)
                    .textEditorStyle(.plain)
                    .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                
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
            .navigationTitle((entry == nil ? "New Entry" : entry!.title)!)
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(image: $selectedImage)
            }
        }
        .onAppear {
            if let entry {
                if let entryTitle = entry.title {
                    self.title = entryTitle
                }
                if let entryBody = entry.body {
                    self.bodyString = entryBody
                }
                if let imageData = entry.imageData {
                    selectedImage = UIImage(data: imageData)
                }
            }
        }
    }
    
    func imageButton() -> some View {
        Button {
            presentImagePicker()
        } label: {
            if let selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
            }
        }
    }
    
    func presentImagePicker() {
        isShowingImagePicker = true
    }
    
    func save() {
        if let entry {
            JournalController.shared.updateEntry(
                entry: entry,
                title: title,
                body: bodyString,
                image: selectedImage,
                modelContext: context
            )
        } else {
            JournalController.shared.createNewEntry(
                in: journal,
                title: title,
                body: bodyString,
                image: selectedImage,
                modelContext: context
            )
        }
        dismiss()
    }
}

//#Preview {
//    AddEditEntryView(journal: Journal(), entry: nil)
//}






// MARK: - ImagePicker as per Paul Hudson

import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider else { return }

            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    self.parent.image = image as? UIImage
                }
            }
        }
    }
}

