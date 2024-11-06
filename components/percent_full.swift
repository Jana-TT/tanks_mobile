//
//  percent_full.swift
//  iTanks
//
//  Created by Jana Tahan  on 10/24/24.
//

import SwiftUI

//to round corners i choose
struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
    
struct PercentFullView: View {
    let tank: Tank
    
    var body: some View {
        let capped_percent = min(tank.percent_full, 98)

        ZStack {
           
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color.gray, lineWidth: 2)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .topRight, .bottomLeft, .bottomRight]))
                .frame(width: 40, height: 70)
                .zIndex(1)
            
            VStack{
                Spacer()
                Rectangle()
                    .fill(tank.tank_type == "Oil" ? Color.green : Color.blue)
                    .frame(height: 70 * CGFloat(capped_percent) / 100)
                    .clipShape(RoundedCorner(radius: 15, corners: [.bottomLeft, .bottomRight]))
                    .clipShape(RoundedCorner(radius: 10, corners: [.topLeft, .topRight]))
                    .frame(maxWidth: .infinity)
            }

            Text("\(capped_percent)%")
                .font(.system(size: 14))
                .padding(.top, 5)
                .bold()
                .zIndex(2)
        }
        .frame(width: 40, height: 70)
    }
}
