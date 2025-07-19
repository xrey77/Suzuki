//
//  EditUser.swift
//  Suzuki
//
//  Created by Reynald Marquez-Gragasin on 7/12/25.
//

import SwiftUI

struct EditUser: View {
    @Binding var xid: String
    @Binding var showEdituser: Bool
    @State private var showingAlert = false

    @Binding var fullname: String
    @Binding var emailadd: String
    @Binding var mobileno: String
    @Binding var username: String
    @Binding var password: String
    
    var body: some View {
        if showEdituser == true {
        VStack {
            HStack {
                Text("Edit User         ")
                    .foregroundColor(.white)
                    .font(.title)

                Image(systemName: "xmark.rectangle")
                    .resizable()
                    .frame(width: 25, height: 25, alignment: .topTrailing)
                    .foregroundColor(.white)
                    .onTapGesture {
                        showEdituser = false
                    }
            }
            .offset(x: 50, y: 0)
            
            VStack {
                TextField("Full Name", text: $fullname)
                    .autocapitalization(.none)
                    .padding()
                    .frame(width: 250, height: 50)
                    .foregroundColor(.black)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.top, 20)

                TextField("Email Address", text: $emailadd)
                    .autocapitalization(.none)
                    .padding()
                    .frame(width: 250, height: 50)
                    .foregroundColor(.black)
                    .background(Color.white)
                    .cornerRadius(10)

                TextField("Mobile No.", text: $mobileno)
                    .autocapitalization(.none)
                    .padding()
                    .frame(width: 250, height: 50)
                    .foregroundColor(.black)
                    .background(Color.white)
                    .cornerRadius(10)

                TextField("User Name", text: $username)
                    .autocapitalization(.none)
                    .padding()
                    .frame(width: 250, height: 50)
                    .foregroundColor(.black)
                    .background(Color.white)
                    .cornerRadius(10)

                SecureField("Password", text: $password)
                    .autocapitalization(.none)
                    .padding()
                    .frame(width: 250, height: 50)
                    .foregroundColor(.black)
                    .background(Color.white)
                    .cornerRadius(10)
                Button(action: {
                    do {
                        try UsersService.updateUser(self.xid, self.fullname, self.emailadd, self.mobileno, self.username, self.password)
                    } catch {
                        print("Error! Unable to save edited user....")
                        return
                    }
                }, label: {
                    Text("Update").font(.title)
                })
                .foregroundColor(.white)
                .frame(width: 200, height: 50)
                .background(Color.blue)
                .padding(.top, 2)
//                .alert(isPresented: $showingAlert, content: {
//                    Alert(title: Text("Confirmation"), message: Text("New user has been added!"), dismissButton: .default(Text("ok")))
//                })
            }
        }
        .frame(width: 350, height: 450, alignment: .center)
        .cornerRadius(30)
        .background(Color.orange)
        .cornerRadius(20) /// make the background rounded
        .overlay( /// apply a rounded border
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.blue, lineWidth: 5)
        )
        .offset(x: 0, y: 10)
        }
    }
    
    
}

//struct EditUser_Previews: PreviewProvider {
//    static var previews: some View {
//        EditUser()
//    }
//}
