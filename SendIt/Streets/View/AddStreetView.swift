//
//  AddStreetView.swift
//  SendIt
//
//  Created by Wojciech Kozioł on 25/10/2024.
//

import SwiftUI

struct AddStreetView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(StreetsViewModel.self) private var streetsVM

    @State private var streetName = ""

    var body: some View {
        TextField("New street", text: $streetName)

        Button("Add street") {
            Task {
                await streetsVM.addStreet(streetName)
                dismiss()
            }
        }
    }
}

#Preview {
    AddStreetView()
        .environment(StreetsViewModel())
}
