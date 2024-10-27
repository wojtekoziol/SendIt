//
//  NavigationView.swift
//  SendIt
//
//  Created by Wojciech Kozioł on 25/10/2024.
//

import SwiftUI

struct NavigationView: View {
    @Environment(UserViewModel.self) private var userVM

    @State private var streetsVM = StreetsViewModel()

    var body: some View {
        if let user = userVM.user {
            TabView {
                PackagesView()
                    .tabItem {
                        Label("Packages", systemImage: "shippingbox.fill")
                    }

                if user.isCourier {
                    StreetsView()
                        .tabItem {
                            Label("Streets", systemImage: "map")
                        }
                }
            }
            .environment(streetsVM)
        }
    }
}

#Preview {
    NavigationView()
        .environment(UserViewModel.preview)
}
