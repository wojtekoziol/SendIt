//
//  Int+ToString.swift
//  SendIt
//
//  Created by Wojciech Kozioł on 29/10/2024.
//

import Foundation

extension Int? {
    func toNullableString() -> String {
        self == nil ? "null" : String(self!)
    }
}
