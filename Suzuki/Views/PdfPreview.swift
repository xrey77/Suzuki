//
//  PdfPreview.swift
//  Suzuki
//
//  Created by Reynald Marquez-Gragasin on 7/12/25.
//

import SwiftUI
import CoreData
import PDFKit

struct PdfPreview: View {
    @Binding var showPdf1: Bool
    @Binding var url: URL!
    
    @State var pdf1: String = ""
    @State var pdf2: String = ""
    @State var pdf3: String = ""

    var body: some View {
        NavigationView {
         if showPdf1 == true {
            ZStack {
                VStack {
                    VStack {
                        PDFKitRepresentedView(url)
                    }
                }
                .toolbar {
                    HStack(spacing: 300) {
                    VStack {
                            Image("back")
                                .resizable()
                                .foregroundColor(Color.black)
                                .frame(width: 70, height: 25)
                                .onTapGesture {
                                    self.showPdf1 = false
                                }
                            }
                            .padding(.leading, 10)

                        VStack {
                         Image(systemName: "printer.fill")
                            .resizable()
                            .foregroundColor(Color.black)
                            .frame(width: 25, height: 25)
                         }
                    .onTapGesture {
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
                        }
                    }
                    
                    
                }
                .navigationBarHidden(false)
            } //ZStack
            .offset(x: 0, y: -20)

         }
        } //NavigationView

    }
}


//struct PdfPreview_Previews: PreviewProvider {
//    static var previews: some View {
//        PdfPreview()
//    }
//}
