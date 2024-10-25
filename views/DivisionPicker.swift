//
//  DivisionPicker.swift
//  iTanks
//
//  Created by Jana Tahan  on 10/25/24.
//

import SwiftUI
import Foundation

struct DivisionPicker: View {
    @Binding var selectedDivision: String
    let divisionNames: [String]
    
    var body: some View {
        VStack {
            Text("Division name")
                .font(.caption)
                .padding(.top)
            
            Picker("Select a Division", selection: $selectedDivision) {
                ForEach(divisionNames, id: \.self) { division in
                    Text(division).tag(division)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
    }
}
