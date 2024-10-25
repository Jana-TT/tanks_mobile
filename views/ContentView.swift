//
//  ContentView.swift
//  iTanks
//
//  Created by Jana Tahan  on 10/23/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                // NavigationLink for Facilities
                NavigationLink(destination: twoContentView()) {
                    Text("Division Name")
                        .font(.headline)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.black)
                        .cornerRadius(8)
                }
                

                Text("Begin by selecting a division to view tanks")
                    .padding()
            }
            .navigationTitle("iTanks")  // Optional: Add a title to the navigation bar
        }
    }
}

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
