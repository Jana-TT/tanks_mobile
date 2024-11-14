//
//  ChartView.swift
//  iTanks
//
//  Created by Jana Tahan  on 11/13/24.
//

import SwiftUI

struct ChartView: View {
    @State private var timeseries: [Timeseries] = []
    @State private var errorMessages: String?

    
    var body: some View {
        print("ppppppp")
    }
    
    private func timeseriesFetch(source_key: [String]) async {
        do {
            timeseries = try await TimeseriesFetcher.timeseriesFetch(source_key: source_key)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
