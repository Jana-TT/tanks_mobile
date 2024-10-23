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
    
    var body: some View {
        NavigationView {
            VStack {
                if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                } else if facilities.isEmpty {
                    Text("Loading...")
                } else {
                    List(facilities) { facility in
                        VStack(alignment: .leading) {
                            Text(facility.facility_name)
                                .font(.headline)
                            Text(facility.facility_name)
                                .font(.headline);
                            Text(facility.property_id)
                                .font(.headline)                        }
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
            
            // Decode the JSON data into FacilityData
            let decodedData = try JSONDecoder().decode(FacilityData.self, from: data)
            
            // Update the facilities state directly
            facilities = decodedData.facilities
        } catch {
            // Handling error
            errorMessage = error.localizedDescription
            print("Error: \(error.localizedDescription)")
        }
    }
}


// Preview
#Preview {
    twoContentView()
}
