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
    let onDivisionChange: (String) -> Void

    var body: some View {
        Picker("Select a Division", selection: $selectedDivision) {
            Text("").tag("") // Add a default option to avoid warning
            ForEach(divisionNames, id: \.self) { division in
                Text(division).tag(division)
            }
        }
        .pickerStyle(MenuPickerStyle())
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        .onChange(of: selectedDivision) { newValue in
            onDivisionChange(newValue)
        }
    }
}

