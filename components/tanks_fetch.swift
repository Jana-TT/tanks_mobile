//
//  tanks_fetch.swift
//  iTanks
//
//  Created by Jana Tahan  on 10/23/24.
//

import SwiftUI
import Foundation

struct Tank: Codable, Identifiable {
    let id = UUID()
    let property_id: String
    let source_key: String
    let tank_type: String
    let tank_number: Int
    let level: Float
    let volume: Int
    let inches_to_esd: Float?
    let time_until_esd: Float?
    let capacity: Int
    let percent_full: Int
}

struct TankData: Codable {
    let tanks: [Tank]
}

struct RequestPayload: Codable {
    let property_ids: [String]
    let tank_types: [String]
}

struct TanksContentView: View {
    let property_ids: [String]  
    @State private var tanks: [Tank] = []
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else if tanks.isEmpty {
                Text("Loading...")
            } else {
                List(tanks) { tank in
                    VStack(alignment: .leading) {
                        TankCardView(tank: tank)
                    }
                }
            }
        }
        .onAppear {
            Task {
                await tanksFetch(property_ids: property_ids)
            }
        }
    }

    // Fetch tanks based on property IDs
    func tanksFetch(property_ids: [String]) async {
        let url = URL(string: "https://tanks-api.wolfeydev.com/tanks")!
        let payload = RequestPayload(property_ids: property_ids, tank_types: ["Oil", "Water"])

        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(payload)
            req.httpBody = jsonData

            let (data, response) = try await URLSession.shared.data(for: req)

            if let httpResponse = response as? HTTPURLResponse {
                print("Response status code: \(httpResponse.statusCode)")
            }

            let decodedData = try JSONDecoder().decode(TankData.self, from: data)
            tanks = decodedData.tanks

        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
