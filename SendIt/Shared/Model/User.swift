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
    let isCourier: Bool

    init(id: Int, email: String, phoneNumber: String, isCourier: Bool) {
        self.id = id
        self.email = email
        self.phoneNumber = phoneNumber
        self.isCourier = isCourier
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.email = try container.decode(String.self, forKey: .email)
        self.phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        self.isCourier = try container.decode(Bool.self, forKey: .isCourier)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case phoneNumber = "phone_number"
        case isCourier = "is_courier"
    }

    static let preview = User(id: 1, email: "name@mail.com", phoneNumber: "791234567", isCourier: true)
}
