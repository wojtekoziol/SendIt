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
    private var packageToDeliver: Package?
    var showingPickupCodeAlert = false
    var pickupCode = ""

    var sortedPackages: [Package] {
        packages.sorted { $0.id < $1.id }
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

    func changePackageStatus(to status: PackageStatus, for package: Package, pickupCode: String? = nil) async {
        if status == .delivered && pickupCode == nil {
            showPickupCodeAlert(for: package)
            return
        }

        guard let url = URL(string: "\(packageBaseUrl)/\(package.id)/\(status.statusId)/\(pickupCode ?? "null")") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard (response as? HTTPURLResponse)?.statusCode == 200 else { return }

            let updatedPackage = try JSONDecoder().decode(Package.self, from: data)

            packages.removeAll { $0.id == package.id }
            packages.append(updatedPackage)

            return
        } catch {
            print("Error: \(error.localizedDescription)")
            return 
        }
    }

    private func showPickupCodeAlert(for package: Package) {
        pickupCode = ""
        packageToDeliver = package
        showingPickupCodeAlert = true
    }

    func markPackageAsDelivered() async {
        guard let packageToDeliver, pickupCode.count == 4 else { return }
        await changePackageStatus(to: .delivered, for: packageToDeliver, pickupCode: pickupCode)
    }
}
