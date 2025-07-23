//
//  UserView.swift
//  Suzuki
//
//  Created by Reynald Marquez-Gragasin on 7/9/25.
//

import SwiftUI
import CoreData
import PDFKit
import MobileCoreServices

struct UsersView: View {
    @Environment(\.managedObjectContext) var manageObjectContext
    @FetchRequest(entity: UsersEntity.entity(), sortDescriptors: [])
        var usersList: FetchedResults<UsersEntity>
    
    @State var inputImage: UIImage?
    @State var image: Image?
    @State private var fileURL: URL?
    @State var xid = ""
    @State var fullname = ""
    @State var emailadd = ""
    @State var mobileno = ""
    @State var username = ""
    @State var password = ""
    @State var isPresented: Bool = false
    @State var showDocumentPicker = false
    @State var showDocumentPicker2 = false
    @State var pdf1: String = ""
    @State var pdf2: String = ""
    @State var pdf3: String = ""
    @State var pdf4: String = ""
    @State var pageno: String = ""
    @State var url: URL?
    @State private var showPdf1 = false
    @State private var showPdf2 = false
    @State private var showPdf3 = false
    @State private var shownewUser = false
    @State private var showEdituser = false
    @State var showImagePicker: Bool = false
    @State var showImagePicker2: Bool = true
    @State private var searchText: String = ""
    @State private var selectedRow: String?
    @State private var show = false
    @State var clickUser: Int? = 0

    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "Helvetica", size: 27)!, .foregroundColor: UIColor.white]
    }
        
    var body: some View {
      ZStack {
            Color.yellow.ignoresSafeArea()
            VStack {
                SearchBar(text: $searchText) //SearchBar
                    .offset(x: 0, y: -30)
                GeometryReader { geom in
                ScrollView {
                List {
                    ForEach(usersList.filter {searchText.isEmpty ? true : $0.fullname!.localizedCaseInsensitiveContains(searchText)}) { item in
                        LazyHStack {
                          Text("\(item.fullname ?? "Unknown")")
                            .font(.title)
                            .foregroundColor(.black)
                        }.onTapGesture {
                            DispatchQueue.main.async {
                                showEdituser = true
                                xid = "\(item.idno!)"
                                fullname = "\(item.fullname!)"
                                emailadd = "\(item.emailadd!)"
                                mobileno = "\(item.mobileno!)"
                                username = "\(item.username!)"
                                password = "\(item.password!)"
                            }
                        }
                        .frame(width: 400 ,alignment: .leading)
                        Divider()

                    }
                    .onDelete(perform: deleteUser)
                    .fullScreenCover(isPresented: $showEdituser, content: {
                        ///EDIT USER
                       EditUser(xid: $xid, showEdituser: $showEdituser, fullname: $fullname, emailadd: $emailadd, mobileno: $mobileno, username: $username, password: $password).background(BackgroundClearView())
                    })

                } ///End-List
                .frame(height: geom.size.height + 300)
                .padding([.horizontal], -16)  ///Hide Vertical Scrollbar indicator
                    
                } ///End-ScrollView
                .offset(x: 0.0, y: -30.0)
                

                } ///GeometryReader
            }
            .frame(width: 400, height: 650, alignment: .center)
            .navigationTitle("User's Data")
            .toolbar {
                HStack(spacing: 20) {

                        ///DOCUMENT PICKER
                        Button {
                            fileURL = URL(string: "start")
                            showDocumentPicker2 = true
                        } label: {
                            Image(systemName: "icloud.and.arrow.down.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.gray)
                                .fullScreenCover(isPresented: $showDocumentPicker2, onDismiss: {showDocumentPicker2 = false}) {
                                    DocumentPicker(documentTypes: [String(kUTTypePDF)],
                                                    onPicked: { (pickedURLs) in
                                                        url = pickedURLs[0].absoluteURL
                                                        self.showPdf3 = true
                                                    }) {
                                                         print("Cancelled")
                                                     }
                                }
                        }
                    
                        ///DISPLAY PDF FROM DOCUMENT PICKER
                        VStack {
                        }
                        .fullScreenCover(isPresented: self.$showPdf3, onDismiss: {self.showPdf3 = false}, content: {
                               PreviewPdf2(showPdf3: self.$showPdf3, url: $url)
                                    .ignoresSafeArea()
                                    .background(BackgroundClearView())
                        })

                        ///SAVE PDF TO PHOTO LIBRARY
                        Button {
                            if let pdfData = generatePDF2() {
                                savePDF(data: pdfData, fileName: "UsersList")
                            }
                        } label: {
                            Image(systemName: "arrow.up.doc.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.red)
                        }
                    
                        ///IMAGE PICKER / CONVERT IMAGE DATA TO PDF
                        Button {
                            showImagePicker = true
                            showPdf2 = true
                        } label: {
                            Image(systemName: "arrow.down.doc")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.blue)
                        }
                        .fullScreenCover(isPresented: $showImagePicker, onDismiss: loadImage) {
                            ImagePicker(image: self.$inputImage)
                        }
                    
                        ///DISPLAY CONVERTED IMAGE TO PDF
                        if image != nil {
                            EmptyView()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .fullScreenCover(isPresented: $showPdf2) {
                                    PreviewPdf(showPdf2: $showPdf2, url: $url)
                                        .ignoresSafeArea()
                            }
                        }
                    
                        ///VIEW COREA DATA IN PDF VIEWER
                        Button {
                            self.clickUser = 0
                            self.showPdf1.toggle()
                            if let pdfData = generatePDF1() {
                                savePDF(data: pdfData, fileName: "UsersList")
                            }
                        } label: {

                            Image(systemName: "doc.text.magnifyingglass")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.white)
                        }
                        .fullScreenCover(isPresented: $showPdf1) {
                            PdfPreview(showPdf1: $showPdf1, url: $url)
                                .ignoresSafeArea()
                        }

                        ///ADD NEW USER
                            Button {
                                DispatchQueue.main.async {
                                    shownewUser = true
                                }
                            } label: {
                                VStack {
                                    Image(systemName: "plus")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(.green)
                                }
                            }///End-Button
                    
                    }///End-HStack

                } //End-toolbar
                .fullScreenCover(isPresented: $shownewUser) {
                    NewUser(shownewUser: $shownewUser)
                        .ignoresSafeArea()
                        .background(BackgroundClearView())
                }

            }///ZStack
      } ///some View
    
    
     func deleteUser(at indexSet: IndexSet) {
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

        func updateUIView(_ uiView: UIView, context: Context) {
            // Update pdf view if needed
        }
    }
    
///PDFKIT FUNCTIONALITIES
    func getDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short

        let formattedDate = dateFormatter.string(from: Date())
        return formattedDate
    }

    
    func generatePDF1() -> Data? {
            var ln: Int = 0
            var ctr: Int = 0
            var personContent: String = ""
            pdf1 = "<!DOCTYPE html><html lang=\"en\"><head><meta charset=\"UTF-8\">" +
                "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">" +
                "<title>User's Core Data Report</title></head><body><center>" +
                "<h3>User's Core Data Report</h3>" +
                "<h5>As of \(getDate())</h5>" +
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

            let pageWidth: CGFloat = 595.28 //612
            let pageHeight: CGFloat = 841.89 //792

             let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight))

            pageno = "<table style=\"width: 400px\"><tr><td></td></tr>" +
                "<tr><td style=\"text-align: center;\">Page 1 of 3</td></tr></table>"

             
             let data = pdfRenderer.pdfData { context in
                 context.beginPage()
                 
                 for person in usersList {
                    ln += 1
                    ctr += 1

                     let formattedDate = dateFormatter.string(from: person.createdAt!)
                     pdf2 += "<tr><td style=\"width: 20px;;border-style:solid;border-width:thin;padding:3px;\" scope=\"row\">\(ln)</td>" +
                        "<td style=\"width: 200px;border-style:solid;border-width:thin;padding:3px;\">\(String(describing: person.fullname!))</td>" +
                        "<td style=\"width: 180px;border-style:solid;border-width:thin;padding:3px;\">\(String(describing: person.emailadd!))</td>" +
                        "<td style=\"width: 80px;border-style:solid;border-width:thin;padding:3px;\">\(String(describing: person.mobileno!))</td>" +
                        "<td style=\"width: 100px;border-style:solid;border-width:thin;padding:3px;\">\(String(describing: formattedDate))</td></tr>"

                        
                        pdf3 = "</tbody></table>"
                        pdf4 = "</center></body></html>"
                        personContent = pdf1 + pdf2 + pdf3 + pageno + pdf4
                        self.url = convertToPdfFileAndShare(textMessage: personContent)
                 }
             }
             return data
         }

    func generatePDF2() -> Data? {
            var ln: Int = 1
            var ctr: Int = 1
            pdf1 = "<!DOCTYPE html><html lang=\"en\"><head><meta charset=\"UTF-8\">" +
                "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">" +
                "<title>User's Core Data Report</title></head><body><center>" +
                "<h3>User's Core Data Report</h3>" +
                "<h5>As of \(getDate())</h5>" +
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

             let pageWidth: CGFloat = 595.28 //612
             let pageHeight: CGFloat = 841.89 //792
             let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight))

            pageno = "<table style=\"width: 600px\"><tr><td>&nbsp;</td></tr>" +
                "<tr><td style=\"text-align: right;\">Page 1 of 3</td></tr></table>"
        
             var personContent: String = ""
             let data = pdfRenderer.pdfData { context in
                 context.beginPage()
                 
                 for person in usersList {
                    let formattedDate = dateFormatter.string(from: person.createdAt!)

                      pdf2 += "<tr><td style=\"width: 20px;;border-style:solid;border-width:thin;padding:3px;\" scope=\"row\">\(ln)</td>" +
                        "<td style=\"width: 200px;border-style:solid;border-width:thin;padding:3px;\">\(String(describing: person.fullname!))</td>" +
                        "<td style=\"width: 180px;border-style:solid;border-width:thin;padding:3px;\">\(String(describing: person.emailadd!))</td>" +
                        "<td style=\"width: 80px;border-style:solid;border-width:thin;padding:3px;\">\(String(describing: person.mobileno!))</td>" +
                        "<td style=\"width: 100px;border-style:solid;border-width:thin;padding:3px;\">\(String(describing: formattedDate))</td></tr>"
                        if ctr == 24 {
                            
                        }
                    
                         pdf3 = "</tbody></table></center></body></html>"
                         personContent = pdf1 + pdf2 + pdf3
                        ln = ln + 1
                        ctr = ctr + 1
                        convertToPdf(textMessage: personContent)
                    
                 }
             }
             
             return data
         }
    
    func savePDF(data: Data, fileName: String) {
        let fileManager = FileManager.default
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let fileURL = documentDirectory.appendingPathComponent("\(fileName).pdf")
        
        do {
            try data.write(to: fileURL)
        } catch {
            print("Error saving PDF: \(error.localizedDescription)")
        }
    }
    
        func convertToPdfFileAndShare(textMessage: String) -> URL {
            let heading = UIMarkupTextPrintFormatter(markupText: textMessage.uppercased())
            let render = UIPrintPageRenderer()
            render.addPrintFormatter(heading, startingAtPageAt: 0)
            let paperSize = CGSize(width: 595.28, height: 841.89)
            let printableRect = CGRect(x: 0, y: 50, width: paperSize.width, height: paperSize.height - 164.0)
            let paperRect = CGRect(x: 0, y: 0, width: paperSize.width, height: paperSize.height);
            render.setValue(NSValue(cgRect: paperRect), forKey: "paperRect")
            render.setValue(NSValue(cgRect: printableRect), forKey: "printableRect")
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

    func drawPDFfromURL(url: URL) -> UIImage? {
          guard let document = CGPDFDocument(url as CFURL) else { return nil }
          guard let page = document.page(at: 1) else { return nil }

          let pageRect = page.getBoxRect(.mediaBox)
          let renderer = UIGraphicsImageRenderer(size: pageRect.size)
          let img = renderer.image { ctx in
              UIColor.white.set()
              ctx.fill(pageRect)

              ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
              ctx.cgContext.scaleBy(x: 1.0, y: -1.0)

              ctx.cgContext.drawPDFPage(page)
          }
          return img
      }
    
    func convertToPdf(textMessage: String) {
        var pdfImage = UIImage()

        let heading = UIMarkupTextPrintFormatter(markupText: textMessage.uppercased())
        let render = UIPrintPageRenderer()
        render.addPrintFormatter(heading, startingAtPageAt: 0)
        let paperSize = CGSize(width: 595.28, height: 841.89)
        let printableRect = CGRect(x: 0, y: 50, width: paperSize.width, height: paperSize.height - 164.0)
        let paperRect = CGRect(x: 0, y: 0, width: paperSize.width, height: paperSize.height);
        render.setValue(NSValue(cgRect: paperRect), forKey: "paperRect")
        render.setValue(NSValue(cgRect: printableRect), forKey: "printableRect")


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

        pdfImage = drawPDFfromURL(url: outputUrl)!

        //SAVE PDF AS IMAGE TO PHOTO LIBRARY
        UIImageWriteToSavedPhotosAlbum(pdfImage, nil, nil, nil)

        guard let vc = UIApplication.shared.connectedScenes.compactMap({$0 as? UIWindowScene}).first?.windows.first?.rootViewController else{
            return
        }
        
        if FileManager.default.fileExists(atPath: outputUrl.path) {
            let url = URL(fileURLWithPath: outputUrl.path)
            let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)

            let excludeActivities = [UIActivity.ActivityType.postToFlickr,
                UIActivity.ActivityType.postToWeibo,
                UIActivity.ActivityType.message, UIActivity.ActivityType.mail,
                UIActivity.ActivityType.print,
                UIActivity.ActivityType.markupAsPDF,
                UIActivity.ActivityType.copyToPasteboard,
                UIActivity.ActivityType.assignToContact,
                UIActivity.ActivityType.saveToCameraRoll,
                UIActivity.ActivityType.addToReadingList,
                UIActivity.ActivityType.postToFlickr,
                UIActivity.ActivityType.postToVimeo,
                UIActivity.ActivityType.airDrop,
                UIActivity.ActivityType.postToTencentWeibo]

                activityViewController.excludedActivityTypes = excludeActivities
                activityViewController.popoverPresentationController?.sourceView = vc.view

                //if user on iPad
                if UIDevice.current.userInterfaceIdiom == .pad {
                    if activityViewController.responds(to: #selector(getter: UIViewController.popoverPresentationController)) {
                    }
                }
            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height, width: 0, height: 0)
            activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
                vc.present(activityViewController, animated: true, completion: nil)
        } else {
            print("Error! Document was not found.")
        }
    }
    
        private func loadImage() {
            guard let inputImage = inputImage else { return }
            image = Image(uiImage: inputImage)
            createPDFDataFromImage(image: inputImage)
        }
    
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
            let xpath = dir?.appendingPathComponent("file.pdf")
            
            do {
                try pdfData.write(to: xpath!, options: NSData.WritingOptions.atomic)
            } catch {
                print("error catched")
            }
            url = xpath?.absoluteURL
            print(url!)
        }
}

struct UsersView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        UsersView()
            .environment(\.managedObjectContext, context)
            .previewDevice("iPhone 14.4 Pro Max")
        
    }
}

extension UIPrintPageRenderer {
    func printToPDF() -> NSData {
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, self.paperRect, nil)
        self.prepare(forDrawingPages: NSMakeRange(0, self.numberOfPages))
        let bounds = UIGraphicsGetPDFContextBounds()
        for i in 0..<self.numberOfPages {
            UIGraphicsBeginPDFPage();
            self.drawPage(at: i, in: bounds)
        }
        UIGraphicsEndPDFContext();
        return pdfData;
    }
}

