//
//  UserViewModel.swift
//  SendIt
//
//  Created by Wojciech Kozioł on 24/10/2024.
//

import Foundation

@Observable class UserViewModel {
    private let authBaseUrl = "http://localhost:3000/auth"

    private(set) var user: User?

    func register(email: String, password: String, phoneNumber: String, asCourier: Bool) async {
        guard let url = URL(string: "\(authBaseUrl)/\(email)/\(password)/\(phoneNumber)/\(asCourier)") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard (response as? HTTPURLResponse)?.statusCode == 200 else { return }

            user = try JSONDecoder().decode(User.self, from: data)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    func login(email: String, password: String) async {
        guard let url = URL(string: "\(authBaseUrl)/\(email)/\(password)/") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { return }

            user = try JSONDecoder().decode(User.self, from: data)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    func getUser(for id: Int) async -> User? {
        guard let url = URL(string: "\(authBaseUrl)/\(id)") else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { return nil }

            let user = try JSONDecoder().decode(User.self, from: data)
            return user
        } catch {
            print("Error: \(error.localizedDescription)")
            return nil
        }
    }

    func logout() {
        user = nil
    }

    static var preview: UserViewModel {
        let vm = UserViewModel()
        vm.user = User.preview
        return vm
    }
}
