//
//  StreetsViewModel.swift
//  SendIt
//
//  Created by Wojciech Kozioł on 25/10/2024.
//

import Foundation

@Observable class StreetsViewModel {
    private let streetsBaseUrl = "http://localhost:3000/street"

    private(set) var streets = [Street]()

    func fetchStreets() async {
        guard let url = URL(string: "\(streetsBaseUrl)") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard (response as? HTTPURLResponse)?.statusCode == 200 else { return }

            streets = try JSONDecoder().decode([Street].self, from: data)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    func addStreet(_ streetName: String) async {
        guard let url = URL(string: "\(streetsBaseUrl)/\(streetName)") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard (response as? HTTPURLResponse)?.statusCode == 200 else { return }

            let newStreet = try JSONDecoder().decode(Street.self, from: data)
            streets.append(newStreet)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
