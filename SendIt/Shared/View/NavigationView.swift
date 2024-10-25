//
//  NavigationView.swift
//  SendIt
//
//  Created by Wojciech Kozioł on 25/10/2024.
//

import SwiftUI

struct NavigationView: View {
    @Environment(UserViewModel.self) private var userVM

    var body: some View {
        if let user = userVM.user {
            TabView {
                if user.isCourier {
                    StreetsView()
                        .tabItem {
                            Label("Streets", systemImage: "map")
                        }
                }
            }
        }
    }
}

#Preview {
    NavigationView()
        .environment(UserViewModel.preview)
}
