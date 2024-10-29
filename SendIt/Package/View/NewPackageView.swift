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
    @State private var streetNo = ""
    @State private var apartmentNo = ""
    @State private var weight = ""
    @State private var maxSize = ""

    var isFormValid: Bool {
        guard let user = userVM.user else { return false }

        if receiverPhone == user.phoneNumber { return false }
        if receiverPhone.count != 9 { return false }

        if receiverFirstName.trimmingCharacters(in: .whitespaces).isEmpty || receiverLastName.trimmingCharacters(in: .whitespaces).isEmpty { return false }

        if streetId == nil || streetNo.isEmpty { return false }

        if weight.isEmpty || maxSize.isEmpty { return false }

        return true
    }

    var body: some View {
        if let user = userVM.user {
            NavigationStack {
                Form {
                    Section("Receiver details") {
                        TextField("Receivers first name", text: $receiverFirstName)

                        TextField("Receivers last name", text: $receiverLastName)

                        TextField("Receivers phone", text: $receiverPhone)
                            .keyboardType(.phonePad)
                    }

                    Section("Street details") {
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

                        HStack {
                            TextField("Street no", text: $streetNo)
                                .keyboardType(.numberPad)

                            Text("/")

                            TextField("Apartment no", text: $apartmentNo)
                                .keyboardType(.numberPad)
                        }
                    }

                    Section("Package details") {
                        TextField("Weight (kg)", text: $weight)
                            .keyboardType(.numberPad)

                        TextField("Max size (cm)", text: $maxSize)
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
                            guard receiverPhone != user.phoneNumber else { return }

                            guard let streetId, let streetNo = Int(streetNo), let weight = Double(weight), let maxSize = Double(maxSize) else { return }

                            Task {
                                await packageVM.createPackage(senderId: user.id, receiverFirstName: receiverFirstName, receiverLastName: receiverLastName, receiverPhone: receiverPhone, streetId: streetId, streetNo: streetNo, apartmentNo: apartmentNo.toOptionalInt(), weight: weight, maxSize: maxSize)

                                dismiss()
                            }
                        }
                        .disabled(!isFormValid)
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
