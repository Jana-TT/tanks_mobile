//
//  facilities_fetch.swift
//  iTanks
//
//  Created by Jana Tahan  on 10/23/24.
//

import SwiftUI

struct MainView: View {
    let selectedDivision: String
    let facilities: [Facility]
    @State private var filteredPropertyIds: [String] = []
    @State private var selectedForeman: String = ""
    @State private var selectedRoute: String = ""
    @State private var selectedFacility: String = ""
    @State private var filteredFacilities: [Facility] = []
    
    @State private var showForemanPicker = false
    @State private var showRoutePicker = false

    var body: some View {
        VStack {
            FuzzySearch(selectedDivision: selectedDivision, selectedForeman: $selectedForeman, selectedRoute: $selectedRoute, facilities: filteredFacilities, selectedFacility: $selectedFacility)
            
            let foremanNames = Array(Set(facilities
                .filter { $0.division_name == selectedDivision }
                .map { $0.foreman_name }))
            
            // Foreman selection button
            HStack {
                Button(action: {
                    showForemanPicker.toggle()
                }) {
                    Text("Foreman: \(selectedForeman.isEmpty ? "Select Foreman" : selectedForeman)")
                        .font(.system(size: 16))
                        .bold()
                        .foregroundColor(.blue)
                }
                .sheet(isPresented: $showForemanPicker) {
                    // Foreman Picker View
                    List(foremanNames, id: \.self) { foreman in
                        Button(action: {
                            selectedForeman = foreman
                            selectedRoute = ""
                            updateFilteredFacilities()
                            showForemanPicker = false
                        }) {
                            Text(foreman)
                        }
                    }
                    .navigationTitle("Select Foreman")
                }
            }
            
            Spacer()
            
            // Route filter
            if !selectedForeman.isEmpty {
                let routeNames = Array(Set(facilities
                    .filter { $0.division_name == selectedDivision && $0.foreman_name == selectedForeman }
                    .map { $0.route_name }))
                
                // Route selection button
                HStack {
                    Button(action: {
                        showRoutePicker.toggle()
                    }) {
                        Text("Route: \(selectedRoute.isEmpty ? "Select Route" : selectedRoute)")
                            .font(.system(size: 16))
                            .bold()
                            .foregroundColor(.blue)
                    }
                    .sheet(isPresented: $showRoutePicker) {
                        List(routeNames, id: \.self) { route in
                            Button(action: {
                                selectedRoute = route
                                updateFilteredFacilities()
                                showRoutePicker = false
                            }) {
                                Text(route)
                            }
                        }
                        .navigationTitle("Select Route")
                    }
                }
            }
            
            // Show filtered tanks
            if !filteredPropertyIds.isEmpty {
                TanksContentView(property_ids: filteredPropertyIds, facilities: facilities, selectedForeman: selectedForeman, selectedRoute: selectedRoute, selectedFacility: selectedFacility)
            }
        }
        .onAppear {
            filteredPropertyIds = facilities
                .filter { $0.division_name == selectedDivision }
                .map { $0.property_id }
            updateFilteredFacilities()
        }
    }
    
    private func updateFilteredFacilities() {
        filteredFacilities = facilities.filter { facility in
            facility.division_name == selectedDivision &&
            (selectedForeman.isEmpty || facility.foreman_name == selectedForeman) &&
            (selectedRoute.isEmpty || facility.route_name == selectedRoute)
        }
    }
}

//fix tmr
struct FuzzySearch: View {
    let selectedDivision: String
    @Binding var selectedForeman: String
    @Binding var selectedRoute: String
    let facilities: [Facility]
    @Binding var selectedFacility: String
    
    @State private var searchText: String = ""
    @State private var filteredFacilityNames: [String] = []
    @State private var isSearching: Bool = false
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        VStack {
            TextField("Search facilities", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .focused($isTextFieldFocused)
                .onChange(of: searchText) { newValue in
                    isSearching = !newValue.isEmpty || isTextFieldFocused
                    filterFacilities(with: newValue)
                }
                .onTapGesture {
                    // Show list when clicked
                    isSearching = true
                }
            
            // Show the filtered facilities list when typing
            if isSearching {
                FacilityListView(
                    facilities: filteredFacilityNames,
                    selectedFacility: $selectedFacility,
                    onFacilitySelect: { selected in
                        // if selected, set it close the list
                        searchText = selected
                        selectedFacility = selected
                        isSearching = false
                        isTextFieldFocused = false
                    }
                )
            }
        }
        .onAppear {
            filterFacilities(with: searchText)
        }
        .onChange(of: selectedFacility) { newValue in
            // Clear search text when a facility is selected
            if !newValue.isEmpty {
                searchText = newValue
                isSearching = false
            }
        }
    }

    // to filter facs based on search
    private func filterFacilities(with query: String) {
        filteredFacilityNames = facilities
            .filter { facility in
                facility.division_name == selectedDivision &&
                (query.isEmpty || facility.facility_name.localizedCaseInsensitiveContains(query))
            }
            .map { $0.facility_name }
    }
}

struct FacilityListView: View {
    let facilities: [String]
    @Binding var selectedFacility: String
    var onFacilitySelect: ((String) -> Void)?

    var body: some View {
        List(facilities, id: \.self) { facility in
            Text(facility)
                .onTapGesture {
                    //basically calls parent function of it
                    onFacilitySelect?(facility)
                }
        }
        .listStyle(PlainListStyle())
        .frame(height: 200) 
    }
}
