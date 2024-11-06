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
    let selectedSort: Bool
    let sortedLevel: Bool
    let sortedPercentFull: Bool
    let sortedESD: Bool
    let sortOrder: SortOrder
    @State private var tanks: [Tank] = []
    @State private var errorMessage: String?
    
    @State private var selectedSortCriterion: String = "None"

    // Step-by-step filtered list of tanks because swift cant handle complex stuff..
    var filteredTanks: [Tank] {
        let tanksMatchingProperties = tanks.filter { property_ids.contains($0.property_id) }
        
        let tanksMatchingForeman = selectedForeman.isEmpty
            ? tanksMatchingProperties
            : tanksMatchingProperties.filter { tank in
                facilities.first(where: { $0.property_id == tank.property_id })?.foreman_name == selectedForeman
            }
        
        let tanksMatchingRoute = selectedRoute.isEmpty
            ? tanksMatchingForeman
            : tanksMatchingForeman.filter { tank in
                facilities.first(where: { $0.property_id == tank.property_id })?.route_name == selectedRoute
            }
        
        let filtered = selectedFacility.isEmpty
            ? tanksMatchingRoute
            : tanksMatchingRoute.filter { tank in
                facilities.first(where: { $0.property_id == tank.property_id })?.facility_name == selectedFacility
            }
        
        // Sorting based on the selected criteria
        return sortTanks(tanks: filtered)
    }
    
    // Sort tanks based on criteria 
    private func sortTanks(tanks: [Tank]) -> [Tank] {
        var sortedTanks = tanks
        
        if sortedLevel {
            sortedTanks.sort { tank1, tank2 in
                sortOrder == .ascending ? tank1.level < tank2.level : tank2.level < tank1.level
            }
        } else if sortedPercentFull {
            sortedTanks.sort { tank1, tank2 in
                sortOrder == .ascending ? tank1.percent_full < tank2.percent_full : tank2.percent_full < tank1.percent_full
            }
        } else if sortedESD {
            sortedTanks.sort { (tank1, tank2) -> Bool in
                switch (tank1.inches_to_esd, tank2.inches_to_esd) {
                case (let esd1?, let esd2?): // Both are not nil
                    return sortOrder == .ascending ? esd1 < esd2 : esd2 < esd1
                case (nil, let esd2?): // tank1 is nil, tank2 is not
                    return false // tank2 is less than tank1
                case (let esd1?, nil): // tank2 is nil, tank1 is not
                    return true // tank1 is less than tank2
                case (nil, nil): // both are nil
                    return false // equal
                }
            }
        }

        return sortedTanks
    }

    // Grouped tanks by property ID for the grouped view
    var groupedTanks: [String: [Tank]] {
        Dictionary(grouping: filteredTanks) { $0.property_id }
    }

    var body: some View {
        List {
            if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else if tanks.isEmpty {
                Text("Loading...")
            } else if selectedSort {
                ForEach(filteredTanks) { tank in
                    if let facility = facilities.first(where: { $0.property_id == tank.property_id }) {
                        TankCardView(facility: facility, tank: tank, selectedSort: selectedSort)
                    }
                }
            } else {
                ForEach(facilities.filter { property_ids.contains($0.property_id) }) { facility in
                    if let facilityTanks = groupedTanks[facility.property_id] {
                        Section(header: Text(facility.facility_name)
                                    .bold()
                                    .font(.system(size: 17))
                                    .foregroundColor(.gray)) {
                            ForEach(facilityTanks) { tank in
                                TankCardView(facility: facility, tank: tank, selectedSort: selectedSort)
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
