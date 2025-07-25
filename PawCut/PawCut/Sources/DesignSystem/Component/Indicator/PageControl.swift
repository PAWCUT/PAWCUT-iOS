//
//  PageControl.swift
//  PawCut
//
//  Created by Ethan on 7/25/25.
//

import SwiftUI

struct PageControl: View {
    let numberOfPages: Int
    let currentPage: Int
    var activeColor: Color = .pointPurple01
    var inactiveColor: Color = .grayScale03
    var dotSize: CGFloat = 5
    var spacing: CGFloat = 11
    
    var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<numberOfPages, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? activeColor : inactiveColor)
                    .frame(width: dotSize, height: dotSize)
            }
        }
    }
}
#Preview {
    VStack {
        PageControl(
            numberOfPages: 3,
            currentPage: 0,
            activeColor: .pointPurple01,
            inactiveColor: .grayScale03
        )
    }
    .padding()
    .background(Color.white)
}
