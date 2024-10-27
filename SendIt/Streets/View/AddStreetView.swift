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
        VStack(alignment: .leading) {
            Text("Add new street")
                .font(.title)

            TextField("Street name", text: $streetName)
                .textFieldStyle(.roundedBorder)

            Button("Add street") {
                Task {
                    await streetsVM.addStreet(streetName)
                    dismiss()
                }
            }
            .buttonStyle(.borderedProminent)            
        }
        .padding()
        .overlay(
            GeometryReader { geometry in
                Color.clear.preference(key: InnerHeightPreferenceKey.self, value: geometry.size.height)
            }
        )
    }
}

#Preview {
    AddStreetView()
        .environment(StreetsViewModel())
}
