//
//  data_fetch.swift
//  iTanks
//
//  Created by Jana Tahan  on 10/25/24.
//

import Foundation

struct FacilityFetcher {
    static func fetchFacilities() async throws -> [Facility] {
        let url = URL(string: "https://tanks-api.wolfeydev.com/facilities")!
        
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, response) = try await URLSession.shared.data(for: req)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let decodedData = try JSONDecoder().decode(FacilityData.self, from: data)
        return decodedData.facilities
    }
}

struct TanksFetcher {
    static func tanksFetch(property_ids: [String]) async throws -> [Tank] {
        let url = URL(string: "https://tanks-api.wolfeydev.com/tanks")!
        let payload = RequestPayload(property_ids: property_ids, tank_types: ["Oil", "Water"])
        
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonData = try JSONEncoder().encode(payload)
        req.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: req)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decodedData = try JSONDecoder().decode(TankData.self, from: data)
        return decodedData.tanks
    }
}

struct TimeseriesFetcher {
    static func timeseries(source_key: [String]) async throws -> [Timeseries] {
        let url = URL(string: "https://tanks-api.wolfeydev.com/tanks_timestamps")!
        let payload = RequestPayloadTS(source_key: source_key)
        
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonData = try JSONEncoder().encode(payload)
        req.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: req)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decodedData = try JSONDecoder().decode(TimeseriesData.self, from: data)
        return decodedData.timeseries
    }
}
