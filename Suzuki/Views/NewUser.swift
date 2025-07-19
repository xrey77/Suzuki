//
//  NewUser.swift
//  Suzuki
//
//  Created by Reynald Marquez-Gragasin on 7/12/25.
//

import SwiftUI

struct NewUser: View {
    @Binding var isPresented: Bool
    @State private var showNewuser = true
    @State private var showingAlert = false
    @State private var fullname = ""
    @State private var emailadd = ""
    @State private var mobileno = ""
    @State private var username = ""
    @State private var password = ""
    var body: some View {
            VStack{
                if self.showNewuser == true {
                    ZStack {
                VStack {
                    HStack {
                        Text("Add User        ")
                            .foregroundColor(.white)
                            .font(.title)

                        Image(systemName: "xmark.rectangle")
                            .resizable()
                            .frame(width: 25, height: 25, alignment: .topTrailing)
                            .foregroundColor(.white)
                            .onTapGesture {
                                self.showNewuser = false
                                isPresented = false
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

                        TextField("Password", text: $password)
                            .autocapitalization(.none)
                            .padding()
                            .frame(width: 250, height: 50)
                            .foregroundColor(.black)
                            .background(Color.white)
                            .cornerRadius(10)
                        Button(action: {
                            do {
                                try UsersService.saveUser(fullname, emailadd, mobileno, username, password)
                            } catch {
                                print("error....")
                                return
                            }
                        }, label: {
                            Text("Save").font(.title)
                        })
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(25)
                        .padding(.top, 2)
                    }
                }
                .frame(width: 350, height: 450, alignment: .center)
                .background(Color.red)
                .cornerRadius(20) /// make the background rounded
                .overlay( /// apply a rounded border
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.blue, lineWidth: 5)
                )
                    } //ZStack
                    .ignoresSafeArea()

                }//if
            }

    }
}

//struct NewUser_Previews: PreviewProvider {
//    static var previews: some View {
//        NewUser()
//    }
//}
