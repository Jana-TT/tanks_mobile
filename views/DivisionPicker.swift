//
//  DivisionPicker.swift
//  iTanks
//
//  Created by Jana Tahan  on 10/25/24.
//

import SwiftUI

struct DivisionView: View {
    @State private var selectedDivision: String = ""
    @State private var divisionNames: [String] = []
    @State private var facilities: [Facility] = []
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack {
                Spacer()

                if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 20)
                } else {    
                    Text("Begin by selecting a division to view tanks")
                        .font(.system(size: 18))
                        .fontWeight(.heavy)
                        .multilineTextAlignment(.center)
                        .padding(.top, 100)
                        .padding(.bottom, 30)

                    List(divisionNames, id: \.self) { division in
                        NavigationLink(
                            destination: SearchView(selectedDivision: division, facilities: facilities)
                                .onAppear {
                                    selectedDivision = division
                                    //print("Selected Division: \(selectedDivision)") 
                                }
                        ) {
                            Text(division)
                                .padding(8)
                        }
                    }
                    .listStyle(PlainListStyle())
                }

                Spacer()
            }
            .padding()
            .navigationTitle(selectedDivision.isEmpty ? "Select Division" : selectedDivision)
            .toolbar(.hidden)
            .onAppear {
                Task {
                    do {
                        facilities = try await FacilityFetcher.fetchFacilities()
                        divisionNames = Array(Set(facilities.map { $0.division_name })).sorted()
                    } catch {
                        errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
}

struct DivisionPickerView_Previews: PreviewProvider {
    static var previews: some View {
        DivisionView()
    }
}
