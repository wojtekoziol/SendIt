//
//  User.swift
//  SendIt
//
//  Created by Wojciech Kozioł on 24/10/2024.
//

import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let email: String
    let phoneNumber: String
}
