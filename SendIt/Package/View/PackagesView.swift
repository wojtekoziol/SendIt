//
//  PackagesView.swift
//  SendIt
//
//  Created by Wojciech Kozioł on 25/10/2024.
//

import SwiftUI

struct PackagesView: View {
    @Environment(UserViewModel.self) private var userVM
    @Environment(StreetsViewModel.self) private var streetsVM

    @State private var packageVM = PackageViewModel()
    @State private var showingAddSheet = false


    var receivePackages: [Package] {
        guard let userId = userVM.user?.id else { return packageVM.userPackages }
        return packageVM.userPackages.filter { $0.isReceiver(userId: userId) }
    }

    var sentPackages: [Package] {
        guard let userId = userVM.user?.id else { return packageVM.userPackages }
        return packageVM.userPackages.filter { !$0.isReceiver(userId: userId) }
    }

    var body: some View {
        if let user = userVM.user {
            NavigationStack {
                List {
                    Section("Receive") {
                        ForEach(receivePackages) { package in
                            PackageRowView(package: package)
                        }
                    }

                    Section("Sent") {
                        ForEach(sentPackages) { package in
                            PackageRowView(package: package)
                        }
                    }
                }
                .navigationTitle("Packages")
                .toolbar {
                    Button("Add", systemImage: "plus") {
                        showingAddSheet.toggle()
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                NewPackageView()
                    .environment(packageVM)
                    .environment(userVM)
                    .environment(streetsVM)
                    .environment(StreetsViewModel())
            }
            .task {
                await packageVM.fetchUserPackages(userId: user.id)
            }
        }
    }
}

#Preview {
    PackagesView()
        .environment(UserViewModel.preview)
}
