//
//  PdfViewPicker.swift
//  Suzuki
//
//  Created by Reynald Marquez-Gragasin on 7/14/25.
//

import Combine
import SwiftUI
import PDFKit

struct PdfViewPicker: View {
    @Binding var showImagePicker: Bool
    @State var image: Image?
    @State var inputImage: UIImage?
    @State var close = true
    @State var url: URL!
    @State var showPdf1 = true
    
    func createPDFDataFromImage(image: UIImage) {
        let pdfData = NSMutableData()
        
        let imgView = UIImageView.init(image: image)
        let imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        UIGraphicsBeginPDFContextToData(pdfData, imageRect, nil)
        UIGraphicsBeginPDFPage()
        let context = UIGraphicsGetCurrentContext()
        imgView.layer.render(in: context!)
        UIGraphicsEndPDFContext()

        //try saving in doc dir to confirm:
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        let path = dir?.appendingPathComponent("file.pdf")
        do {
                try pdfData.write(to: path!, options: NSData.WritingOptions.atomic)
        } catch {
            print("error catched")
        }
        url = path!.absoluteURL

    }

    
    private func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
        createPDFDataFromImage(image: inputImage)
    }
    
    var body: some View {
        NavigationView {
            if showImagePicker {
            ZStack {
                VStack {
                    if image != nil {
                        PdfPreview(showPdf1: $showPdf1, url: $url)

//                        image?
//                            .resizable()
//                            .scaledToFill()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .fullScreenCover(isPresented: $close, onDismiss: loadImage) {
                    ImagePicker(image: self.$inputImage)
                }
                .offset(x: 0, y: -20)

            } ///End-VStack
            .toolbar(content: {
                 HStack(spacing: 280) {
                    Image("back").resizable().frame(width: 70, height: 25)
                        .onTapGesture {
                            showImagePicker = false
                        }
                    Image(systemName: "printer.fill").resizable()
                        .foregroundColor(Color.black)
                        .frame(width: 25, height: 25)
                        .onTapGesture {
                        }
                }
            })

            } ///End-ZStack
        } ///End-if
     } ///End-NavigationView
    
}


//struct PdfViewPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        PdfViewPicker()
//    }
//}

