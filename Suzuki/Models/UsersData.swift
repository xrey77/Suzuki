//
//  UsersData.swift
//  Suzuki
//
//  Created by Reynald Marquez-Gragasin on 7/9/25.
//

import Foundation

struct UsersModel: Decodable, Identifiable {
    let id: String?
    let fullname: String?
    let emailadd: String?
    let mobileno: String?
    let username: String?
    let password: String?
    let role: String?
    let createdAt: Date?
    let updatedAt: Date?
}
