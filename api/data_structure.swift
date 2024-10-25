//
//  data_structure.swift
//  iTanks
//
//  Created by Jana Tahan  on 10/25/24.
//

import Foundation

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
