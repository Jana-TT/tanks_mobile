//
//  tanks_fetch.swift
//  iTanks
//
//  Created by Jana Tahan  on 10/23/24.
//

import Foundation

struct Tank: Codable, Identifiable {
    let id = UUID()
    let property_id: String
    let source_key: String
    let tank_type: String
    let tank_number: Int
    let level: Int
    let volume: Int
    let inches_to_esd: Int?
    let time_until_esd: Int?
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

