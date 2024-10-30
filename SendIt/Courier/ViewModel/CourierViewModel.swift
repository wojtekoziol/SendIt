//
//  CourierViewModel.swift
//  SendIt
//
//  Created by Wojciech Kozioł on 27/10/2024.
//

import Foundation

@Observable class CourierViewModel {
    enum AlertType {
        case deliver
        case pickupPoint

        var alertTitle: String {
            switch self {
            case .deliver:
                "Enter pickup code"
            case .pickupPoint:
                "Enter pickup point id"
            }
        }

        var textFieldHint: String {
            switch self {
            case .deliver:
                "Pickup code"
            case .pickupPoint:
                "Pickup point id"
            }
        }
    }

    private let packageBaseUrl = "http://localhost:3000/package"
    
    private(set) var packages = [Package]()

    private var cachedPackage: Package?
    private(set) var alertType = AlertType.deliver
    var showingInputAlert = false
    var alertInput = ""

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

    func changePackageStatus(to status: PackageStatus, for package: Package) async {
        guard ![PackageStatus.pickupPoint, PackageStatus.delivered].contains(status) else { return }

        guard let url = URL(string: "\(packageBaseUrl)/\(package.id)/\(status.statusId)") else { return }

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

    func showInputAlert(for package: Package, type: AlertType) {
        alertType = type
        alertInput = ""
        cachedPackage = package
        showingInputAlert = true
    }

    func changeCachedPackageStatus() async {
        guard let cachedPackage, !alertInput.isEmpty else { return }

        let endpoint = alertType == .deliver ? "deliver" : "pickup"
        guard let url = URL(string: "\(packageBaseUrl)/\(endpoint)/\(cachedPackage.id)/\(alertInput)") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard (response as? HTTPURLResponse)?.statusCode == 200 else { return }

            let updatedPackage = try JSONDecoder().decode(Package.self, from: data)

            packages.removeAll { $0.id == cachedPackage.id }
            packages.append(updatedPackage)

            return
        } catch {
            print("Error: \(error.localizedDescription)")
            return
        }
    }
}
