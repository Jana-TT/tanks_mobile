//
//  tanks_fetch.swift
//  iTanks
//
//  Created by Jana Tahan  on 10/23/24.
//

import SwiftUI
import Foundation

struct TanksContentView: View {
    let property_ids: [String]
    let facilities: [Facility]
    let selectedForeman: String
    let selectedRoute: String
    let selectedFacility: String
    @State private var tanks: [Tank] = []
    @State private var errorMessage: String?

    var groupedTanks: [String: [Tank]] {
        Dictionary(grouping: tanks.filter { property_ids.contains($0.property_id) }) { $0.property_id }
    }

    var body: some View {
        List {
            if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else if tanks.isEmpty {
                Text("Loading...")
            } else {
                ForEach(facilities.filter { property_ids.contains($0.property_id) && ($0.foreman_name == selectedForeman || selectedForeman.isEmpty) && ($0.route_name == selectedRoute || selectedRoute.isEmpty) && ($0.facility_name == selectedFacility || selectedFacility.isEmpty)}) { facility in
                    if let facilityTanks = groupedTanks[facility.property_id] {
                        Section(header: Text(facility.facility_name)
                                    .bold()
                                    .font(.system(size: 17))
                                    .foregroundColor(.gray)) {
                            ForEach(facilityTanks) { tank in
                                TankCardView(tank: tank)
                            }
                        }
                    }
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline) 
        .listStyle(PlainListStyle())
        .onAppear {
            Task {
                await tanksFetch(property_ids: property_ids)
            }
        }
        .onChange(of: property_ids) { newValue in
            Task {
                await tanksFetch(property_ids: newValue)
            }
        }
    }

    private func tanksFetch(property_ids: [String]) async {
        do {
            tanks = try await TanksFetcher.tanksFetch(property_ids: property_ids)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
