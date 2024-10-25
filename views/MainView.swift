//
//  facilities_fetch.swift
//  iTanks
//
//  Created by Jana Tahan  on 10/23/24.
//

import SwiftUI
import Foundation

struct MainView: View {
    @State private var facilities: [Facility] = []
    @State private var errorMessage: String?
    @State private var divisionNames: [String] = []
    @State private var selectedDivision: String = ""
    @State private var selectedForeman: String = ""
    @State private var selectedRoute: String = ""
    @State private var selectedFacility: String = ""
    @State private var filteredPropertyIds: [String] = []

    var body: some View {
        NavigationView {
            VStack {
                if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                } else if facilities.isEmpty {
                    Text("Loading...")
                } else {
                    VStack {
                        // Division Picker
                        DivisionPicker(selectedDivision: $selectedDivision, divisionNames: divisionNames)
                            .onChange(of: selectedDivision) { newValue in
                                filteredPropertyIds = facilities
                                    .filter { $0.division_name == newValue }
                                    .map { $0.property_id }
                                // Reset selections
                                selectedForeman = ""
                                selectedRoute = ""
                                selectedFacility = ""
                            }

                        // Horizontal alignment of pickers
                        if !selectedDivision.isEmpty {
                            HStack {
                                let foremanNames = Array(Set(facilities
                                    .filter { $0.division_name == selectedDivision }
                                    .map { $0.foreman_name }))
                                
                                // Foreman Picker
                                SelectionPicker(selectedValue: $selectedForeman, options: foremanNames, label: "Foreman name")
                                    .onChange(of: selectedForeman) { _ in
                                        // Reset selections when foreman changes
                                        selectedRoute = ""
                                        selectedFacility = ""
                                    }

                                // Route Picker
                                if !selectedForeman.isEmpty {
                                    let routeNames = Array(Set(facilities
                                        .filter { $0.division_name == selectedDivision && $0.foreman_name == selectedForeman }
                                        .map { $0.route_name }))
                                    
                                    SelectionPicker(selectedValue: $selectedRoute, options: routeNames, label: "Route name")
                                }

                                // Facility Picker
                                if !selectedRoute.isEmpty {
                                    let facilityNames = Array(Set(facilities
                                        .filter { $0.division_name == selectedDivision && $0.foreman_name == selectedForeman && $0.route_name == selectedRoute }
                                        .map { $0.facility_name }))
                                    
                                    SelectionPicker(selectedValue: $selectedFacility, options: facilityNames, label: "Facility name")
                                }
                            }
                            .padding()
                        }

                        //tanks based on selections
                        if !filteredPropertyIds.isEmpty {
                            TanksContentView(property_ids: filteredPropertyIds, facilities: facilities, selectedForeman: selectedForeman, selectedRoute: selectedRoute, selectedFacility: selectedFacility)
                        } else {
                            Text("Please select a division to view the tanks.")
                                .padding()
                        }
                    }
                }
            }
            .onAppear {
                Task {
                    do {
                        facilities = try await FacilityFetcher.fetchFacilities()
                        divisionNames = Array(Set(facilities.map { $0.division_name })).sorted()
                    } catch {
                        errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
}

// Preview
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

