//
//  String+ToOptionalInt.swift
//  SendIt
//
//  Created by Wojciech Kozioł on 29/10/2024.
//

import Foundation

extension String {
    func toOptionalInt() -> Int? {
        self.isEmpty ? nil : Int(self)
    }
}
