//
//  StreetsView.swift
//  SendIt
//
//  Created by Wojciech Kozioł on 25/10/2024.
//

import SwiftUI

struct StreetsView: View {
    @Environment(StreetsViewModel.self) private var streetsVM

    @State private var showingAddSheet = false
    @State private var sheetHeight = CGFloat.zero

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
            .refreshable {
                Task {
                    await streetsVM.fetchStreets()
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
                .presentationDetents([.height(sheetHeight)])
                .presentationDragIndicator(.visible)
                .environment(streetsVM)
                .onPreferenceChange(InnerHeightPreferenceKey.self) { sheetHeight = $0 }
        }
        .task {
            await streetsVM.fetchStreets()
        }
    }
}

#Preview {
    StreetsView()
        .environment(StreetsViewModel())
}
