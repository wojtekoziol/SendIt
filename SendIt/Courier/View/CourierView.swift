//
//  CourierView.swift
//  SendIt
//
//  Created by Wojciech Kozioł on 27/10/2024.
//

import SwiftUI

struct CourierView: View {
    @Environment(UserViewModel.self) private var userVM

    @State private var courierVM = CourierViewModel()

    var body: some View {
        if let user = userVM.user {
            NavigationStack {
                List {
                    ForEach(courierVM.sortedPackages) { package in
                        CourierPackageRowView(package: package)
                    }
                    .environment(courierVM)
                }
                .refreshable {
                    Task {
                        await courierVM.fetchPackages(for: user.id)
                    }
                }
                .navigationTitle("Packages to deliver")
            }
            .alert(courierVM.alertType.alertTitle, isPresented: $courierVM.showingInputAlert) {
                TextField(courierVM.alertType.textFieldHint, text: $courierVM.alertInput)
                    .keyboardType(.numberPad)

                Button("OK") {
                    Task {
                        await courierVM.changeCachedPackageStatus()
                        await courierVM.fetchPackages(for: user.id)
                    }
                }

                Button("Cancel", role: .cancel) { }
            }
            .task {
                await courierVM.fetchPackages(for: user.id)
            }
        }
    }
}

#Preview {
    CourierView()
        .environment(UserViewModel.preview)
}
