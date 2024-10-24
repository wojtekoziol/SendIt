//
//  UserViewModel.swift
//  SendIt
//
//  Created by Wojciech Kozioł on 24/10/2024.
//

import Foundation

@Observable class UserViewModel {
    private let authApiEndpoint = "http://localhost:3000/auth"

    private(set) var user: User?

    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }

    func register(email: String, password: String, phoneNumber: String) async {
        guard let url = URL(string: "\(authApiEndpoint)/\(email)/\(password)/\(phoneNumber)") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 200 else { return }

            
            user = try decoder.decode(User.self, from: data)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    func login(email: String, password: String) async {
        guard let url = URL(string: "\(authApiEndpoint)/\(email)/\(password)/") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 200 else { return }

            user = try decoder.decode(User.self, from: data)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
