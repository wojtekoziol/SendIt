//
//  Street.swift
//  SendIt
//
//  Created by Wojciech Kozioł on 25/10/2024.
//

import Foundation

struct Street: Codable, Identifiable {
    let id: Int
    let name: String
    let courierId: Int

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case courierId = "courier_id"
    }
}
