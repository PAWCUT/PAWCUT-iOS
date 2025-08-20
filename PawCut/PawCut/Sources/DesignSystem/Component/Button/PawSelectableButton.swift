//
//  PawSelectableButton.swift
//  PawCut
//
//  Created by donghee on 8/19/25.
//

import SwiftUI

struct PawSelectableButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .pretendardFont(size: ._14, weight: .semibold)
                    .foregroundColor(isSelected ? .pointPurple01 : .grayScale01)
                Spacer()
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? .pointPurple02 : .grayScale05)
                    .stroke(isSelected ? .pointPurple01 : .grayScale05, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 8) {
        PawSelectableButton(title: "벨소리", isSelected: true) {
            print("Selected")
        }
        PawSelectableButton(title: "벨소리", isSelected: false) {
            print("Not selected")
        }
    }
    .padding()
}
