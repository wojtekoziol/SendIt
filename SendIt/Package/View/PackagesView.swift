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

    var body: some View {
        if let user = userVM.user {
            NavigationStack {
                List {
                    ForEach(packageVM.userPackages) { package in
                        Text(String(package.id))
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
