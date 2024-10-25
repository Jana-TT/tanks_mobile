//
//  HomeView.swift
//  iTanks
//
//  Created by Jana Tahan  on 10/25/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                
                HStack {
                    Image(systemName: "book.fill")
                        .foregroundColor(.white)
                    Link("Docs", destination: URL(string: "https://tanks-api.wolfeydev.com/docs")!)
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(8)
                .padding([.top, .leading], 16)
                
                VStack {
                    Spacer()
                    
                    Text("Begin by selecting a division to view tanks")
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 20)
                    
                    NavigationLink(
                        destination: MainView(),
                        label: {
                            Text("Select Division")
                                .font(.headline)
                                .padding()
                                .background(Color.gray.opacity(0.5))
                                .cornerRadius(8)
                        }
                    )
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

// Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
