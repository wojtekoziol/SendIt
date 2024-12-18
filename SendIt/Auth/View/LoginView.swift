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
    @State private var asCourier = false

    var mainText: String {
        register ? "Register" : "Login"
    }

    var isFormValid: Bool {
        if email.isEmpty || password.count < 6 { return false }

        if !email.localizedStandardContains("@") || !email.localizedStandardContains(".") { return false }
        if register && phoneNumber.count != 9 { return false }

        return true
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
                    .onChange(of: phoneNumber) { oldValue, newValue in
                        if newValue.count > 9 {
                            phoneNumber = oldValue
                        }
                    }

                Toggle("Register as a courier", isOn: $asCourier)
            }

            Button(mainText) {
                Task {
                    if register {
                        await userVM.register(email: email, password: password, phoneNumber: phoneNumber, asCourier: asCourier)
                    } else {
                        await userVM.login(email: email, password: password)
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(!isFormValid)

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
