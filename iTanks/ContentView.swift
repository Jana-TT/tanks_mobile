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
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world pp ffffff!")
                    .padding()
                
                // NavigationLink for Facilities
                NavigationLink(destination: twoContentView()) {
                    Text("Facilities")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                // NavigationLink for Tanks
                NavigationLink(destination: TanksContentView()) {
                    Text("Tanks")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
    }
}

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
