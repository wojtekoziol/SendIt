//
//  PackageRowView.swift
//  SendIt
//
//  Created by Wojciech Kozioł on 27/10/2024.
//

import SwiftUI

struct PackageRowView: View {
    @Environment(UserViewModel.self) private var userVM

    let package: Package

    @State private var email = "Unknown"

    var body: some View {
        VStack(alignment: .leading) {
            if let userId = userVM.user?.id {
                HStack {
                    Text(package.isReceiver(userId: userId) ? "From" : "To") + Text(" \(email)").bold()

                    Spacer()

                    Image(systemName: package.isReceiver(userId: userId) ? "arrow.down.right" : "arrow.up.right")
                }
            }

            Text("Package ID: \(package.id)")

            HStack {
                Text("\(package.status)")
                    .foregroundStyle(package.status.color)
                    .bold()

                Spacer()


                if let userId = userVM.user?.id, package.isReceiver(userId: userId) && [PackageStatus.inTransit, PackageStatus.pickupPoint].contains(package.status) {
                    Text("Pickup Code: ") + Text(String(package.pickupCode)).bold()
                }
            }
        }
        .padding(.horizontal, 5)
        .padding(.vertical, 2)
        .task {
            guard let userId = userVM.user?.id else { return }
            guard let fetchId = package.isReceiver(userId: userId) ? package.senderId : package.receiverId else { return }

            let user = await userVM.getUser(for: fetchId)
            if let email = user?.email {
                self.email = email
            }
        }
    }
}

#Preview {
    PackageRowView(package: .preview)
        .frame(maxHeight: 100)
        .environment(UserViewModel.preview)
}
