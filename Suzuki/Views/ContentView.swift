//
//  ContentView.swift
//  Suzuki
//
//  Created by Reynald Marquez-Gragasin on 7/9/25.
//

import SwiftUI


struct TextView: UIViewRepresentable {
    var text: String
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        textView.textAlignment = .justified
        textView.showsVerticalScrollIndicator = false
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
}

struct ContentView: View {
    @State var showSheetPresented = false
    @State var clickUser: Int? = nil
    
    var body: some View {
        ZStack {
                        
        NavigationView {
            HStack(spacing: 120) {
                //LEFT IMAGE
                VStack{
                Image("suzuki").resizable()
                    .frame(width: 200, height: 30, alignment: .leading)
                    .aspectRatio(1, contentMode: .fit)
                    Spacer()
                }
                //RIGHT IMAGE
                VStack {
                Button(action: {
                    showSheetPresented.toggle()
                    self.clickUser = 1

//                                if #available(iOS 17, *) {
//                                    print("SwiftUI 5.0")
//                                } else if #available(iOS 16, *) {
//                                    print("SwiftUI 4.0")
//                                } else if #available(iOS 15, *) {
//                                    print("SwiftUI 3.0")
//                                } else if #available(iOS 14, *) {
//                                    print("SwiftUI 2.0")
//                                } else if #available(iOS 13, *) {
//                                    print("SwiftUI 1.0")
//                                }

                }, label: {

                    NavigationLink(destination: UsersView().navigationBarBackButtonHidden(false),
                                   tag: 1, selection: $clickUser) {
                        EmptyView()
                    }


                    Image(systemName: "person.3").resizable()
                        .frame(width: 60, height: 30, alignment: .trailing)
                        .aspectRatio(1, contentMode: .fit)
                })
                    Spacer()
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarHidden(true)
                

        }//NavigationView
            VStack {
                if (clickUser == 1) {
                    EmptyView()
                } else {
                ScrollViewReader { geometry in
                ScrollView(.vertical, showsIndicators: false) {
                    Image("susuki_cars").resizable().scaledToFit().padding(.top, 50)

                    TextView(text: "In 2025, Suzuki is expected to release several new and updated car models, including the all-new Suzuki e-Vitara, a fully electric SUV. Other anticipated models include the Maruti Swift, Ertiga, Vitara, BALENO, Celerio, Wagon R, Grand Vitara, Jimny, Ignis, Alto K10, Dzire, Vitara Brezza, and Ciaz. Suzuki is also focusing on hybrid models like the Swift, Vitara, S-Cross, and Across PHEV, with the first fully electric car launching in the second half of 2025.\n\nHere's a more detailed look:\n\nNew Models and Updates:\n\nSUZUKI VITARA e-VITARA:\nSuzuki's first fully electric SUV, expected to have a rugged design and off-road capability.\n\nMARUTI SUZUKI HYBRID Models:\nSeveral hybrid models are planned, including the Swift, Vitara, S-Cross, and Across PHEV\n\nUPDATED MARUTI SUZUKI Models:\nExpect refreshed versions of popular models like the Swift, Ertiga, Baleno, and Grand Vitara\n\nNEW DZIRE HYBRID:\nSuzuki Philippines is launching the All-New Dzire Hybrid at the 2025 Manila International Auto Show.\n\nJIMNY:\nThe Jimny is expected to return with a smaller, smarter, and possibly wilder design")
                        .frame(width: 410, height: 1000, alignment: .center)
                        .font(.title).disabled(true)

                }}
                }
            }.frame(width: 400, height: 750, alignment: .center)

        }
  } //Some View

} ///end ContainerView

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        ContentView()
    }
}



