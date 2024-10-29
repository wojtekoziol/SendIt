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
            .alert("Enter pickup code", isPresented: $courierVM.showingPickupCodeAlert) {
                TextField("Pickup code", text: $courierVM.pickupCode)
                    .keyboardType(.numberPad)
                    .onChange(of: courierVM.pickupCode) { oldValue, newValue in
                        if newValue.count > 4 {
                            courierVM.pickupCode = oldValue
                        }
                    }

                Button("OK") {
                    Task {
                        await courierVM.markPackageAsDelivered()
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
