//
//  UserView.swift
//  Suzuki
//
//  Created by Reynald Marquez-Gragasin on 7/9/25.
//

import SwiftUI
import CoreData
import PDFKit
import UniformTypeIdentifiers

//struct TextFile: FileDocument {
//    static var readableContentTypes = [UTType.pdf]
//    var pdf = ""
//    init(initialPdf: String = "") {
//        pdf = initialPdf
//    }
//
//    init(filewrapper: FileWrapper, contentType: UTType) throws {
//        if let data = filewrapper.regularFileContents {
//            pdf = String(decoding: data, as: UTF8.self)
//        }
//    }
//}

struct Item: Hashable, Identifiable {
    let id = UUID()
    var text: String
}

struct UsersView: View {

    @Environment(\.managedObjectContext) var manageObjectContext
    @FetchRequest(entity: UsersEntity.entity(), sortDescriptors: [])
        var usersList: FetchedResults<UsersEntity>
    @State var xid = ""
    @State var fullname = ""
    @State var emailadd = ""
    @State var mobileno = ""
    @State var username = ""
    @State var password = ""
    @State var isPresented: Bool = false

    @State var pdf2: String = ""
    @State var pdf3: String = ""
    @State var pdf1: String = ""
    
    @State var url: URL?
    @State private var showPdf1 = false
    @State private var shownewUser = false
    @State private var showEdituser = false
    
    @State var showImagePicker: Bool = false
    
    @State private var searchText: String = ""
    @State private var selectedRow: String?
    @State private var show = false
    @State var clickUser: Int? = nil

    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "Helvetica", size: 27)!, .foregroundColor: UIColor.white]
    }
    
    var body: some View {
      ZStack {
        Color.yellow.ignoresSafeArea()
        .navigationTitle("User's Data")
            
            VStack {
                SearchBar(text: $searchText) //SearchBar
                    .offset(x: 0, y: -30)
                List {
                    ForEach(usersList.filter {searchText.isEmpty ? true : $0.fullname!.localizedCaseInsensitiveContains(searchText)}) { item in
                      HStack {
                        Text("\(item.fullname ?? "Unknown")")
                            .font(.title)
                            .foregroundColor(.black)

                      }.onTapGesture {
                        self.showEdituser = true
                        self.xid = item.idno!
                        self.fullname = item.fullname!
                        self.emailadd = item.emailadd!
                        self.mobileno = item.mobileno!
                        self.username = item.username!
                        self.password = item.password!
                      }
                      .ignoresSafeArea()
                      .fullScreenCover(isPresented: $showEdituser, content: {
                        EditUser(xid: self.$xid, showEdituser: self.$showEdituser, fullname: self.$fullname, emailadd: self.$emailadd, mobileno: self.$mobileno, username: self.$username, password: self.$password)
                              .background(BackgroundClearView())
                      })

                    }
                    .onDelete(perform: deleteUser)
                }
                .offset(x: 0, y: -30)

            }
            .frame(width: 400, height: 650, alignment: .center)
            .toolbar {
                HStack(spacing: 20) {
                        //PDF VIEWER
                        Button {
                            self.clickUser = 0
                            self.showPdf1.toggle()
                            self.showImagePicker = true
                            if let pdfData = generatePDF() {
                                let fileURL = savePDF(data: pdfData, fileName: "UsersList")
                                print(fileURL! as Any)
                            }

                            
                        } label: {

                            Image(systemName: "doc.text.magnifyingglass")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white)
                        }
                        .fullScreenCover(isPresented: $showPdf1, content: {

//                            PdfViewPicker(showImagePicker: $showImagePicker)
//                                .background(BackgroundClearView())
//
                            PdfPreview(showPdf1: $showPdf1, url: $url)
                                .ignoresSafeArea()
                        })

                        //ADD NEW USER
                        VStack {
                        Button {
                            self.clickUser = 2
                            self.shownewUser.toggle()
                            self.isPresented = true
                        } label: {
                            VStack {
                            Image(systemName: "plus")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                            }
                            .ignoresSafeArea()
                            .fullScreenCover(isPresented: $isPresented, content: {
                                NewUser(isPresented: $isPresented)
                                    .background(BackgroundClearView())
                            })
                            

                        }
                            
                    } //HStack
                }// if
            }
        
        
      } //ZStack
      .background(Color.yellow)
    }
    
    
    
    private func deleteUser(at indexSet: IndexSet) {
        do {
        try indexSet.forEach{ index in
            let userindex = usersList[index]
            manageObjectContext.delete(userindex)
            try manageObjectContext.save()
         }
        } catch {
            print("Error! Unable to delete user....")
        }
    }
        
    struct BackgroundClearView: UIViewRepresentable {
        func makeUIView(context: Context) -> UIView {
            let view = UIView()
            DispatchQueue.main.async {
                view.superview?.superview?.backgroundColor = .clear
            }
            return view
        }

        func updateUIView(_ uiView: UIView, context: Context) {}
    }
    
///PDFKIT FUNCTIONALITIES
    struct PDFContentView: View {
        @Environment(\.managedObjectContext) var manageObjectContext
        @FetchRequest(entity: UsersEntity.entity(), sortDescriptors: [])
            var usersList: FetchedResults<UsersEntity>

        var body: some View {
            ScrollView{
                ForEach(usersList) { item in
                  HStack {
                    Text("\(item.fullname ?? "Unknown")")
                  }
            }
            .padding()
        }
     }
    }

    func getDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short

        let formattedDate = dateFormatter.string(from: Date())
        return formattedDate
    }

    
        func generatePDF() -> Data? {
            var ln: Int = 1
            pdf1 = "<!DOCTYPE html><html lang=\"en\"><head><meta charset=\"UTF-8\">" +
                "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">" +
                "<title>User's Core Data Report</title></head><body><center>" +
                "<h3 style=\"margin-top:80px;\">User's Core Data Report</h3>" +
                "<h5 style=\"margin-top: -10px;\">As of \(getDate())</h5>" +
                "<table style=\"margin-top: 50px;border-style:inset; border-width:thin\">" +
                "<thead style=\"background-color: lightgray;\"><tr>" +
                "<td style=\"width:50px;border-style:solid;border-width:thin;text-align: center;\">#</th>" +
                "<td style=\"width:150px;border-style:solid;border-width:thin;text-align: center;\"> Name</th>" +
                "<td style=\"width:180px;border-style:solid;border-width:thin;text-align: center;\"> Email Address</th>" +
                "<td style=\"width:80px;border-style:solid;border-width:thin;text-align: center;\"> Mobile</th>" +
                "<td style=\"width:100px;border-style:solid;border-width:thin;text-align: center;\"> Created</th>" +
                "</tr></thead><tbody>"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium

            let pageWidth: CGFloat = 612
             let pageHeight: CGFloat = 792
             let margin: CGFloat = 50
             let contentWidth = pageWidth - 2 * margin * 2
             let contentHeight = pageHeight - 2 * margin

             let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight))

             var currentY: CGFloat = margin
             let textAttributes: [NSAttributedString.Key: Any] = [
                 .font: UIFont.systemFont(ofSize: 14),
                 .paragraphStyle: NSMutableParagraphStyle()
             ]
             
             let data = pdfRenderer.pdfData { context in
                 context.beginPage()
                 
                 for person in usersList {
                    let formattedDate = dateFormatter.string(from: person.createdAt!)

                     pdf2 += "<tr><td style=\"width: 20px;;border-style:solid;border-width:thin;padding:3px;\" scope=\"row\">\(ln)</td>" +
                        "<td style=\"width: 200px;border-style:solid;border-width:thin;padding:3px;\">\(String(describing: person.fullname!))</td>" +
                        "<td style=\"width: 180px;border-style:solid;border-width:thin;padding:3px;\">\(String(describing: person.emailadd!))</td>" +
                        "<td style=\"width: 80px;border-style:solid;border-width:thin;padding:3px;\">\(String(describing: person.mobileno!))</td>" +
                        "<td style=\"width: 100px;border-style:solid;border-width:thin;padding:3px;\">\(String(describing: formattedDate))</td></tr>"
                    
                 
                    pdf3 = "</tbody></table></center></body></html>"
                    let personContent = pdf1 + pdf2 + pdf3
                    ln = ln + 1
                    self.url = convertToPdfFileAndShare(textMessage: personContent)
                    
                     let attributedString = NSAttributedString(string: personContent, attributes: textAttributes)
                     let textHeight = attributedString.boundingRect(with: CGSize(width: contentWidth, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil).height + 30

                     if currentY + textHeight > contentHeight + margin {
                         context.beginPage()
                         currentY = margin
                     }

                     attributedString.draw(in: CGRect(x: margin, y: currentY, width: contentWidth, height: textHeight))
                     currentY += textHeight
                 }
             }
             
             return data
         }
        
        func savePDF(data: Data, fileName: String) -> URL? {
            let fileManager = FileManager.default
            guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return nil
            }
            let fileURL = documentDirectory.appendingPathComponent("\(fileName).pdf")
            
            do {
                try data.write(to: fileURL)
                return fileURL
            } catch {
                print("Error saving PDF: \(error.localizedDescription)")
                return nil
            }
        }
        
    func convertToPdfFileAndShare(textMessage: String) -> URL {

        let heading = UIMarkupTextPrintFormatter(markupText: textMessage.uppercased())
        let render = UIPrintPageRenderer()
        render.addPrintFormatter(heading, startingAtPageAt: 0)

        let page = CGRect(x:0, y:0, width: 595.2, height: 841.8)
        render.setValue(page, forKey: "paperRect")
        render.setValue(page, forKey: "printableRect")

        let pdfData = NSMutableData()

        UIGraphicsBeginPDFContextToData(pdfData, .zero, nil)

        for i in 0..<render.numberOfPages {
            UIGraphicsBeginPDFPage();
            render.drawPage(at: i, in: UIGraphicsGetPDFContextBounds())
        }

        UIGraphicsEndPDFContext();
                
        guard let outputUrl = try? FileManager.default.url(for: .documentDirectory,
                                                           in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("output")
            .appendingPathExtension("pdf") else { fatalError("Destination URL not created.") }

        
        
        pdfData.write(to: outputUrl, atomically: true)
        return outputUrl

    }

    
    
}

struct UsersView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        UsersView()
            .environment(\.managedObjectContext, context)
            .previewDevice("iPhone 11 Pro Max")
        
    }
}
