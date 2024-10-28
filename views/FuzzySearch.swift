//
//  FuzzySearch.swift
//  iTanks
//
//  Created by Jana Tahan  on 10/28/24.
//

import SwiftUI

struct FuzzySearch: View {
    let selectedDivision: String
    let facilities: [Facility] = []
    @State private var searchText: String = ""
    @State private var filteredFacilities: [String] = []
    
    var body: some View {
        VStack{
            TextField("Search facilities", text:$searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            List(filteredFacilities, id: \.self) { facility in
                Text(facility)
            }
        }
    }
    
    private func filterFacilities(with query: String) {
        if query.isEmpty {
            filteredFacilities = facilities
                .filter { $0.division_name == selectedDivision}
                .map{ $0.facility_name}
        }
    }
}
