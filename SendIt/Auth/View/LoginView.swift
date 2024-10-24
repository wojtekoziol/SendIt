//
//  LoginView.swift
//  SendIt
//
//  Created by Wojciech Kozioł on 24/10/2024.
//

import SwiftUI

struct LoginView: View {
    @Environment(UserViewModel.self) private var userVM

    @State private var register = false
    @State private var email = ""
    @State private var password = ""
    @State private var phoneNumber = ""

    var mainText: String {
        register ? "Register" : "Login"
    }

    var body: some View {
        VStack {
            Text(mainText)
                .font(.largeTitle)

            TextField("Email", text: $email)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)

            SecureField("Password", text: $password)

            if register {
                TextField("Phone number", text: $phoneNumber)
                    .keyboardType(.phonePad)
            }

            Button(mainText) {
                Task {
                    if register {
                        await userVM.register(email: email, password: password, phoneNumber: phoneNumber)
                    } else {
                        await userVM.login(email: email, password: password)
                    }
                }
            }
            .buttonStyle(.borderedProminent)

            Button(register ? "Already have an account?" : "Create an account") {
                register.toggle()
            }
        }
        .textFieldStyle(.roundedBorder)
        .padding()
    }
}

#Preview {
    LoginView()
        .environment(UserViewModel())
}
