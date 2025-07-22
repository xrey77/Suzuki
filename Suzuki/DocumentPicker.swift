//
//  DocumentPicker.swift
//  Suzuki
//
//  Created by Reynald Marquez-Gragasin on 7/20/25.
//

import Foundation
import SwiftUI
import MobileCoreServices
import UniformTypeIdentifiers

struct DocumentPicker : UIViewControllerRepresentable {
    private var allowMultipleSelections = false
    var documentTypes: [String]
    var onPicked: ([URL]) -> Void
    var onCancel: () -> Void
    
    public init(allowMultipleSelections: Bool = false, documentTypes: [String], onPicked: @escaping ([URL]) -> Void, onCancel: @escaping () -> Void) {
        self.documentTypes = documentTypes
        self.onPicked = onPicked
        self.onCancel = onCancel
        self.allowMultipleSelections = allowMultipleSelections
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(onPicked: onPicked, onCancel: onCancel)
    }

    public func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<DocumentPicker>) {
        
    }

    public func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let supportedTypes = [UTType.pdf, UTType.jpeg, UTType.png]
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes)
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = self.allowMultipleSelections
        return picker
    }

    public class Coordinator: NSObject, UIDocumentPickerDelegate {
        
        private var onPicked: ([URL]) -> Void
        private var onCancel: () -> Void
        
        init(onPicked: @escaping ([URL]) -> Void, onCancel: @escaping () -> Void) {
            self.onPicked = onPicked
            self.onCancel = onCancel
        }
        
//        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//            guard let url = urls.first, url.startAccessingSecurityScopedResource() else { return }
//            defer {
//                DispatchQueue.main.async {
//                    url.stopAccessingSecurityScopedResource()
//                }
//            }
//
//            do {
//                parent.s3Document = try Data(contentsOf: url)
//            } catch {
//                print("no data")
//            }
//        }

        
        public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first, url.startAccessingSecurityScopedResource() else { return }
            defer {
                DispatchQueue.main.async {
                    url.stopAccessingSecurityScopedResource()
                }
            }

            
            self.onPicked(urls)
        }

        public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            self.onCancel()
        }

    }
}
    
//    var callback: (URL) -> ()
//
//        func makeCoordinator() -> Coordinator {
//            return Coordinator(documentController: self)
//        }
//
//        func updateUIViewController(
//            _ uiViewController: UIDocumentPickerViewController,
//            context: UIViewControllerRepresentableContext<DocumentPicker>) {
//        }
//
//        func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
//            let supportedTypes = [UTType.pdf, UTType.jpeg, UTType.png]
//            let controller = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes)
//
//            controller.delegate = context.coordinator
//            return controller
//        }
//
//        class Coordinator: NSObject, UIDocumentPickerDelegate {
//            var documentController: DocumentPicker
//
//            init(documentController: DocumentPicker) {
//                self.documentController = documentController
//            }
//
//            func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//                guard let url = urls.first, url.startAccessingSecurityScopedResource() else { return }
//                defer { url.stopAccessingSecurityScopedResource() }
//                documentController.callback(urls[0])
//            }
//        }
//    }
