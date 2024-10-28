//
//  facilities_fetch.swift
//  iTanks
//
//  Created by Jana Tahan  on 10/23/24.
//

import SwiftUI

struct MainView: View {
    let selectedDivision: String //parameters / input
    let facilities: [Facility] //parameters / input
    @State private var filteredPropertyIds: [String] = []
    @State private var selectedForeman: String = ""
    @State private var selectedRoute: String = ""
    @State private var selectedFacility: String = ""
    
    var body: some View {
        VStack {
            
            FuzzySearch(selectedDivision: selectedDivision, facilities: facilities)
            
            // Foreman filter
            let foremanNames = Array(Set(facilities
                .filter { $0.division_name == selectedDivision }
                .map { $0.foreman_name }))

            HStack{
                Text("Foreman:")
                    .font(.system(size: 16))
                    .bold()
                
                Picker("Select Foreman", selection: $selectedForeman) {
                    ForEach(foremanNames, id: \.self) { foreman in
                        Text(foreman).tag(foreman)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .scaleEffect(0.9)
                .onChange(of: selectedForeman) { _ in
                    selectedRoute = ""
                    selectedFacility = ""
                }
            }
            
            
            // Route filter based on selected foreman
            if !selectedForeman.isEmpty {
                let routeNames = Array(Set(facilities
                    .filter { $0.division_name == selectedDivision && $0.foreman_name == selectedForeman }
                    .map { $0.route_name }))
                
                HStack{
                    Text("Route:")
                        .font(.system(size: 16))
                        .bold()
                    
                    Picker("Select Route", selection: $selectedRoute) {
                        ForEach(routeNames, id: \.self) { route in
                            Text(route).tag(route)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .scaleEffect(0.9)
                }
                
            }
            
            // Facility filter based on selected route
            if !selectedRoute.isEmpty {
                let facilityNames = Array(Set(facilities
                    .filter { $0.division_name == selectedDivision && $0.foreman_name == selectedForeman && $0.route_name == selectedRoute }
                    .map { $0.facility_name }))
                
                HStack{
                    Text("Facility:")
                        .font(.system(size: 16))
                        .bold()
                    
                    Picker("Select Facility", selection: $selectedFacility) {
                        ForEach(facilityNames, id: \.self) { facility in
                            Text(facility).tag(facility)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .scaleEffect(0.9)
                }
            }
            
            // Show filtered tanks
            if !filteredPropertyIds.isEmpty {
                TanksContentView(property_ids: filteredPropertyIds, facilities: facilities, selectedForeman: selectedForeman, selectedRoute: selectedRoute, selectedFacility: selectedFacility)
            } else {
                Text("Please select filters to view the tanks.")
                    .padding()
            }
        }

        .onAppear { //from my division view so TanksContentView has the filtered ids
            filteredPropertyIds = facilities
                .filter { $0.division_name == selectedDivision }
                .map { $0.property_id }
        }
    }
}
