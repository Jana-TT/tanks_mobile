//
//  SearchView.swift
//  iTanks
//
//  Created by Jana Tahan  on 10/30/24.
//

import SwiftUI

struct SearchView: View {
    let selectedDivision: String
    let facilities: [Facility]
    @State private var searchText: String = ""
    @State private var filteredPropertyIds: [String] = []
    @State private var filteredOptions: [String] = []
    @State private var selectedForeman: String = ""
    @State private var selectedRoute: String = ""
    @State private var selectedFacility: String = ""
    @FocusState private var isSearchFieldFocused: Bool
    
    var body: some View {
        VStack{
            
            HStack{
                Image(systemName: "magnifyingglass")
                
                TextField("Search by facility, foreman, or route", text: $searchText)
                    .onChange(of: searchText) { newValue in
                        searchOptions()
                    }
                    .focused($isSearchFieldFocused)
            }
            .padding()
            
            //list the filtered options
            if isSearchFieldFocused && !filteredOptions.isEmpty {
                List(filteredOptions, id: \.self) { option in
                    Button(action: { selectionChosen(option)
                    }) {
                        HStack{
                            iconType(for: option)
                                .foregroundColor(colorType(for: option))
                            
                            Text(option)
                                .foregroundStyle(colorType(for: option))
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            
            //render tanks
            if !filteredPropertyIds.isEmpty {
                TanksContentView(property_ids: filteredPropertyIds, facilities: facilities, selectedForeman: selectedForeman, selectedRoute: selectedRoute, selectedFacility: selectedFacility)
            }
            
        }
        .onAppear {
            filteredPropertyIds = facilities
                .filter { $0.division_name == selectedDivision }
                .map{ $0.property_id }
            filterFacilities()
        }
    }
    
    //the options in search
    private func searchOptions() {
        let uniqueOptions = facilities
            .filter { $0.division_name == selectedDivision }
            .flatMap { facility in
                [facility.foreman_name, facility.route_name, facility.facility_name]
            }
            .reduce (into: Set<String>()) { $0.insert($1) } //creates my set
            
        filteredOptions = uniqueOptions.filter { option in
            option.localizedCaseInsensitiveContains(searchText) || searchText.isEmpty
        }
        .map { $0 } //back to an array
    }
    
    //selection & filter by selected
    private func selectionChosen(_ option: String) {
        isSearchFieldFocused = false // Set this to true on selection
        searchText = option // Show selected option in search bar
        
        if facilities.contains(where: { $0.foreman_name == option}) {
            selectedForeman = option
            selectedRoute = ""
            selectedFacility = ""
        } else if facilities.contains(where: { $0.route_name == option}){
            selectedForeman = ""
            selectedRoute = option
            selectedFacility = ""
        } else if facilities.contains(where: { $0.facility_name == option}) {
            selectedForeman = ""
            selectedRoute = ""
            selectedFacility = option
        }
        
        filterFacilities()
    }
    
    //color and icon based on type
    private func iconType(for option: String) -> Image {
        if facilities.contains(where: { $0.foreman_name == option }) {
            return Image(systemName: "person.fill")
        } else if facilities.contains(where: { $0.route_name == option }) {
            return Image(systemName: "map.fill")
        } else {
            return Image(systemName: "building.2.fill")
        }
    }
    
    private func colorType(for option: String) -> Color {
        if facilities.contains(where: { $0.foreman_name == option }) {
            return .green
        } else if facilities.contains(where: { $0.route_name == option }) {
            return .blue
        } else {
            return .orange
        }
    }
    
    //filter the facs
    private func filterFacilities() {
        filteredPropertyIds = facilities
            .filter { facility in
                facility.division_name == selectedDivision &&
                (facility.foreman_name == selectedForeman || selectedForeman.isEmpty) &&
                (facility.route_name == selectedRoute || selectedRoute.isEmpty) &&
                (facility.facility_name == selectedFacility || selectedFacility.isEmpty)
            }
            .map { $0.property_id }
    }
    
}
