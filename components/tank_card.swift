//
//  tank_card.swift
//  iTanks
//
//  Created by Jana Tahan  on 10/24/24.
//

import SwiftUI

struct TankCardView: View {
    //passing in the tank data
    let tank: Tank
    
    var body: some View {
        VStack{
            PercentFullView(tank: tank)
        }
    }
}

