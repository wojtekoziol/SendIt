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
                if let user = userVM.user {
                    Text(user.email)
                    Text(user.isCourier ? "Courier" : "User")
                }
            }
        }
        .environment(userVM)
    }
}

#Preview {
    AuthView()
}
