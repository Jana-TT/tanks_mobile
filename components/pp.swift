//
//  pp.swift
//  iTanks
//
//  Created by Jana Tahan  on 10/24/24.
//

import SwiftUI

struct ppTankCardView: View {
    let tank: Tank  // Pass the tank data into the card

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            
            Text("Tank Number: \(tank.tank_number)")
                .font(.headline)

            HStack {
                Text("Level: \(tank.level, specifier: "%.2f")")
                    .font(.subheadline)
                Spacer()
                Text("Volume: \(tank.volume)")
                    .font(.subheadline)
            }

            if let inchesToESD = tank.inches_to_esd {
                Text("Inches to ESD: \(inchesToESD, specifier: "%.2f")")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            if let timeUntilESD = tank.time_until_esd {
                Text("Time until ESD: \(timeUntilESD, specifier: "%.2f") hrs")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Text("Percent Full: \(tank.percent_full)%")
                .font(.subheadline)

        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}
