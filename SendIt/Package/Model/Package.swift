//
//  Package.swift
//  SendIt
//
//  Created by Wojciech Kozioł on 25/10/2024.
//

import Foundation

struct Package: Codable, Identifiable {
    let id: Int
    let receiverFirstName: String
    let receiverLastName: String
    let streetId: Int
    let senderId: Int
    let weight: Double
    let maxSize: Double
    let status: PackageStatus
    let courierId: Int
    let pickupCode: Int
    let receiverId: Int?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.receiverFirstName = try container.decode(String.self, forKey: .receiverFirstName)
        self.receiverLastName = try container.decode(String.self, forKey: .receiverLastName)
        self.streetId = try container.decode(Int.self, forKey: .streetId)
        self.senderId = try container.decode(Int.self, forKey: .senderId)
        self.weight = try container.decode(Double.self, forKey: .weight)
        self.maxSize = try container.decode(Double.self, forKey: .maxSize)
        let statusInt = try container.decode(Int.self, forKey: .status)
        self.status = .init(status: statusInt)
        self.courierId = try container.decode(Int.self, forKey: .courierId)
        self.pickupCode = try container.decode(Int.self, forKey: .pickupCode)
        self.receiverId = try container.decodeIfPresent(Int.self, forKey: .receiverId)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case receiverFirstName = "receiver_first_name"
        case receiverLastName = "receiver_last_name"
        case streetId = "street_id"
        case senderId = "sender_id"
        case weight
        case maxSize = "max_size"
        case status
        case courierId = "courier_id"
        case pickupCode = "pickup_code"
        case receiverId = "receiver_id"
    }

    func isReceiver(userId: Int) -> Bool {
        userId == receiverId
    }
}

enum PackageStatus: Codable {
    case created
    case inTransit
    case pickupPoint
    case delivered

    init(status: Int) {
        switch status {
        case 0: self = .created
        case 1: self = .inTransit
        case 2: self = .pickupPoint
        case 3: self = .delivered
        default: self = .created
        }
    }
}
