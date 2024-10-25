//
//  ContentView.swift
//  SendIt
//
//  Created by Wojciech Kozioł on 24/10/2024.
//

import SwiftUI

struct AuthView: View {
    @State private var userVM = UserViewModel()

    var body: some View {
        Group {
            if userVM.user == nil {
                LoginView()
            } else {
                NavigationView()
            }
        }
        .environment(userVM)
    }
}

#Preview {
    AuthView()
}
