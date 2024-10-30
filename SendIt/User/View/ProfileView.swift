//
//  UserView.swift
//  SendIt
//
//  Created by Wojciech Kozioł on 29/10/2024.
//

import SwiftUI

struct ProfileView: View {
    @Environment(UserViewModel.self) private var userVM

    var body: some View {
        if let user = userVM.user {
            NavigationStack {
                VStack {
                    Text(user.isCourier ? "Courier" : "User").bold()
                    Text("ID: ") + Text(String(user.id)).bold()
                    Text("Phone number: ") + Text(user.phoneNumber).bold()
                    Text("Email: ") + Text(user.email).bold()
                }
                .navigationTitle("Your profile")
                .toolbar {
                    Button("Logout", systemImage: "rectangle.portrait.and.arrow.right") {
                        userVM.logout()
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView()
        .environment(UserViewModel.preview)
}
