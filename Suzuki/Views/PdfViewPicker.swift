//
//  PdfViewPicker.swift
//  Suzuki
//
//  Created by Reynald Marquez-Gragasin on 7/14/25.
//

import SwiftUI

struct PdfViewPicker: View {
    @Binding var showImagePicker: Bool
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var close: Bool = true
    
    private func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    var body: some View {
        if self.close {
        NavigationView {
            ZStack {
                VStack {
                    if image != nil {
                        image?
                            .resizable()
                            .scaledToFill()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .sheet(isPresented: $showImagePicker, onDismiss: loadImage ) {
                    ImagePicker(image: self.$inputImage)
                }
                .offset(x: 0, y: -20)

            } ///End-VStack
            .toolbar(content: {
                 HStack(spacing: 280) {
                    Image("back").resizable().frame(width: 70, height: 25)
                        .onTapGesture {
                            self.showImagePicker = false
                            self.close = false
                        }
                    Image("empty").resizable().frame(width: 20, height: 20)
                }
            })

            } ///End-ZStack
            .ignoresSafeArea()

            
     } ///End-NavigationView

    }  ///End-if
    


    
    }


//struct PdfViewPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        PdfViewPicker()
//    }
//}

