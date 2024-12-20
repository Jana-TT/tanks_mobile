//
//  tank_card.swift
//  iTanks
//
//  Created by Jana Tahan  on 10/24/24.
//

import SwiftUI

func inches_to_feet(inches: Float?) -> String {
    guard let inches = inches else {
        return "" }
    
    var feet = inches / 12
    feet = round(feet * 10) / 10
    let feet_string = String(format: "%.1f", feet)
    let parts = feet_string.split(separator: ".")
    
    let feet_part = parts[0]
    let inch_part = parts[1]
    
    return "\(feet_part)'" + "\(inch_part)\""
}

struct TankCardView: View {
    let facility: Facility
    let tank: Tank
    let selectedSort: Bool
    
    var body: some View {
        
        if selectedSort {
            HStack {
                PercentFullView(tank: tank)
                
                VStack(alignment: .leading) {

                    Text("\(facility.facility_name)")
                        .bold()
                    Text("\(tank.tank_type) Tank #\(tank.tank_number)")
                        .bold()
                    
                    Text("Capacity: " + "\(tank.capacity)")
                        .font(.caption)
                    
                    if let inchesToESD = tank.inches_to_esd {
                        Text("\(inches_to_feet(inches: inchesToESD)) to ESD")
                            .padding(6)
                            .font(.system(size: 14))
                            .bold()
                            .foregroundColor(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.blue.opacity(0.6))
                            )
                    } else {
                        Text("")
                    }
                }
                
                Spacer()
                
                HStack(spacing: 30) {
                    VStack {
                        Text("\(inches_to_feet(inches: tank.level))")
                            .foregroundColor(tank.tank_type == "Oil" ? Color.green : Color.blue)
                        Text("Level")
                            .foregroundColor(tank.tank_type == "Oil" ? Color.green : Color.blue)
                    }
                    
                    VStack {
                        Text("\(tank.volume)")
                            .foregroundColor(tank.tank_type == "Oil" ? Color.green : Color.blue)
                        Text("BBL")
                            .foregroundColor(tank.tank_type == "Oil" ? Color.green : Color.blue)
                    }
                }
            }
        } else {
            HStack {
                PercentFullView(tank: tank)
                
                VStack(alignment: .leading) {
                    Text("\(tank.tank_type) Tank #\(tank.tank_number)")
                        .bold()
                    
                    Text("Capacity: " + "\(tank.capacity)")
                        .font(.caption)
                    
                    if let inchesToESD = tank.inches_to_esd {
                        Text("\(inches_to_feet(inches: inchesToESD)) to ESD")
                            .padding(6)
                            .font(.system(size: 14))
                            .bold()
                            .foregroundColor(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.blue.opacity(0.6))
                            )
                    } else {
                        Text("")
                    }
                }
                
                Spacer()
                
                HStack(spacing: 30) {
                    VStack {
                        Text("\(inches_to_feet(inches: tank.level))")
                            .foregroundColor(tank.tank_type == "Oil" ? Color.green : Color.blue)
                        Text("Level")
                            .foregroundColor(tank.tank_type == "Oil" ? Color.green : Color.blue)
                    }
                    
                    VStack {
                        Text("\(tank.volume)")
                            .foregroundColor(tank.tank_type == "Oil" ? Color.green : Color.blue)
                        Text("BBL")
                            .foregroundColor(tank.tank_type == "Oil" ? Color.green : Color.blue)
                    }
                }
            }
        }
    }
}


