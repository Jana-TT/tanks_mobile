//
//  facilities_fetch.swift
//  iTanks
//
//  Created by Jana Tahan  on 10/23/24.
//

import SwiftUI
import Foundation

// Define the Facility and FacilityData types
struct Facility: Codable, Identifiable {
    let id = UUID() // For SwiftUI Identifiable conformance
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

// Define the view
struct twoContentView: View {
    @State private var facilities: [Facility] = []
    @State private var errorMessage: String?
    @State private var divisionNames: [String] = []
    @State private var selectedDivision: String = "" 

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
                        Picker("Select a Division", selection: $selectedDivision) {
                            ForEach(divisionNames, id: \.self) { division in
                                Text(division).tag(division)
                            }
                        }
                        .pickerStyle(MenuPickerStyle()) // Dropdown style
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        
                        Menu("Division Name") {
                            ForEach(divisionNames, id: \.self) {
                                division in Text(division).tag(division)
                            }
                        }
                        
                    }
                }
            }
            .navigationTitle("Facilities")
            .onAppear {
                Task {
                    await facilitiesFetch()
                }
            }
        }
    }

    
    func facilitiesFetch() async {
        // Creating the URL object
        guard let url = URL(string: "https://tanks-api.wolfeydev.com/facilities") else {
            errorMessage = "Invalid URL"
            return
        }

        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let (data, response) = try await URLSession.shared.data(for: req)

            // Checking for a valid HTTP response
            if let httpResponse = response as? HTTPURLResponse {
                print("Response status code: \(httpResponse.statusCode)")
            }

            // Decoding the JSON data
            let decodedData = try JSONDecoder().decode(FacilityData.self, from: data)

            // Update the facilities state
            facilities = decodedData.facilities

            //unique division nmaes
            divisionNames = Array(Set(facilities.map { $0.division_name })).sorted()

        } catch {
            
            errorMessage = error.localizedDescription
            print("Error: \(error.localizedDescription)")
        }
    }
}

// Preview
#Preview {
    twoContentView()
}
