//
//  CourierPackageRowView.swift
//  SendIt
//
//  Created by Wojciech Kozioł on 27/10/2024.
//

import SwiftUI

struct CourierPackageRowView: View {
    @Environment(UserViewModel.self) private var userVM
    @Environment(StreetsViewModel.self) private var streetsVM
    @Environment(CourierViewModel.self) private var courierVM

    let package: Package

    @State private var email = "Unknown"
    @State private var streetName = "Unknown street"
    @State private var packageStatus: PackageStatus

    init(package: Package) {
        self.package = package
        self._packageStatus = State(initialValue: package.status)
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(streetName)
                    .bold()

                Text(email)

                Text("Package ID: \(package.id)")
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Picker("", selection: $packageStatus) {
                ForEach(PackageStatus.allCases, id: \.self) { status in
                    Text("\(status)")
                        .tag(status)
                }
            }
            .onChange(of: packageStatus) { oldValue, newValue in
                if newValue == .delivered { packageStatus = oldValue }
                Task {                    
                    await courierVM.changePackageStatus(to: newValue, for: package)
                }
            }
        }
        .padding(.horizontal, 5)
        .padding(.vertical, 2)
        .task {
            guard let receiverID = package.receiverId else { return }
            let receiver = await userVM.getUser(for: receiverID)
            if let receiverEmail = receiver?.email {
                email = receiverEmail
            }
        }
        .task {
            let street = await streetsVM.getStreet(for: package.streetId)
            if let street {
                streetName = street.name
            }
        }
    }
}

#Preview {
    CourierPackageRowView(package: .preview)
        .environment(CourierViewModel())
        .environment(UserViewModel.preview)
        .environment(StreetsViewModel.preview)
}
