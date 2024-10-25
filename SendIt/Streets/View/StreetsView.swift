//
//  StreetsView.swift
//  SendIt
//
//  Created by Wojciech Kozioł on 25/10/2024.
//

import SwiftUI

struct StreetsView: View {
    @State private var streetsVM = StreetsViewModel()
    @State private var showingAddSheet = false

    var body: some View {
        NavigationStack {
            if streetsVM.streets.isEmpty {
                Text("No streets found.")
                    .padding()
            }

            List {
                ForEach(streetsVM.streets) { street in
                    Text(street.name)
                }
            }
            .navigationTitle("Streets")
            .toolbar {
                Button("Add", systemImage: "plus") {
                    showingAddSheet.toggle()
                }
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            AddStreetView()
                .environment(streetsVM)
        }
        .task {
            await streetsVM.fetchStreets()
        }
    }
}

#Preview {
    StreetsView()
}
