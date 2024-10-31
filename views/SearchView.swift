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
    
    var body: some View {
        VStack{
            
            HStack{
                Image(systemName: "magnifyingglass")
                
                TextField("Search by facility, foreman, or route", text: $searchText)
            }
            .padding()
            
            //list the filtered options
            List(filteredOptions, id: .\self) { option in
                Text(option)
                colorIcon(for: option)
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
    private func selectionChosen() {
        
    }
    
    //color and icon based on type
    private func colorIcon(for option: String) -> (Color, Image) {
        if facilities.contains(where: { $0.foreman_name == option}) {
            let color = Color.green
            let image = Image(systemName: "person.fill")
            return (color, image)
        } else if facilities.contains(where: { $0.route_name == option }) {
            let color = Color.yellow
            let image = Image(systemName: "map.fill")
            return (color, image)
        } else {
            let color = Color.orange
            let image = Image(systemName: "builind.2.fill")
            return (color, image)
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
