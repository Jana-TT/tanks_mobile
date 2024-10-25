//
//  DivisionView.swift
//  iTanks
//
//  Created by Jana Tahan  on 10/23/24.
//

import SwiftUI

struct DivisionPickerView: View {
    @Binding var selectedDivision: String
    let divisionNames: [String]

    var body: some View {
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
        