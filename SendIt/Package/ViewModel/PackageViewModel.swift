//
//  PackageViewModel.swift
//  SendIt
//
//  Created by Wojciech Kozioł on 25/10/2024.
//

import Foundation

@Observable class PackageViewModel {
    private let packageBaseUrl = "http://localhost:3000/package"

    private(set) var userPackages = [Package]()

    func fetchUserPackages(userId: Int) async {
        guard let url = URL(string: "\(packageBaseUrl)/\(userId)") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard (response as? HTTPURLResponse)?.statusCode == 200 else { return }

            userPackages = try JSONDecoder().decode([Package].self, from: data)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    func createPackage(senderId: Int, receiverFirstName: String, receiverLastName: String, receiverPhone: String, streetId: Int, weight: Double, maxSize: Double) async {
        guard let url = URL(string: "\(packageBaseUrl)/\(senderId)/\(receiverFirstName)/\(receiverLastName)/\(receiverPhone)/\(streetId)/\(weight)/\(maxSize)") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { return }

            let newPackage = try JSONDecoder().decode(Package.self, from: data)
            userPackages.append(newPackage)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
