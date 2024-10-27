//
//  InnerHeightPreferenceKey.swift
//  SendIt
//
//  Created by Wojciech Kozioł on 25/10/2024.
//
// https://stackoverflow.com/questions/74471576/make-sheet-the-exact-size-of-the-content-inside

import SwiftUI

struct InnerHeightPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
