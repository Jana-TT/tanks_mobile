//
//  SearchView.swift
//  iTanks
//
//  Created by Jana Tahan  on 10/30/24.
//

import SwiftUI

enum SortOrder {
    case ascending
    case descending
    case reset
}

struct SearchView: View {
    let selectedDivision: String
    let facilities: [Facility]
    @State private var searchText: String = ""
    @State private var filteredPropertyIds: [String] = []
    @State private var filteredOptions: [String] = []
    @State private var selectedForeman: String = ""
    @State private var selectedRoute: String = ""
    @State private var selectedFacility: String = ""
    @State private var filteredSourceKeys: [String] = [] //source key for chart data
    @FocusState private var isSearchFieldFocused: Bool //cursor
    
    @State private var sortedClicked: Bool = false
    @State private var sortedLevel: Bool = false
    @State private var sortedPercentFull: Bool = false
    @State private var sortedESD: Bool = false
    
    @State private var sortOrder: SortOrder = .reset
    
    var body: some View {
        VStack{
            
            HStack{
                Image(systemName: "magnifyingglass")
                
                TextField("Search by facility, foreman, or route", text: $searchText)
                    .onChange(of: searchText) { newValue in
                        if !newValue.isEmpty {
                            searchOptions()
                        } else {
                            filteredOptions = [] // hide options if search text is cleared
                        }
                    } //reset the filters and put grouping back
                    .focused($isSearchFieldFocused)
                    .onTapGesture {
                        sortedClicked = false
                        sortedLevel = false
                        sortedPercentFull = false
                        sortedESD = false
                    }
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                        isSearchFieldFocused = true
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
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
            
            //placeholder for sorting
            HStack {
                // Level
                Button(action: {
                    sortedPercentFull = false
                    sortedESD = false
                    
                    if sortOrder == .descending {
                        sortOrder = .ascending
                    } else if sortOrder == .ascending {
                        sortOrder = .reset
                        sortedClicked = false
                        sortedLevel = false
                    } else {
                        sortOrder = .descending
                        sortedClicked = true
                        sortedLevel = true
                        sortedPercentFull = false
                        sortedESD = false
                    }
                }) {
                    Text("Level")
                    if sortedLevel {
                        if sortOrder == .descending {
                            Image(systemName: "arrowshape.down")
                        } else if sortOrder == .ascending {
                            Image(systemName: "arrowshape.up")
                        }
                    }
                }
                .padding()

                // Percent Full
                Button(action: {
                    if sortOrder == .descending {
                        sortOrder = .ascending
                    } else if sortOrder == .ascending {
                        sortOrder = .reset
                        sortedClicked = false
                        sortedESD = false
                    } else {
                        sortOrder = .descending
                        sortedClicked = true
                        sortedPercentFull = true
                        sortedLevel = false
                        sortedESD = false
                    }
                }) {
                    Text("Percent Full")
                    if sortedPercentFull {
                        if sortOrder == .descending {
                            Image(systemName: "arrowshape.down")
                        } else if sortOrder == .ascending {
                            Image(systemName: "arrowshape.up")
                        }
                    }
                }
                .padding()

                // ESD Sorting
                Button(action: {
                    //sort order: descending -> ascending -> reset
                    if sortOrder == .descending {
                        sortOrder = .ascending
                    } else if sortOrder == .ascending {
                        sortOrder = .reset
                        sortedClicked = false 
                        sortedESD = false
                    } else {
                        sortOrder = .descending
                        sortedClicked = true
                        sortedESD = true
                        sortedLevel = false
                        sortedPercentFull = false
                    }
                }) {
                    Text("ESD")
                    if sortedESD {
                        if sortOrder == .descending {
                            Image(systemName: "arrowshape.down")
                        } else if sortOrder == .ascending {
                            Image(systemName: "arrowshape.up")
                        }
                    }
                }
                .padding()

            }
            
            //render tanks to my tank content view
            if !filteredPropertyIds.isEmpty {
                TanksContentView(property_ids: filteredPropertyIds, facilities: facilities, selectedForeman: selectedForeman, selectedRoute: selectedRoute, selectedFacility: selectedFacility, selectedSort: sortedClicked, sortedLevel: sortedLevel, sortedPercentFull: sortedPercentFull, sortedESD: sortedESD, sortOrder: sortOrder)
            }
            
        }
        .onAppear {
            filteredPropertyIds = facilities
                .filter { $0.division_name == selectedDivision }
                .map{ $0.property_id }
            filterPropertyIds()
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
        } //for "fuzzy" find
        .map { $0 } //back to an array
    }
    
    //selection & filter by selected
    private func selectionChosen(_ option: String) { //
        isSearchFieldFocused = false // Set this to true on selection
        searchText = option // Show selected option in search bar
        
        sortedClicked = false
        sortedLevel = false
        sortedPercentFull = false
        sortedESD = false
        sortOrder = .reset
        
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
        
        filterPropertyIds()
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
    private func filterPropertyIds() {
        filteredPropertyIds = facilities
            .filter { facility in
                facility.division_name == selectedDivision &&
                (facility.foreman_name == selectedForeman || selectedForeman.isEmpty) &&
                (facility.route_name == selectedRoute || selectedRoute.isEmpty) &&
                (facility.facility_name == selectedFacility || selectedFacility.isEmpty)
            }
            .map { $0.property_id }
    }
    
    //source_keys edit for chart data //needs to be done under tanks fetch
    private func filterSourceKeys() {
        filteredSourceKeys = facilities
            .filter { facility in			
                facility.division_name == selectedDivision &&
                (facility.foreman_name == selectedForeman || selectedForeman.isEmpty) &&
                (facility.route_name == selectedRoute || selectedRoute.isEmpty) &&
                (facility.facility_name == selectedFacility || selectedFacility.isEmpty)
            }
            .map { $0.property_id }
    }
}
