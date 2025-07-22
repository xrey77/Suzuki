//
//  PdfPreview.swift
//  Suzuki
//
//  Created by Reynald Marquez-Gragasin on 7/12/25.
//

import SwiftUI
import CoreData
import PDFKit

struct PreviewPdf: View {
    @Binding var showPdf2: Bool
    @Binding var url: URL!
    
    var body: some View {
        if showPdf2 == true {
         NavigationView {
            ZStack {
                VStack {
                    VStack {
                        PDFKitRepresentedView(url)
                    }
                }
                .toolbar {
                    HStack(spacing: 300) {
                        ///BACK BUTTON
                        Button {
                            showPdf2 = false
                        } label: {
                            Image("back")
                                .resizable()
                                .foregroundColor(Color.black)
                                .frame(width: 70, height: 25)
                                .padding(.leading, 10)
                        }

                        ///PRINT TO PRINTER
                        Button {
                            presentPrintInteractionController(url: url, jobName: "Print a pdf report") { result in
                                            switch result {
                                            case .success:
                                                print("Print Successful")
                                            case .failure(let error):
                                                print("Error: \(error)")
                                            case .userCancelled:
                                                print("Printing job cancelled.")
                                            }
                               }
                    
                        } label: {
                            Image(systemName: "printer.fill")
                               .resizable()
                               .foregroundColor(Color.black)
                               .frame(width: 25, height: 25)
                        }
                    } ///End-HStack
                }
                .navigationBarHidden(false)
            } //End-ZStack
            .offset(x: 0, y: -20)

         } //End-NavigationView
        } //End-if

    }
}


