//
//  PdfprintViewer.swift
//  Suzuki
//
//  Created by Reynald Marquez-Gragasin on 7/11/25.
//

import Foundation
import SwiftUI
import PDFKit

struct PDFKitRepresentedView: UIViewRepresentable {
    let url: URL
    let pdfView = PDFView()

    init(_ url: URL) {
        self.url = url
        pdfView.document = PDFDocument(url: self.url)
    }

    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFKitRepresentedView.UIViewType {
        return pdfView
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {
        // Update the PDF view if needed
    }
}

struct PDFKitView: View {
    var url: URL

    var body: some View {
        PDFKitRepresentedView(url)
    }
}

public enum PrintingResult {
  case success
  case failure(Error)
  case userCancelled
}

public func presentPrintInteractionController(url: URL?, jobName: String? = nil, completion: ((PrintingResult) -> Void)? = nil) {
  let printController = UIPrintInteractionController()
  let printInfo = UIPrintInfo.printInfo()
  if let jobName = jobName {
    printInfo.jobName = jobName
  }
  printController.printInfo = printInfo

  if let url = url {
    printController.printingItem = url
  }
  printController.present(animated: true) { _, completed, error in
    guard let completion = completion else { return }
    if completed {
        completion(.success)
    } else {
        if let error = error {
            completion(.failure(error))
        } else {
            completion(.userCancelled)
        }
    }
  }
}


