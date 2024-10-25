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
    
                NavigationLink(destination: divisionView()) {
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
              
            }
    }
}

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
