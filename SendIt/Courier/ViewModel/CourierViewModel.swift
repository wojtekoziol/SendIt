//
//  CourierViewModel.swift
//  SendIt
//
//  Created by Wojciech Kozioł on 27/10/2024.
//

import Foundation

@Observable class CourierViewModel {
    private let packageBaseUrl = "http://localhost:3000/package"
    
    private(set) var packages = [Package]()

    var sortedPackages: [Package] {
        packages.sorted { $0.streetId < $1.streetId }
    }

    func fetchPackages(for userId: Int) async {
        guard let url = URL(string: "\(packageBaseUrl)/courier/\(userId)") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard (response as? HTTPURLResponse)?.statusCode == 200 else { return }

            packages = try JSONDecoder().decode([Package].self, from: data)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    func changePackageStatus(to status: PackageStatus, for package: Package) async {
        guard let url = URL(string: "\(packageBaseUrl)/\(package.id)/\(status.statusId)") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard (response as? HTTPURLResponse)?.statusCode == 200 else { return }

            let updatedPackage = try JSONDecoder().decode(Package.self, from: data)

            packages.removeAll { $0.id == package.id }
            packages.append(updatedPackage)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
