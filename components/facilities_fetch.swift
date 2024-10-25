//
//  facilities_fetch.swift
//  iTanks
//
//  Created by Jana Tahan  on 10/23/24.
//

//
//  facilities_fetch.swift
//  iTanks
//
//  Created by Jana Tahan  on 10/23/24.
//

import SwiftUI
import Foundation

// Facility and FacilityData structures
struct Facility: Codable, Identifiable {
    let id = UUID()
    let property_id: String
    let division_name: String
    let division_id: Int
    let facility_name: String
    let route_name: String
    let foreman_name: String
}

struct FacilityData: Codable {
    let facilities: [Facility]
}

struct divisionView: View {
    @State private var facilities: [Facility] = []
    @State private var errorMessage: String?
    @State private var divisionNames: [String] = []
    @State private var selectedDivision: String = ""
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
                        Picker("Select a Division", selection: $selectedDivision) {
                            ForEach(divisionNames, id: \.self) { division in
                                Text(division).tag(division)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .onChange(of: selectedDivision) { newValue in
                            filteredPropertyIds = facilities
                                .filter { $0.division_name == newValue }
                                .map { $0.property_id }
                        }
                        
                        if !filteredPropertyIds.isEmpty {
                            TanksContentView(property_ids: filteredPropertyIds, facilities: facilities)
                        } else {
                            Text("Please select a division to view the tanks.")
                                .padding()
                        }
                    }
                }
            }
            
            .onAppear {
                Task {
                    await facilitiesFetch()
                }
            }
        }
    }

    // Fetch facility data
    func facilitiesFetch() async {
        let url = URL(string: "https://tanks-api.wolfeydev.com/facilities")!
        
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let (data, response) = try await URLSession.shared.data(for: req)

            if let httpResponse = response as? HTTPURLResponse {
                print("Response status code: \(httpResponse.statusCode)")
            }

            let decodedData = try JSONDecoder().decode(FacilityData.self, from: data)
            facilities = decodedData.facilities
            divisionNames = Array(Set(facilities.map { $0.division_name })).sorted()

        } catch {
            errorMessage = error.localizedDescription
        }
    }
}


//Preview
struct divisionView_preview: PreviewProvider {
    static var previews: some View {
        divisionView()
    }
}
