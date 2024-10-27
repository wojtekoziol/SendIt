//
//  NewPackageView.swift
//  SendIt
//
//  Created by Wojciech Kozioł on 25/10/2024.
//

import SwiftUI

struct NewPackageView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(UserViewModel.self) private var userVM
    @Environment(PackageViewModel.self) private var packageVM
    @Environment(StreetsViewModel.self) private var streetsVM

    @State private var receiverFirstName = ""
    @State private var receiverLastName = ""
    @State private var receiverPhone = ""
    @State private var streetId: Int?
    @State private var weight = ""
    @State private var maxSize = ""

    var body: some View {
        if let user = userVM.user {
            NavigationStack {
                Form {
                    Section("Receiver details") {
                        TextField("Receivers first name", text: $receiverFirstName)

                        TextField("Receivers last name", text: $receiverLastName)

                        TextField("Receivers phone", text: $receiverPhone)
                            .keyboardType(.phonePad)

                        Picker("Street", selection: $streetId) {
                            Text("No street selected").tag(nil as Int?)

                            ForEach(streetsVM.sortedStreets) { street in
                                Text(street.name)
                                    .tag(street.id)
                            }
                        }
                        .task {
                            await streetsVM.fetchStreets()
                        }
                    }

                    Section("Package details") {
                        TextField("Weight", text: $weight)
                            .keyboardType(.numberPad)

                        TextField("Max size", text: $maxSize)
                            .keyboardType(.numberPad)
                    }
                }
                .navigationTitle("Create new package")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel", role: .cancel) {
                            dismiss()
                        }
                    }

                    ToolbarItem(placement: .primaryAction) {
                        Button("Create") {
                            guard let streetId, let weight = Double(weight), let maxSize = Double(maxSize)  else { return }
                            guard receiverPhone != user.phoneNumber else { return }

                            Task {
                                await packageVM.createPackage(senderId: user.id, receiverFirstName: receiverFirstName, receiverLastName: receiverLastName, receiverPhone: receiverPhone, streetId: streetId, weight: weight, maxSize: maxSize)

                                dismiss()
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NewPackageView()
        .environment(UserViewModel.preview)
        .environment(PackageViewModel())
        .environment(StreetsViewModel.preview)
}
