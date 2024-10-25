//
//  selection_picker.swift
//  iTanks
//
//  Created by Jana Tahan  on 10/25/24.
//

import SwiftUI
import Foundation

struct SelectionPicker<T: Hashable>: View {
    @Binding var selectedValue: T
    let options: [T]
    let label: String

    var body: some View {
        VStack {
            Text(label)
                .font(.caption)
                .padding(.top)
            
            Picker(label, selection: $selectedValue) {
                ForEach(options, id: \.self) { option in
                    Text("\(option)")
                        .font(.caption)
                        .tag(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
    }
}
