//
//  Package.swift
//  SendIt
//
//  Created by Wojciech Kozioł on 25/10/2024.
//

import SwiftUI

struct Package: Codable, Comparable, Identifiable {
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

    private init(id: Int, receiverFirstName: String, receiverLastName: String, streetId: Int, senderId: Int, weight: Double, maxSize: Double, status: PackageStatus, courierId: Int, pickupCode: Int, receiverId: Int?) {
        self.id = id
        self.receiverFirstName = receiverFirstName
        self.receiverLastName = receiverLastName
        self.streetId = streetId
        self.senderId = senderId
        self.weight = weight
        self.maxSize = maxSize
        self.status = status
        self.courierId = courierId
        self.pickupCode = pickupCode
        self.receiverId = receiverId
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.receiverFirstName = try container.decode(String.self, forKey: .receiverFirstName)
        self.receiverLastName = try container.decode(String.self, forKey: .receiverLastName)
        self.streetId = try container.decode(Int.self, forKey: .streetId)
        self.senderId = try container.decode(Int.self, forKey: .senderId)
        self.weight = try container.decode(Double.self, forKey: .weight)
        self.maxSize = try container.decode(Double.self, forKey: .maxSize)
        let statusId = try container.decode(Int.self, forKey: .status)
        self.status = .init(statusId: statusId)
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

    static func < (lhs: Package, rhs: Package) -> Bool {
        lhs.status < rhs.status
    }

    func isReceiver(userId: Int) -> Bool {
        userId == receiverId
    }

    static let preview = Package(id: 54321, receiverFirstName: "Wojtek", receiverLastName: "Kozioł", streetId: 0, senderId: 1, weight: 0.3, maxSize: 12.5, status: .inTransit, courierId: 1, pickupCode: 3241, receiverId: 0)
}

enum PackageStatus: CaseIterable, Codable, Comparable, CustomStringConvertible {
    case created
    case inTransit
    case pickupPoint
    case delivered

    init(statusId: Int) {
        switch statusId {
        case 0: self = .created
        case 1: self = .inTransit
        case 2: self = .pickupPoint
        case 3: self = .delivered
        default: self = .created
        }
    }

    var statusId: Int {
        switch self {
        case .created: return 0
        case .inTransit: return 1
        case .pickupPoint: return 2
        case .delivered: return 3
        }
    }

    var description: String {
        switch self {
        case .created: return "Created"
        case .inTransit: return "In Transit"
        case .pickupPoint: return "Pickup Point"
        case .delivered: return "Delivered"
        }
    }

    var color: Color {
        switch self {
        case .created: return .blue
        case .inTransit: return .green
        case .pickupPoint: return .yellow
        case .delivered: return .red
        }
    }
}
